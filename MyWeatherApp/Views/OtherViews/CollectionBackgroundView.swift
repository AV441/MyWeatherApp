//
//  CollectionBackgroundView.swift
//  MyWeatherApp
//
//  Created by Андрей on 14.11.2022.
//

import UIKit

final class CollectionBackgroundView: UICollectionReusableView {

    static let nib = UINib(nibName: "CollectionBackgroundView", bundle: nil)
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundView.backgroundColor = UIColor(red: 0/255,
                                                 green: 100/255,
                                                 blue: 140/255,
                                                 alpha: 0.7)
        backgroundView.layer.borderWidth = 0.2
        backgroundView.layer.cornerRadius = 15
    }
}
