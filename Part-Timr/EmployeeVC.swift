//
//  EmployeeVC.swift
//  Part-Timr for Employee
//
//  Created by Michael V. Corpus on 12/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import UIKit
import MapKit

class EmployeeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    //    private var hirerLocation: CLLocationCoordinate2D?
    
    private var acceptedPartTimrRequest = false
    private var employeeCanceled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
      
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Part-Timr's Location"
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
<<<<<<< HEAD
    func acceptPartTimr(lat: Double, long: Double) {
        if !acceptedPartTimrRequest {
            partTimrRequest(title: "Part-Timr Request", message: "You have a request at this location Lat \(lat), Long: \(long)", requestAlive: true)
        }
    }
    
=======
>>>>>>> parent of efeb6f2... inform the driver when the "hire" button from the employer's end is pressed
    @IBAction func CancelTask(_ sender: Any) {
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
            
            print("LOGOUT SUCCESSFUL")
            
        } else {
            self.alertTheUser(title: "Problem logging out", message: "Please try again later.")
        }
        
    }
    
    func alertTheUser(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction (UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
    }


    
}












