//
//  SWCondition.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit

class SWCondition: MTLModel, MTLJSONSerializing {
    
    // MARK: Properties
    
    var date: NSDate?
    var humidity: NSNumber?
    var temperature: NSNumber?
    var tempHigh: NSNumber?
    var tempLow: NSNumber?
    var locationName: String?
    var sunrise: NSDate?
    var sunset: NSDate?
    var conditionDescription: String?
    var condition: String?
    var windBearing: NSNumber?
    var windSpeed: NSNumber?
    var icon: String?
    
    // MARK: Icon Image Methods
    
    func imageName() -> String {
        return SWCondition.imageMap()[self.icon!] as String
    }
    
    class func imageMap() -> NSDictionary {
        return [
            "01d": "weather-clear",
            "02d": "weather-few",
            "03d": "weather-few",
            "04d": "weather-broken",
            "09d": "weather-shower",
            "10d": "weather-rain",
            "11d": "weather-tstorm",
            "13d": "weather-snow",
            "50d": "weather-mist",
            "01n": "weather-moon",
            "02n": "weather-few-night",
            "03n": "weather-few-night",
            "04n": "weather-broken",
            "09n": "weather-shower",
            "10n": "weather-rain-night",
            "11n": "weather-tstorm",
            "13n": "weather-snow",
            "50n": "weather-mist",
        ]
    }
    
    // MARK: Converts JSON keys to Swift properties
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "date": "dt",
            "locationName": "name",
            "humidity": "main.humidity",
            "temperature": "main.temp",
            "tempHigh": "main.temp_max",
            "tempLow": "main.temp_min",
            "sunrise": "sys.sunrise",
            "sunset": "sys.sunset",
            "conditionDescription": "weather.description",
            "condition": "weather.main",
            "icon": "weather.icon",
            "windBearing": "wind.deg",
            "windSpeed": "wind.speed",
        ]
    }
    
    // MARK: NSValueTransformers
    
    class func dateJSONTransformer() -> NSValueTransformer {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({(str: AnyObject!) in
            return NSDate(timeIntervalSince1970: str.doubleValue)
        }, reverseBlock: {(date: AnyObject!) in
            return "\((date as NSDate).timeIntervalSince1970)"
        })
    }
    
    class func sunriseJSONTransformer() -> NSValueTransformer {
        return self.dateJSONTransformer()
    }
    
    class func sunsetJSONTransformer() -> NSValueTransformer {
        return self.dateJSONTransformer()
    }
    
    class func iconJSONTransformer() -> NSValueTransformer {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({(arr: AnyObject!) in
            return arr.firstObject
        }, reverseBlock: {(str: AnyObject!) in
            return [str]
        })
    }
    
    class func conditionJSONTransformer() -> NSValueTransformer {
        return self.iconJSONTransformer()
    }
    
    class func conditionDescriptionJSONTransformer() -> NSValueTransformer {
        return self.iconJSONTransformer()
    }
    
    class func windSpeedJSONTransformer() -> NSValueTransformer {
        let MPS_TO_MPH = 2.23694
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({(num: AnyObject!) in
            return num.doubleValue * MPS_TO_MPH
        }, reverseBlock: {(speed: AnyObject!) in
            return speed.doubleValue / MPS_TO_MPH
        })
    }
}
