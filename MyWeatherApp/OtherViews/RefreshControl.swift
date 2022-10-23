//
//  RefreshControl.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation
import UIKit

class RefreshControl: UIRefreshControl {
    
    static let shared = RefreshControl()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(ViewController().refreshWeatherData(_:)), for: .valueChanged)
        return refreshControl
    }()
}
