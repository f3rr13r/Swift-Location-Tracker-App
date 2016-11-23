//
//  ViewController.swift
//  Location Aware
//
//  Created by Harry Ferrier on 8/8/16.
//  Copyright © 2016 CASTOVISION LIMITED. All rights reserved.
//

import UIKit


// Import Core Location
import CoreLocation

// Import MapKit
import MapKit

// Declare CLLocationManagerDelegate
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var map: MKMapView!
    
    
    // Hook up User Interface elements for use within the code...
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var speedlabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var nearestAddressLabel: UILabel!
    
    
    
    // Empty instance of CLLocationManager
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Set up locationManager preferences and ask user for permission.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // If authorization is granted..startUpdatingLocation
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    
    // call locationManager 'didUpdateLocations' method..
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        // locations returns an updating array of locations. Set userLocation to be the first value in the locations array.
        let userLocation = locations[0]
        
        
        
        
        // ** SETUP LOCATION DATA FOR LABELS
        
        
        
        // Get the user's latitude and present it to the user in the latitudeLabel.
        let userLatitude = userLocation.coordinate.latitude
        latitudeLabel.text = "\(userLatitude)º"
        
        // Get the user's longitude and present it to the user in the longitudeLabel.
        let userLongitude = userLocation.coordinate.longitude
        longitudeLabel.text = "\(userLongitude)º"
        
        
        // Create CLLocation for use when finding nearest Address below..
        let userCurrentLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        
        
        // Get the user's altitude and present it to the user in the altitudeLabel.
        let userAltitude = userLocation.altitude
        altitudeLabel.text = "\(userAltitude)ft"
        
        // Get the user's course and present it to the user in the courseLabel.
        let userCourse = userLocation.course
        courseLabel.text = "\(userCourse)º"
        
        // Get the user's speed and present it to the user in the speedLabe;..
        let userSpeed = userLocation.speed
        speedlabel.text = "\(userSpeed)mps"
        
        
        
        
        
        
        // ** SETUP MAP VIEW
        
        // Set lat and lon delta..
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        
        // Create location span using lat and lon delta
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        // Create coordinate for map
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        
        // Create region using coordinate and span
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        
        // Finally, set the region for the map.
        map.setRegion(region, animated: true)
        
        
        
        
        
        
        // ** SETUP NEAREST ADDRESS FOR LABEL
        
        // Create an instance of CLGeocoder...
        let geoCoder: CLGeocoder = CLGeocoder()
        
        // Call the 'reverseGeocodeLocation method, that sets the location of the user to be the value in the userCurrentLocation constant, and handles the returning data in a closure...
        geoCoder.reverseGeocodeLocation(userCurrentLocation) { (placemarks, error) in
            
            
            // If there is no error...
            if error == nil {
            
                
                // Create an instance of a CLPlacemark and set the value of it to be the first value in the returned placemarks array..
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                
                // Check the following conditions...
                
                // If streetName, city, zip and country are all found to be properties in the returned 'placemarks' array, if they all have values, and if those values are castable to a type of NSString....
                if let streetName = placeMark.addressDictionary?["Thoroughfare"] as? NSString,
                   let city = placeMark.addressDictionary?["City"] as? NSString,
                   let zip = placeMark.addressDictionary?["ZIP"] as? NSString,
                   let country = placeMark.addressDictionary?["Country"] as? NSString {
                    
                    // Display the address in the nearestAddressLabel using string interpolation and line breaks..
                    self.nearestAddressLabel.text = "\(streetName)\n\(city)\n\(zip)\n\(country)"
                
                
                // Else if it didn't work above...
                } else {
                
                    // Couldn't get user address
                    self.nearestAddressLabel.text = "Failed to find nearest address"
                
                }
            
            } else {
            
                // There was an error during the initial retrieval of data, so handle the data appropriately...
            
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

