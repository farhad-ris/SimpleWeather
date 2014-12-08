//
//  SWDailyForecast.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit

class SWDailyForecast: SWCondition {
    
    // MARK: Converts JSON keys to Swift properties
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var paths = super.JSONKeyPathsByPropertyKey()
        paths["tempHigh"] = "temp.max"
        paths["tempLow"] = "temp.min"
        return paths
    }
}
