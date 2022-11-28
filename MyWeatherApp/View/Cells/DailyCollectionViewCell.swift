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
    
    private var isChanceOfRainLabelHidden: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isChanceOfRainLabelHidden = { result in
            self.chanceOfRainLabel.isHidden = result
        }
    }

    public func configure(with viewModel: DailyCellViewModel?) {
        if let viewModel = viewModel {
            dayLabel.text = viewModel.day
            chanceOfRainLabel.text = viewModel.chanceOfRain
            minTempLabel.text = viewModel.minTemp
            maxTempLabel.text = viewModel.maxTemp
            imageView.image = viewModel.image
            
            viewModel.chanceOfRain == "0 %" ? isChanceOfRainLabelHidden?(true) : isChanceOfRainLabelHidden?(false)
        }
    }
}
