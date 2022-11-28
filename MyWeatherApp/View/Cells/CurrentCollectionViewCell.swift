//
//  CurrentCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 13.11.2022.
//

import UIKit

final class CurrentCollectionViewCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: "CurrentCollectionViewCell", bundle: nil)
    static let identifier = "CurrentCollectionViewCell"
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: CurrentCellViewModel! {
        willSet(viewModel) {
            locationLabel.text = viewModel.locationName
            tempLabel.text = viewModel.temp
            feelsLikeLabel.text = viewModel.feelsLikeTemp
            conditionLabel.text = viewModel.condition
            imageView.image = viewModel.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
