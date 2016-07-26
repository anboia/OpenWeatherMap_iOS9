//
//  CityDetailViewController.swift
//  Clima
//
//  Created by Andre Saboia on 7/26/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    var city: City?
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var temp_max: UILabel!
    
    @IBOutlet weak var temp_min: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = city!.name
        temp_max.text?.appendContentsOf("\(city!.tempMax)")
        temp_min.text?.appendContentsOf( "\(city!.tempMin)")
        desc.text = city!.desc
    
    }
}
