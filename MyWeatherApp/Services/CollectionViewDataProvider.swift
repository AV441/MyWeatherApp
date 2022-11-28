//
//  CollectionViewDataProvider.swift
//  MyWeatherApp
//
//  Created by Андрей on 27.11.2022.
//

import UIKit

final class CollectionViewDataProvider: NSObject {
    private let sections = Section.allCases
    private var viewModel: CollectionViewViewModel
    
    init(with viewModel: CollectionViewViewModel) {
        self.viewModel = viewModel
    }
}

extension CollectionViewDataProvider: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as! CurrentCollectionViewCell
            
            if let cellViewModel = viewModel.cellViewModel(for: indexPath) as? CurrentCellViewModel {
                cell.viewModel = cellViewModel
            }
            return cell

        case .hourly:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
            if let cellViewModel = viewModel.cellViewModel(for: indexPath) as? HourlyCellViewModel {
                cell.viewModel = cellViewModel
            }
            return cell

        case .daily:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as! DailyCollectionViewCell
            if let cellViewModel = viewModel.cellViewModel(for: indexPath) as? DailyCellViewModel {
                cell.viewModel = cellViewModel
            }
            return cell
        }
    }
}
