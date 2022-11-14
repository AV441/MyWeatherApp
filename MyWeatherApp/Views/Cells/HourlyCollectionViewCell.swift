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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: HourlyWeather) {
        if model.astroKind != nil {
            switch model.astroKind! {
            case .isSunrise:
                guard let sunriseTime = model.astroData?.sunrise else { return }
                timeLabel.text = DateConverter.convertAstroTime(from: sunriseTime)?.1
                imageView.image = UIImage(systemName: "sunrise.fill")?.withRenderingMode(.alwaysOriginal)
                tempLabel.text = "Восход солнца"
                chanceOfRainLabel.isHidden = true
            case .isSunset:
                guard let sunsetTime = model.astroData?.sunset else { return }
                timeLabel.text = DateConverter.convertAstroTime(from: sunsetTime)?.1
                imageView.image = UIImage(systemName: "sunset.fill")?.withRenderingMode(.alwaysOriginal)
                tempLabel.text = "Заход солнца"
                chanceOfRainLabel.isHidden = true
            }
        } else {
            let forecastTime = model.weatherData.time
            timeLabel.text = DateConverter.getTimeFromDate(forecastTime)
            tempLabel.text = "\(Int(model.weatherData.temp))°"
            
            if model.weatherData.isDay == 1 {
                imageView.image = model.weatherData.condition.code.imageDay }
            else {
                imageView.image = model.weatherData.condition.code.imageNight
            }
            
            if model.weatherData.chanceOfRain != 0 {
                chanceOfRainLabel.isHidden = false
                chanceOfRainLabel.text = "\(model.weatherData.chanceOfRain)%"
            }  else {
                chanceOfRainLabel.isHidden = true
            }
        }
    }

}
