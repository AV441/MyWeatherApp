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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: CurrentWeather) {
        
        locationLabel.text = model.locationName
        tempLabel.text = "\(Int(model.weather.temp))°"
        feelsLikeLabel.text = "Ощущается как \(Int(model.weather.feelsLike))°"
        conditionLabel.text = model.weather.condition.text
        
        if model.weather.isDay == 1 {
            imageView.image = model.weather.condition.code.imageDay
        } else {
            imageView.image = model.weather.condition.code.imageNight
        }
    }
}
