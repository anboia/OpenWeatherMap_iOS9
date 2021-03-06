//
//  CitiesTableViewController.swift
//  Clima
//
//  Created by Andre Saboia on 7/25/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import UIKit
import MapKit

class CitiesTableViewController: UITableViewController {
    
    var cities = [City]()
    
    let store = OpenWeatherMapStore()
    
    var searchCoordinate: CLLocationCoordinate2D?
    
    private struct Storyboard {
        static let CellReuseIdentifier = "City Name"
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sotre data
        if searchCoordinate != nil {
            store.fetchCitiesInCycle(15, lat: searchCoordinate!.latitude, lon: searchCoordinate!.longitude) {
                (citiesResult) -> Void in
                switch citiesResult {
                case let .Success(cities):
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cities = cities.sort({$0.name < $1.name})
                        self.tableView.reloadData()
                        return
                    })
                    
                case let .Failure(error):
                    // possibly display an error message
                    print("Error fetching cities weather conditions: \(error)")
                }
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)
        
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = String(city.temp)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "Show City Detail":
                let cell  = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let cdvc = segue.destinationViewController as! CityDetailViewController
                    cdvc.city = cities[indexPath.row]
                }
                
                
            default: break
            }
        }
    }

}
