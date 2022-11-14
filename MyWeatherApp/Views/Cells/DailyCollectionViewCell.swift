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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(with model: DailyForecast, hideLineView: Bool, setupFirstItem: Bool) {
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
    private func getDayFromDate(_ date: String) -> String {
        
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        let dateFromString = formater.date(from: date)
        formater.dateFormat = "EEE, d MMM"
        formater.locale = Locale(identifier: "ru")
        let stringFromDate = formater.string(from: dateFromString!)
        
        return stringFromDate
    }
}
