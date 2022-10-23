//
//  WeatherCell.swift
//  MyWeatherApp
//
//  Created by Андрей on 19.05.2022.
//

import UIKit

class DailyWeatherCell: UICollectionViewCell {
    
    static let identifier = "DailyWeatherCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let tempStackView: UIStackView = {
        let tempStackView = UIStackView()
        tempStackView.axis = .horizontal
        tempStackView.distribution = .fillEqually
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        return tempStackView
    }()
    
    let conditionStackView: UIStackView = {
        let conditionStackView = UIStackView()
        conditionStackView.axis = .vertical
        conditionStackView.distribution = .equalSpacing
        conditionStackView.alignment = .center
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        return conditionStackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textColor = .white
        return dayLabel
    }()
    
    let maxTempLabel: UILabel = {
        let maxTempLabel = UILabel()
        maxTempLabel.textColor = .white
        return maxTempLabel
    }()
    
    let minTempLabel: UILabel = {
        let minTempLabel = UILabel()
        minTempLabel.textColor = .white
        return minTempLabel
    }()
    
    let chanceOfRainLabel: UILabel = {
        let chanceOfRainLabel = UILabel()
        chanceOfRainLabel.textColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        chanceOfRainLabel.font = .systemFont(ofSize: 11, weight: .bold)
        return chanceOfRainLabel
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        conditionStackView.addArrangedSubview(imageView)
        conditionStackView.addArrangedSubview(chanceOfRainLabel)
        
        tempStackView.addArrangedSubview(minTempLabel)
        tempStackView.addArrangedSubview(maxTempLabel)
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(conditionStackView)
        stackView.addArrangedSubview(tempStackView)
        
        contentView.addSubview(stackView)
        contentView.addSubview(lineView)
        NSLayoutConstraint.activate([
            tempStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2),
            
            dayLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
            
            lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with model: DailyForecast, hideLineView: Bool, setupFirstItem: Bool) {
        if setupFirstItem {
            dayLabel.text = "Сегодня"
        } else {
            dayLabel.text = getDayFromDate(model.date)
        }
        
        minTempLabel.text = "\(Int(model.day.minTemp))°"
        maxTempLabel.text = "\(Int(model.day.maxTemp))°"
        
        imageView.image = model.day.condition.code.imageDay
        
        if model.day.dailyChanceOfRain != 0 {
            chanceOfRainLabel.isHidden = false
            chanceOfRainLabel.text = "\(model.day.dailyChanceOfRain)%"
        } else {
            chanceOfRainLabel.isHidden = true
        }
        
        lineView.isHidden = hideLineView
    }
    
    // Date setup
    func getDayFromDate(_ date: String) -> String {
        
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        let dateFromString = formater.date(from: date)
        formater.dateFormat = "EEE, d MMM"
        formater.locale = Locale(identifier: "ru")
        let stringFromDate = formater.string(from: dateFromString!)
        
        return stringFromDate
    }
}
