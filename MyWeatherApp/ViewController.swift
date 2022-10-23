//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Андрей on 19.05.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    // Location
    let geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationName = "Текущее место"
    
    // CollectionView
    var collectionView: UICollectionView! = nil
    var dataSource: DataSource!
    var snapshot = DataSourceSnapshot()
    
    // Other
    var backgroundImage = UIImageView(frame: .zero)
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        setBackground(with: UIImage(named: "backgroundDay"))
        configureCollectionView()
        configureCollectionViewDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLocation()
    }
    
    @objc func refreshWeatherData(_ sender: UIRefreshControl) {
        getLocation()
        sender.endRefreshing()
    }
    
    func setBackground(with image: UIImage?) {
        guard let image = image else { return }
        backgroundImage.frame = view.bounds
        backgroundImage.image = image
    }
}
