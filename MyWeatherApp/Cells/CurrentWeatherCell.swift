//
//  CurrentWeatherCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 26.05.2022.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    
    static let identifier = "CurrentWeatherCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let conditionStackView: UIStackView = {
        let conditionStackView = UIStackView()
        conditionStackView.axis = .horizontal
        conditionStackView.distribution = .fillProportionally
        conditionStackView.alignment = .fill
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        return conditionStackView
    }()
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        return locationLabel
    }()
    
    let tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = .white
        tempLabel.font = UIFont.systemFont(ofSize: 70, weight: .thin)
        return tempLabel
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let feelsLikeLabel: UILabel = {
        let feelsLikeLabel = UILabel()
        feelsLikeLabel.textColor = .white
        feelsLikeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return feelsLikeLabel
    }()
    
    let conditionLabel: UILabel = {
        let conditionLabel = UILabel()
        conditionLabel.textColor = .white
        conditionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        conditionLabel.numberOfLines = 0
        conditionLabel.textAlignment = .center
        return conditionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        conditionStackView.addArrangedSubview(tempLabel)
        conditionStackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(conditionStackView)
        stackView.addArrangedSubview(conditionLabel)
        stackView.addArrangedSubview(feelsLikeLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            conditionStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.45),
            conditionStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10)
        ])
    }
    
    func configure(with model: CurrentWeather) {
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
