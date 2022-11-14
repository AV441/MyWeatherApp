//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Андрей on 19.05.2022.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

final class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createDataSource()
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCollectionView(notification:)),
                                               name: NSNotification.Name(rawValue: "location"),
                                               object: nil)
    }
    
    private func setBackgroundImage(_ image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }
    
    @objc private func updateCollectionView(notification: NSNotification) {
        guard let object = notification.object as? (WeatherResponse, String) else {
            return
        }
        
        let results = object.0
        let locationName = object.1
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            // Change Background
            if results.current.isDay == 1 {
                let image = UIImage(named: "backgroundDay")
                strongSelf.setBackgroundImage(image)
            } else {
                let image = UIImage(named: "backgroundNight")
                strongSelf.setBackgroundImage(image)
            }
            
            // Fill Current Items
            var currentItems = [Item]()
            
            let currentWeather = CurrentWeather(locationName: locationName,
                                                weather: results.current)
            currentItems.append(Item.current(currentWeather))
            
            // Fill Hourly Items
            var hourlyItems = [Item.hourly(HourlyWeather(weatherData: HourlyForecast(time: "Сейчас",
                                                                                     temp: results.current.temp,
                                                                                     isDay: results.current.isDay,
                                                                                     chanceOfRain: 0,
                                                                                     condition: results.current.condition),
                                                         astroData: nil,
                                                         astroKind: nil))]
            
            let sunriseTimeString = results.forecast.forecastday[0].astro.sunrise
            let sunsetTimeString = results.forecast.forecastday[0].astro.sunset
            
            guard let sunriseTime = DateConverter.convertAstroTime(from: sunriseTimeString)?.0,
                  let sunsetTime = DateConverter.convertAstroTime(from: sunsetTimeString)?.0,
                  let currentTime = DateConverter.convertCurrentTime() else { return }
            
            let hourlyWeatherArray = results.forecast.forecastday[0].hour + results.forecast.forecastday[1].hour
            
            for i in 0...(hourlyWeatherArray.count - 2) {
                guard let forecastTimeWithDate = DateConverter.convertForecastTimeWithDate(from: hourlyWeatherArray[i].time),
                      let forecastTimeWithoutDate1 = DateConverter.convertForecastTimeWithoutDate(from: hourlyWeatherArray[i].time),
                      let forecastTimeWithoutDate2 = DateConverter.convertForecastTimeWithoutDate(from: hourlyWeatherArray[i+1].time) else { return }
                if hourlyItems.count != 27 {
                    if forecastTimeWithDate >= currentTime {
                        if sunriseTime >= forecastTimeWithoutDate1, sunriseTime <= forecastTimeWithoutDate2 {
                            
                            hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                            hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: results.forecast.forecastday[0].astro, astroKind: HourlyWeather.AstroKind.isSunrise)))
                            
                        } else if sunsetTime >= forecastTimeWithoutDate1, sunsetTime <= forecastTimeWithoutDate2  {
                            
                            hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                            hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: results.forecast.forecastday[0].astro, astroKind: HourlyWeather.AstroKind.isSunset)))
                            
                        } else {
                            
                            hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                        }
                    }
                }
            }
            
            // Fill Daily Items
            var dailyItems = [Item]()
            results.forecast.forecastday.forEach { element in
                dailyItems.append(Item.daily(element))
            }
            
            // Fill Sections
            let sections: [Section: [Item]] = [
                Section.current: currentItems,
                Section.hourly: hourlyItems,
                Section.daily: dailyItems
            ]
            
            // Apply Snapshot
            strongSelf.applySnapshot(with: sections)
        }
    }
    
    // MARK: CollectionView Configuration
    private func setupCollectionView() {
        collectionView.collectionViewLayout = generateLayout()
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
        LocationManager.shared.getLocation()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Layout
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(30))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                            elementKind: "sectionHeader",
                                                                            alignment: .top)
            
            let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "background")
            
            let section = Section.allCases[sectionIndex]
            
            switch section {
                
            case .current:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .estimated(180))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(180))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitem: item,
                                                             count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.decorationItems = [sectionBackground]
                
                return section
                
            case .hourly:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                      heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                       heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.decorationItems = [sectionBackground]
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            case .daily:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(60))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitem: item,
                                                             count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.decorationItems = [sectionBackground]
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 8
        
        layout.configuration = config
        layout.register(CollectionBackgroundView.nib,
                        forDecorationViewOfKind: "background")
        
        return layout
    }
    
    // MARK: DataSource
    private func createDataSource() {
        // Cells DataSource
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
                
                // Current section
            case let .current(currentWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as! CurrentCollectionViewCell
                cell.configure(with: currentWeather)
                return cell
                
                // Hourly section
            case let .hourly(hourlyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
                cell.configure(with: hourlyWeather)
                return cell
                
                //Daily section
            case let .daily(dailyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as! DailyCollectionViewCell
                let isFirstItem: Bool = indexPath.item == 0
                let isLastItem: Bool = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.item + 1
                cell.configure(with: dailyWeather, hideLineView: isLastItem, setupFirstItem: isFirstItem)
                return cell
            }
        })
        
        // Headers DataSource
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let section = Section.allCases[indexPath.section]
            switch section {
                
                // Current section
            case .current:
                return nil
                
                // Hourly section
            case .hourly:
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
                sectionHeader.setTitle("ПРОГНОЗ НА 24 ЧАСА", with: UIImage(systemName: "clock"))
                return sectionHeader
                
                //Daily section
            case .daily:
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
                sectionHeader.setTitle("ПРОГНОЗ НА 3 ДНЯ", with: UIImage(systemName: "calendar"))
                return sectionHeader
            }
        }
    }
    
    // MARK: Snapshot
    private func applySnapshot(with sections: [Section: [Item]]) {
        snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        for section in sections {
            snapshot.appendItems(section.value, toSection: section.key)
        }
        
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
    
