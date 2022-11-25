//
//  UISearchBar.swift
//  MyWeatherApp
//
//  Created by Андрей on 24.11.2022.
//

import UIKit

extension UISearchBar {
    public func hide() {
        self.text = nil
        self.resignFirstResponder()
    }
}
