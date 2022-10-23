//
//  11.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit

extension ViewController {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(DailyWeatherCell.self, forCellWithReuseIdentifier: DailyWeatherCell.identifier)
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.identifier)
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = RefreshControl.shared.refreshControl
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
}
