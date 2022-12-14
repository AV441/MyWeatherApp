//
//  LayoutGenerator.swift
//  MyWeatherApp
//
//  Created by Андрей on 21.11.2022.
//

import UIKit

final class LayoutGenerator {

    static func generateLayout() -> UICollectionViewLayout {
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
}
