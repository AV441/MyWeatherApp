//
//  CollectionRefreshControl.swift
//  MyWeatherApp
//
//  Created by Андрей on 14.11.2022.
//

import UIKit

final class CollectionRefreshControl: UIRefreshControl {

    override func draw(_ rect: CGRect) {
        tintColor = UIColor(red: 0/255,
                            green: 100/255,
                            blue: 140/255,
                            alpha: 0.7)
        attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
}
