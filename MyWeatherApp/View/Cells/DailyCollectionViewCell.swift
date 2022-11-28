//
//  DailyCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 13.11.2022.
//

import UIKit

final class DailyCollectionViewCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: "DailyCollectionViewCell", bundle: nil)
    static let identifier = "DailyCollectionViewCell"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    var viewModel: DailyCellViewModel! {
        willSet(viewModel) {
            dayLabel.text = viewModel.day
            minTempLabel.text = viewModel.minTemp
            maxTempLabel.text = viewModel.maxTemp
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
