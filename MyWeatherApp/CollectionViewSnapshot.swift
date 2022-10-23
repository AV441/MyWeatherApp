//
//  Snapshot.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit

extension ViewController {
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    func applySnapshot(with sections: [Section: [Item]]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections(Section.allCases)
        
        for section in sections {
            snapshot.appendItems(section.value, toSection: section.key)
        }
        
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
