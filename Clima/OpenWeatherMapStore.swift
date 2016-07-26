//
//  OpenWeatherMapStore.swift
//  Clima
//
//  Created by Andre Saboia on 7/26/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import Foundation

class OpenWeatherMapStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func processRecentCitiesRequest(data data: NSData?, error: NSError?) -> CitiesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return OpenWeatherMapAPI.citiesFromJSONData(jsonData)
    }
    
    func fetchCitiesInCycle(cnt: Int, lat: Double, lon: Double, completion: (CitiesResult) -> Void) {
        let url = OpenWeatherMapAPI.citiesInCycleURL(cnt, lat: lat, lon: lon)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            let result = self.processRecentCitiesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
}