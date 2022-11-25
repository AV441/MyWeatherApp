//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Андрей on 19.05.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = CollectionRefreshControl()
    private let searchBar = UISearchBar()
    private let viewModel = CollectionViewModel()
    private let sections = Section.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupRefreshControl()
        setupTableView()
        setupCollectionView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        viewModel.updateBackground = { result in
            DispatchQueue.main.async { [weak self] in
                if result == 1 {
                    self?.imageView.image = UIImage(named: "backgroundDay")
                } else {
                    self?.imageView.image = UIImage(named: "backgroundNight")
                }
            }
        }
        
        viewModel.updateCollectionView = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates(nil) { [weak self] _ in
                    self?.updateUI(state: .showCollectionView)
                }
            }
        }
        
        viewModel.updateTableView = {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.tableView.performBatchUpdates(nil) { [weak self] _ in
                    self?.updateUI(state: .showTableView)
                }
            }
        }
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .alphabet
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = LayoutGenerator.generateLayout()
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        
        collectionView.register(CurrentCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        
        collectionView.register(HourlyCollectionViewCell.nib,
                                forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        collectionView.register(DailyCollectionViewCell.nib,
                                forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        
        collectionView.register(CollectionHeaderView.nib,
                                forSupplementaryViewOfKind: "sectionHeader",
                                withReuseIdentifier: CollectionHeaderView.identifier)
    }
    
    @objc private func refreshData() {
        if let locationName = UserDefaults.standard.value(forKey: "lastLocation") as? String {
            viewModel.getWeatherData(for: locationName)
        } else {
            print("Failed to refresh weather data")
        }
    }
    
    private func updateUI(state: UIState) {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        switch state {
        case .showCollectionView:
            collectionView.isHidden = false
            tableView.isHidden = true
            noResultsLabel.isHidden = true
            
        case .showTableView:
            collectionView.isHidden = true
            tableView.isHidden = false
            noResultsLabel.isHidden = true
            
        case .showNoResultsLabel:
            collectionView.isHidden = true
            tableView.isHidden = true
            noResultsLabel.isHidden = false
        }
    }
    
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = createSafeQueryString(from: searchText)
        if !query.isEmpty && query.count >= 3 {
            viewModel.searchLocation(query: query)
            activityIndicator.startAnimating()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.hide()
        
        if viewModel.currentCellViewModels.isEmpty {
            updateUI(state: .showNoResultsLabel)
        } else {
            updateUI(state: .showCollectionView)
        }
    }
    
    private func createSafeQueryString(from string: String) -> String {
        let filteredString = string.filter { $0.isLetter || $0.isWhitespace }
        let safeString = filteredString.replacingOccurrences(of: " ", with: "_")
        return safeString
    }
    
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = viewModel.locations
        return results.isEmpty ? 1 : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let results = viewModel.locations
        
        if results.isEmpty {
            content.text = "No Results"
            content.textProperties.alignment = .center
        } else {
            let location = results[indexPath.row]
            content.text = "\(location.name), \(location.country)"
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let locations = viewModel.locations
        
        if !locations.isEmpty {
            let location = locations[indexPath.row]
            let locationName = createSafeQueryString(from: location.name)
            
            searchBar.hide()
            activityIndicator.startAnimating()
            
            viewModel.getWeatherData(for: locationName)
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch sections[section] {

        case .current:
            return viewModel.currentCellViewModels.count
        case .hourly:
            return viewModel.hourlyCellViewModels.count
        case .daily:
            return viewModel.dailyCellViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch sections[indexPath.section] {
            
        case .current:
            return UICollectionReusableView()
            
        case .hourly:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            sectionHeader.setHeader(ofType: .hourly)
            return sectionHeader
            
        case .daily:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            sectionHeader.setHeader(ofType: .daily)
            return sectionHeader
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch sections[indexPath.section] {

        case .current:
            let cellViewModel = viewModel.currentCellViewModels[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as! CurrentCollectionViewCell
            cell.configure(with: cellViewModel)
            return cell

        case .hourly:
            let cellViewModel = viewModel.hourlyCellViewModels[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
            cell.configure(with: cellViewModel)
            return cell

        case .daily:
            let cellViewModel = viewModel.dailyCellViewModels[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as! DailyCollectionViewCell
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
}
