//
//  City.swift
//  Clima
//
//  Created by Andre Saboia on 7/26/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import Foundation
import UIKit

//CustomStringConvertibleCustomStringConvertible

class City : NSObject {
    
    let name: String
    let tempMax: Double
    let tempMin: Double
    let desc: String
    
    init(name: String, tempMax: Double, tempMin: Double, description: String) {
        self.name = name
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.desc = description
    }
    
//    var description: String {
//        return "\(name), \(tempMax), \(tempMin), \(descrip)"
//    }
    
}