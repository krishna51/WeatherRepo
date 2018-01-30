//
//  Weather.swift
//  SampleWheather
//
//  Created by User on 1/29/18.
//  Copyright © 2018 CodeChallenge. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    
    static let kWeatherKey = "weather"
    static let kMainKey = "main"
    static let kDescriptionKey = "description"
    static let kIconKey = "icon"
    static let kTemperatureKey = "temp"
    static let kTempMinKey = "temp_min"
    static let kTempMaxKey = "temp_max"
    static let kNameKey = "name"
    static let kCodKey = "cod"

    
    var main = ""
    var description = ""
    var iconString = ""
    var iconImage: UIImage?
    var temperatureK: Float?
    var highK: Float?
    var lowK: Float?
    var cityName = ""
    var respCode = ""
    
    var temperatureF: Int? {
        get {
            if let temperatureK = temperatureK {
                return self.convertKtoF(inTemp: temperatureK)
            } else {
                return nil
            }
        }
    }
    var highF: Int? {
        get {
            if let highK = highK {
                return self.convertKtoF(inTemp: highK)
            } else {
                return nil
            }
        }
    }
    var lowF: Int? {
        get {
            if let lowK = lowK {
                return self.convertKtoF(inTemp: lowK)
            } else {
                return nil
            }
        }
    }
    
    //Converting Kelvin to Farenheit
    func convertKtoF(inTemp : Float) -> Int {
        let myIntValue:Int = Int(1.8 * (inTemp - 273.15) + 32)
        return myIntValue
    }
    
    //Initializing Object Dictionary
    init(jsonDictionary: [String : AnyObject]) {
        
        if let weatherKeyFailCode = jsonDictionary[Weather.kCodKey] as? String {
                self.respCode = weatherKeyFailCode
        }

        if let arrayWeatherKey = jsonDictionary[Weather.kWeatherKey] as? [[String : AnyObject]] {
            if let main = arrayWeatherKey[0][Weather.kMainKey] as? String {
                self.main = main
            }
            if let description = arrayWeatherKey[0][Weather.kDescriptionKey] as? String {
                self.description = description
            }
            if let iconString = arrayWeatherKey[0][Weather.kIconKey] as? String {
                self.iconString = iconString
            }
        }
        
        if let main = jsonDictionary[Weather.kMainKey] as? [String : AnyObject] {
            if let temperature = main[Weather.kTemperatureKey] as? NSNumber {
                self.temperatureK = Float(temperature)
            }
            if let minTemp = main[Weather.kTempMinKey] as? NSNumber {
                self.lowK = Float(minTemp)
            }
            if let maxTemp = main[Weather.kTempMaxKey] as? NSNumber {
                self.highK = Float(maxTemp)
            }
        }

        if let cityName = jsonDictionary[Weather.kNameKey] as? String {
            self.cityName = cityName
        }
    }
}
