//
//  MapViewController.swift
//  Clima
//
//  Created by Andre Saboia on 7/23/16.
//  Copyright © 2016 Andre Saboia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let searchPoint = MKPointAnnotation()
    
    var searchCoordinate: CLLocationCoordinate2D {
        get { return searchPoint.coordinate }
        set {
            searchPoint.coordinate = newValue
            searchButton.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchPoint.addObserver(self, forKeyPath: "coordinate", options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutablePointer<Void>#>)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cvc = segue.destinationViewController as? CitiesTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Show Cities":
                    print("show cities")
                    cvc.searchCoordinate = searchCoordinate
                default:
                    print("no option")
                    break
                }
            }
        }
    }
    @IBAction func buscar(sender: UIBarButtonItem) {
    }
    
    @IBAction func searchLocation(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            
            let locationInView = sender.locationInView(mapView)
            searchCoordinate = mapView.convertPoint(locationInView, toCoordinateFromView: mapView)
            mapView.addAnnotation(searchPoint)
            
            print("locationInView: \(locationInView)")
            print("annotation: \(searchCoordinate)")
        }
    }

}

