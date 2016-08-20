//
//  ViewController.swift
//  Memorable Places
//
//  Created by Divakar Kapil on 2016-06-19.
//  Copyright © 2016 Divakar Kapil. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        map.delegate = self
        
        if activePlace == -1{
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()

        }
        else{
            
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["long"]!).doubleValue
            
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
            
            //let latDelta: CLLocationDegrees = 0.000000001
            //let longDelta: CLLocationDegrees = 0.000001
            
            //let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
            
            let region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius*2, regionRadius*2)
            
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            
            self.map.addAnnotation(annotation)
            
            
        }
        
        
        let uilgpr = UILongPressGestureRecognizer(target : self, action: "action:")
        uilgpr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilgpr)
        
    }
    
    
    func action(gestureRecognizer : UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if (error == nil){
                    
                    var title = ""
                    
                    if let p = placemarks?[0]{
                        
                        var subThoroughFare : String = " "
                        var thoroughFare : String = " "
                        
                        if p.subThoroughfare != nil{
                            
                            subThoroughFare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughFare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughFare)"+" "+"\(thoroughFare)"
                        
                    }
                    
                    // This is to display a diiferent title for all places in case none of the above is executed. So, the annotation.title has something to dispaly
                    if title == ""{
                        
                        title = "Added\(NSDate())"
                    
                    }
                    
                    // Appending the locations annoted by the user to the dictionary
                    
                    places.append(["name" : title, "lat" : "\(newCoordinate.latitude)", "long" : "\(newCoordinate.longitude)"])
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    
                    self.map.addAnnotation(annotation)
                }
                
            })
            
            
        }
        
        
    }
    
    
    var regionRadius : CLLocationDistance = 1000

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // We want to center the map at the user's location; We stor the location.
        
        let userLocation : CLLocation = locations[0]
        
        // extracting the latitude and longitude from the user's location
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
       let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
        
        //let latDelta: CLLocationDegrees = 0.000000001
        //let longDelta: CLLocationDegrees = 0.000001
        
        //let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta,longDelta)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius*2, regionRadius*2)
        
        self.map.setRegion(region, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

