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
    @IBOutlet  var collectionView: UICollectionView!
    
    private var collectionViewDataProvider: CollectionViewDataProvider!
    private var tableViewDataProvider: TableViewDataProvider!
    
    private let refreshControl = CollectionRefreshControl()
    private let searchBar = UISearchBar()
    private let viewModel = CollectionViewViewModel()
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
        initTableViewDataProvider()
        
        tableView.delegate = tableViewDataProvider
        tableView.dataSource = tableViewDataProvider
    }
    
    private func initTableViewDataProvider() {
        tableViewDataProvider = TableViewDataProvider(with: viewModel)
        tableViewDataProvider.requestWeatherForLocation = { [weak self] location in
            self?.viewModel.getWeatherData(for: location)
            self?.searchBar.hide()
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = LayoutGenerator.generateLayout()
        
        collectionViewDataProvider = CollectionViewDataProvider(with: viewModel)
        collectionView.dataSource = collectionViewDataProvider
      
        collectionView.refreshControl = refreshControl
        
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
        let query = StringConverter.createSafeQueryString(from: searchText)
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
    
}
