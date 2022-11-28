//
//  HourlyCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 13.11.2022.
//

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {

    static let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    static let identifier = "HourlyCollectionViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: HourlyCellViewModel! {
        willSet(viewModel) {
            timeLabel.text = viewModel.time
            tempLabel.text = viewModel.temp
            imageView.image = viewModel.image
            
            if viewModel.chanceOfRain != nil {
                chanceOfRainLabel.isHidden = false
                chanceOfRainLabel.text = viewModel.chanceOfRain
            } else {
                chanceOfRainLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
