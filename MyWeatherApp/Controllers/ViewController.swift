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
    
    private let searchBar = UISearchBar()
    private let sections = Section.allCases
    private var viewModel: CollectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
        initViewModel()
    }
    
    private func initViewModel() {
        viewModel = CollectionViewModel()
        
        viewModel.updateCollectionView = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates(nil) { [weak self] _ in
                    self?.noResultsLabel.isHidden = true
                    self?.tableView.isHidden = true
                    self?.collectionView.isHidden = false
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.updateTableView = {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.tableView.performBatchUpdates(nil) { [weak self] _ in
                    self?.noResultsLabel.isHidden = true
                    self?.tableView.isHidden = false
                    self?.collectionView.isHidden = true
                    self?.activityIndicator.stopAnimating()
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
    
    // MARK: CollectionView Configuration
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.collectionViewLayout = LayoutGenerator.generateLayout()
        
        collectionView.refreshControl = CollectionRefreshControl()
        
        collectionView.register(CurrentCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        
        collectionView.register(HourlyCollectionViewCell.nib,
                                forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        collectionView.register(DailyCollectionViewCell.nib,
                                forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        
        collectionView.register(CollectionHeaderView.nib,
                                forSupplementaryViewOfKind: "sectionHeader",
                                withReuseIdentifier: CollectionHeaderView.identifier)
        
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        if viewModel.locations.isEmpty {
            viewModel.getWeatherDataForCurrentLocation()
        } else {
            guard let location = viewModel.locations.last else {
                return
            }
            viewModel.getWeatherData(for: location.name)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: SearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = createSafeQueryString(from: searchText)
        viewModel.searchLocation(query: query)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        tableView.isHidden = true
        
        if viewModel.currentCellViewModels.isEmpty {
            collectionView.isHidden = true
            noResultsLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noResultsLabel.isHidden = true
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
        let location = viewModel.locations[indexPath.row]
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        activityIndicator.startAnimating()
        
        viewModel.getWeatherData(for: location.name)
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
