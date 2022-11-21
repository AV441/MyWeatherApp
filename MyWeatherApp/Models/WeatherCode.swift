//
//  WeatherCode.swift
//  MyWeatherApp
//
//  Created by Андрей on 02.06.2022.
//

import Foundation
import UIKit

enum WeatherCode: Int, Decodable {
    
    case clear = 1000
    case partlyCloudy = 1003
    case cloudy = 1006
    case overcast = 1009
    case mist = 1030
    case patchyRainPossible = 1063
    case patchySnowPossible = 1066
    case patchySleetPossible = 1069
    case patchyFreezingDrizzlePossible = 1072
    case thunderyOutbreaksPossible = 1087
    case blowingSnow = 1114
    case blizzard = 1117
    case fog = 1135
    case freezingFog = 1147
    case patchyLightDrizzle = 1150
    case lightDrizzle = 1153
    case freezingDrizzle = 1168
    case heavyFreezingDrizzle = 1171
    case patchyLightRain = 1180
    case lightRain = 1183
    case moderateRainAtTimes = 1186
    case moderateRain = 1189
    case heavyRainAtTimes = 1192
    case heavyRain = 1195
    case lightFreezingRain = 1198
    case moderateOrHeavyFreezingRain = 1201
    case lightSleet = 1204
    case moderateOrHeavySleet = 1207
    case patchyLightSnow = 1210
    case lightSnow = 1213
    case patchyModerateSnow = 1216
    case moderateSnow = 1219
    case patchyHeavySnow = 1222
    case heavySnow = 1225
    case icePellets = 1237
    case lightRainShower = 1240
    case moderateOrHeavyRainShower = 1243
    case torrentialRainShower = 1246
    case lightSleetShowers = 1249
    case moderateOrHeavySleetShowers = 1252
    case lightSnowShowers = 1255
    case moderateOrHeavySnowShowers = 1258
    case lightShowersOfIcePellets = 1261
    case moderateOrHeavyShowersOfIcePellets = 1264
    case patchyLightRainWithThunder = 1273
    case moderateOrHeavyRainWithThunder = 1276
    case patchyLightSnowWithThunder = 1279
    case moderateOrHeavySnowWithThunder = 1282
    
    var imageDay: UIImage? {
        let oneColorConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1) ])
        let twoColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        let threeColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        
        switch self {
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
    
    var imageNight: UIImage? {
        let oneColorConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) ])
        let twoColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        let threeColorsConfing = UIImage.SymbolConfiguration(paletteColors: [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1) ])
        
        switch self {
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
