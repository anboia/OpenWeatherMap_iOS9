//
//  OpenWeatherMap.swift
//  Clima
//
//  Created by Andre Saboia on 7/26/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import Foundation


enum Method: String {
    case Find = "find"
}

enum CitiesResult {
    case Success([City])
    case Failure(ErrorType)
}

enum OpenWeatherMapError: ErrorType {
    case InvalidJSONData
}

struct OpenWeatherMapAPI {
    // type-level proprty
    private static let baseURLString = "http://api.openweathermap.org/data/2.5/"
    private static let appID = "02d613b9ef05c638506f7a20e22340b0"
    private static let celcius = "metric"
    private static let lang = "pt"
    
    private static func openWeatherMapURL (method method: Method,
                                                  parameters: [String:String]?) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString + method.rawValue )!
        
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "appid": appID,
            "units": celcius,
            "lang": lang
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParam = parameters{
            for (key, value) in additionalParam {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.URL!
    }
    
    private static func cityFromJSONObject(json: [String : AnyObject]) -> City? {
        guard let
            name = json["name"] as? String,
        
            main = json["main"] as? [NSObject:AnyObject],
            tempMax = main["temp_max"] as? Double,
            tempMin = main["temp_min"] as? Double,
            temp = main["temp"] as? Double,
        
            weather = json["weather"] as? [[NSObject:AnyObject]],
            description = weather[0]["description"] as? String else {
                // Dont have enought information to conctruct a City
                return nil
        }
        
        return City(name: name, tempMax: tempMax, tempMin: tempMin, temp: temp, description: description)
    }
    
    static func citiesFromJSONData(data: NSData) -> CitiesResult {
        do {
            let jsonObject: AnyObject
                    = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject],
                citiesArray = jsonDictionary["list"] as? [[String:AnyObject]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(OpenWeatherMapError.InvalidJSONData)
            }
            
            var finalCities = [City]()
            for cityJSON in citiesArray {
                if let city = cityFromJSONObject(cityJSON) {
                    finalCities.append(city)
                }
            }
            if finalCities.count == 0 && citiesArray.count > 0 {
                // Unable to parse any object
                // Maybe the JSON format has changed
                return .Failure(OpenWeatherMapError.InvalidJSONData)
            }
            return .Success(finalCities)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    /**
     Cities in cycle: URL to access data from cities laid within definite circle that is specified by center point ('lat', 'lon') and expected number of cities ('cnt') around this point.
     
     Example of usage:
     ```
     citiesInCycleURL(15, lat: -8.07586, lon: -34.92485)
     ```
     
     - parameters:
        - cnt: number of cities around the point that should be returned
        - lat: latitude
        - lon: longitude
     
     - returns: URL to request JSON file
     */
    static func citiesInCycleURL(cnt: Int, lat: Double, lon: Double) -> NSURL {
        
        
        return openWeatherMapURL(   method: .Find,
                                parameters: [   "lat":String(lat),
                                                "lon":String(lon),
                                                "cnt":String(cnt)])
    }
}
