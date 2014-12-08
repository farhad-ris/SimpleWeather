//
//  SWClient.swift
//  SimpleWeather
//
//  Created by Kevin Xu on 12/7/14.
//  Copyright (c) 2014 Kevin Xu. All rights reserved.
//

import UIKit
import CoreLocation

class SWClient: NSObject {
    
    // MARK: Properties
    
    private var session: NSURLSession
    
    // MARK: Initialization
    
    override init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        super.init()
    }
    
    // MARK: Fetch Methods
   
    func fetchJSONfromURL(url: NSURL) -> RACSignal {
        return RACSignal.createSignal({(subscriber: RACSubscriber!) in
            let dataTask = self.session.dataTaskWithURL(url,
                completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
                    if error != nil {
                        var jsonError: NSError?
                        let json = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.allZeros, error: &jsonError)
                        if jsonError != nil {
                            subscriber.sendNext(json)
                        } else {
                            subscriber.sendError(jsonError)
                        }
                    } else {
                        subscriber.sendError(error)
                    }
                    subscriber.sendCompleted()
                }
            )
            dataTask.resume()
            return RACDisposable(block: {
                dataTask.cancel()
            })
        }).doError({(error: NSError!) in
            println(error)
        })
    }
    
    func fetchCurrentConditionsForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial")
        return self.fetchJSONfromURL(url!).map({(json: AnyObject!) in
            return MTLJSONAdapter.modelOfClass(SWCondition.self, fromJSONDictionary: json as NSDictionary, error: nil)
        })
    }
    
    func fetchHourlyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=12")
        return self.fetchJSONfromURL(url!).map({(json: AnyObject!) in
            let list = (json as NSDictionary)["list"]?.rac_sequence
            return list?.map({(item: AnyObject!) in
                return MTLJSONAdapter.modelOfClass(SWCondition.self, fromJSONDictionary: item as NSDictionary, error: nil)
            })
        })
    }
    
    func fetchDailyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=7")
        return self.fetchJSONfromURL(url!).map({(json: AnyObject!) in
            let list = (json as NSDictionary)["list"]?.rac_sequence
            return list?.map({(item: AnyObject!) in
                return MTLJSONAdapter.modelOfClass(SWDailyForecast.self, fromJSONDictionary: item as NSDictionary, error: nil)
            })
        })
    }
}
