//
//  HourlyCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 13.11.2022.
//

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {

    public static let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    public static let identifier = "HourlyCollectionViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var isChanceOfRainLabelHidden: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isChanceOfRainLabelHidden = { [weak self] result in
            self?.chanceOfRainLabel.isHidden = result
        }
    }
    
    public func configure(with viewModel: HourlyCellViewModel?) {
        if let viewModel = viewModel {
            timeLabel.text = viewModel.time
            chanceOfRainLabel.text = viewModel.chanceOfRain
            tempLabel.text = viewModel.temp
            imageView.image = viewModel.image
            
            viewModel.chanceOfRain == "0 %" ? isChanceOfRainLabelHidden?(true) : isChanceOfRainLabelHidden?(false)
        }
    }
}
