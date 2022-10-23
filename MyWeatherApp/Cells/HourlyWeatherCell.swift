//
//  HourlyWeatherCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 29.05.2022.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    
    static let identifier = "HourlyWeatherCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let conditionStackView: UIStackView = {
        let conditionStackView = UIStackView()
        conditionStackView.axis = .vertical
        conditionStackView.distribution = .fill
        conditionStackView.alignment = .center
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        return conditionStackView
    }()
    
    let timeLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return locationLabel
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let chanceOfRainLabel: UILabel = {
        let chanceOfRainLabel = UILabel()
        chanceOfRainLabel.textColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        chanceOfRainLabel.font = .systemFont(ofSize: 11, weight: .bold)
        return chanceOfRainLabel
    }()
    
    let tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = .white
        tempLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return tempLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        conditionStackView.addArrangedSubview(imageView)
        conditionStackView.addArrangedSubview(chanceOfRainLabel)
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(conditionStackView)
        stackView.addArrangedSubview(tempLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10)
        ])
    }
    
    func configure(with model: HourlyWeather) {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
