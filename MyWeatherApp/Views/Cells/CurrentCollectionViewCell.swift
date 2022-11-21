//
//  CurrentCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 13.11.2022.
//

import UIKit

final class CurrentCollectionViewCell: UICollectionViewCell {
    
    public static let nib = UINib(nibName: "CurrentCollectionViewCell", bundle: nil)
    public static let identifier = "CurrentCollectionViewCell"
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with viewModel: CurrentCellViewModel) {
        locationLabel.text = viewModel.locationName
        tempLabel.text = viewModel.temp
        feelsLikeLabel.text = viewModel.feelsLikeTemp
        conditionLabel.text = viewModel.condition
        imageView.image = viewModel.image
    }
}
