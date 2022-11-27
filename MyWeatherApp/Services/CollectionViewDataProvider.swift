//
//  CollectionViewDataProvider.swift
//  MyWeatherApp
//
//  Created by Андрей on 27.11.2022.
//

import UIKit

final class CollectionViewDataProvider: NSObject {
    private let sections = Section.allCases
    private var viewModel: CollectionViewModel
    
    init(with viewModel: CollectionViewModel) {
        self.viewModel = viewModel
    }
}

extension CollectionViewDataProvider: UICollectionViewDataSource {
    
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
