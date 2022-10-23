//
//  DataSource.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit

extension ViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    func configureCollectionViewDataSource() {
        //TODO: Cells DataSource
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
                
                // Current section
            case let .current(currentWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
                cell.configure(with: currentWeather)
                return cell
                
                // Hourly section
            case let .hourly(hourlyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.identifier, for: indexPath) as! HourlyWeatherCell
                cell.configure(with: hourlyWeather)
                return cell
                
                //Daily section
            case let .daily(dailyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCell.identifier, for: indexPath) as! DailyWeatherCell
                let isFirstItem: Bool = indexPath.item == 0
                let isLastItem: Bool = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.item + 1
                cell.configure(with: dailyWeather, hideLineView: isLastItem, setupFirstItem: isFirstItem)
                return cell
            }
        })
        
        // TODO: Headers DataSource
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let section = Section.allCases[indexPath.section]
            switch section {
                
                // Current section
            case .current:
                return nil
                
                // Hourly section
            case .hourly:
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                sectionHeader.setTitle(with: "ПРОГНОЗ НА 24 ЧАСА", and: UIImage(systemName: "clock"))
                return sectionHeader
                
                //Daily section
            case .daily:
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                sectionHeader.setTitle(with: "ПРОГНОЗ НА 3 ДНЯ", and: UIImage(systemName: "calendar"))
                return sectionHeader
            }
        }
    }
}
