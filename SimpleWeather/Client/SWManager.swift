//
//  SWManager.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit
import CoreLocation

class SWManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    var currentLocation: CLLocation?
    var currentCondition: SWCondition?
    var hourlyForecast: NSArray?
    var dailyForecast: NSArray?
    
    private var locationManager: CLLocationManager
    private var client: SWClient
    
    required override init() {
        self.locationManager = CLLocationManager()
        self.client = SWClient()
        
        super.init()
        self.locationManager.delegate = self
        
        SWManager.RACObserve(self, keyPath: "currentLocation")
            .ignore(nil)
            .flattenMap({(newLocation: AnyObject!) in
                return RACSignal.merge([
                        self.updateCurrentConditions(),
                        self.updateDailyForecast(),
                        self.updateHourlyForecast(),
                    ])
                })
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeError({(error: AnyObject!) in
                TSMessage.showNotificationWithTitle("Error",
                    subtitle: "There was a problem fetching the latest weather",
                    type: TSMessageNotificationType.Error)
                })
    }
    
    func findCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = (locations as [CLLocation]).last
        if location?.horizontalAccuracy > 0 {
            self.currentLocation = location
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func updateCurrentConditions() -> RACSignal {
        return self.client
            .fetchCurrentConditionsForLocation(self.currentLocation!.coordinate)
            .doNext({(condition: AnyObject!) in
                self.currentCondition = condition as? SWCondition
            })
    }
    
    func updateDailyForecast() -> RACSignal {
        return self.client
            .fetchDailyForecastForLocation(self.currentLocation!.coordinate)
            .doNext({(conditions: AnyObject!) in
                self.dailyForecast = conditions as? NSArray
            })
    }
    
    func updateHourlyForecast() -> RACSignal {
        return self.client
            .fetchHourlyForecastForLocation(self.currentLocation!.coordinate)
            .doNext({(conditions: AnyObject!) in
                self.hourlyForecast = conditions as? NSArray
            })
    }
    
    class func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
        return target.rac_valuesForKeyPath(keyPath, observer: target)
    }
}
