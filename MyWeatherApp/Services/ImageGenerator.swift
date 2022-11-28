//
//  ImageGenerator.swift
//  MyWeatherApp
//
//  Created by Андрей on 25.11.2022.
//

import UIKit

final class ImageGenerator {
    
    static let backgroundDayImage = UIImage(named: "backgroundDay")
    static let backgroundNightImage = UIImage(named: "backgroundNight")
    static let sunriseImage = UIImage(systemName: "sunrise.fill")?.withRenderingMode(.alwaysOriginal)
    static let sunsetImage = UIImage(systemName: "sunset.fill")?.withRenderingMode(.alwaysOriginal)
    
    static func headerImage(for headerType: SectionHeaderType) -> UIImage? {
        switch headerType {
        case .hourly:
            return UIImage(systemName: "clock")
        case .daily:
            return UIImage(systemName: "calendar")
        }
    }
    
    static func dayImage(for code: WeatherCode) -> UIImage? {
        let oneColorConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1) ])
        let twoColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        let threeColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        
        switch code {
        case .clear:
            return UIImage(systemName: "sun.max.fill", withConfiguration: oneColorConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .partlyCloudy:
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .cloudy:
            return UIImage(systemName: "cloud.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .overcast:
            return UIImage(systemName: "cloud.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .mist:
            return UIImage(systemName: "smoke.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyRainPossible:
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchySleetPossible, .lightSleet, .moderateOrHeavySleet, .lightSleetShowers, .moderateOrHeavySleetShowers:
            return UIImage(systemName: "cloud.sleet.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .thunderyOutbreaksPossible:
            return UIImage(systemName: "cloud.sun.bolt.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .blowingSnow:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .blizzard:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .fog, .freezingFog:
            return UIImage(systemName: "smoke.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightDrizzle, .lightDrizzle, .lightRain, .freezingDrizzle, .heavyFreezingDrizzle, .patchyLightRain, .patchyFreezingDrizzlePossible, .lightFreezingRain, .lightRainShower:
            return UIImage(systemName: "cloud.drizzle.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchySnowPossible, .patchyLightSnow, .lightSnow, .patchyModerateSnow, .moderateSnow, .moderateOrHeavySnowShowers, .patchyHeavySnow, .heavySnow, .lightSnowShowers:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .moderateRain, .moderateRainAtTimes, .moderateOrHeavyRainShower, .torrentialRainShower, .moderateOrHeavyFreezingRain, .heavyRainAtTimes, .heavyRain:
            return UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .icePellets, .lightShowersOfIcePellets, .moderateOrHeavyShowersOfIcePellets:
            return UIImage(systemName: "cloud.hail.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightRainWithThunder, .moderateOrHeavyRainWithThunder:
            return UIImage(systemName: "cloud.bolt.rain.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightSnowWithThunder, .moderateOrHeavySnowWithThunder:
            return UIImage(systemName: "cloud.bolt.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    static func nightImage(for code: WeatherCode) -> UIImage? {
        let oneColorConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) ])
        let twoColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        let threeColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        
        switch code {
        case .clear:
            return UIImage(systemName: "moon.stars.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .partlyCloudy:
            return UIImage(systemName: "cloud.moon.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .cloudy, .overcast:
            return UIImage(systemName: "cloud.moon.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyRainPossible:
            return UIImage(systemName: "cloud.moon.rain.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchySleetPossible, .lightSleet, .moderateOrHeavySleet, .lightSleetShowers, .moderateOrHeavySleetShowers:
            return UIImage(systemName: "cloud.sleet", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .thunderyOutbreaksPossible:
            return UIImage(systemName: "cloud.moon.bolt.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .blowingSnow:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: oneColorConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .blizzard:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .fog, .freezingFog, .mist:
            return UIImage(systemName: "smoke.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightDrizzle, .lightDrizzle, .lightRain, .freezingDrizzle, .heavyFreezingDrizzle, .patchyLightRain, .patchyFreezingDrizzlePossible, .lightFreezingRain, .lightRainShower:
            return UIImage(systemName: "cloud.moon.rain.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchySnowPossible, .patchyLightSnow, .lightSnow, .patchyModerateSnow, .moderateSnow, .moderateOrHeavySnowShowers, .patchyHeavySnow, .heavySnow, .lightSnowShowers:
            return UIImage(systemName: "cloud.snow.fill", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .moderateRain, .moderateRainAtTimes, .moderateOrHeavyRainShower, .torrentialRainShower, .moderateOrHeavyFreezingRain, .heavyRainAtTimes, .heavyRain:
            return UIImage(systemName: "cloud.moon.rain.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .icePellets, .lightShowersOfIcePellets, .moderateOrHeavyShowersOfIcePellets:
            return UIImage(systemName: "cloud.hail", withConfiguration: twoColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightRainWithThunder, .moderateOrHeavyRainWithThunder:
            return UIImage(systemName: "cloud.moon.bolt.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
            
        case .patchyLightSnowWithThunder, .moderateOrHeavySnowWithThunder:
            return UIImage(systemName: "cloud.moon.bolt.fill", withConfiguration: threeColorsConfing)?.withRenderingMode(.alwaysTemplate)
        }
    }
}
