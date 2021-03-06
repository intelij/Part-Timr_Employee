//
//  EmployeeVC.swift
//  Part-Timr for Employee
//
//  Created by Michael V. Corpus on 12/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import UIKit
import MapKit

class EmployeeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PartTimrController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var acceptParttimrBtn: UIButton!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var hirerLocation: CLLocationCoordinate2D?
    
    private var timer = Timer();
    
    private var acceptedParttimrRequest = false
    private var parttimrCanceled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        
        HireHandler.Instance.delegate = self
        HireHandler.Instance.observeMessagesForParttimr()
        
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            
            if hirerLocation != nil {
                if acceptedParttimrRequest {
                    let hirerAnnotation = MKPointAnnotation();
                    hirerAnnotation.coordinate = hirerLocation!;
                    hirerAnnotation.title = "Hirer Location";
                    mapView.addAnnotation(hirerAnnotation);
                }
            }
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Part-Timr's Location"
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func acceptPartTimr(lat: Double, long: Double) {
        if !acceptedParttimrRequest {
            partTimrRequest(title: "Part-Timr Request", message: "You have a request at this location Lat \(lat), Long: \(long)", requestAlive: true)
        }
        
    }
    
    func hirerCanceledParttimr() {
        if !parttimrCanceled {
            //canceles Part-Timr request from Hirer's perspective
            HireHandler.Instance.cancelRequestForParttimr()
            self.acceptedParttimrRequest = false
            self.acceptParttimrBtn.isHidden = true
            
            partTimrRequest(title: "Canceled", message: "The Hirer Has Canceled Your Request", requestAlive: false)
        }
        
    }
    
    func parttimrCanceledRequest() {
        acceptedParttimrRequest = false
        acceptParttimrBtn.isHidden = true
        timer.invalidate()
    }
    
    func updateHirersLocation(lat: Double, long: Double) {
        hirerLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func updateParttimrsLocation() {
        HireHandler.Instance.updateParttimrLocation(lat: userLocation!.latitude, long: userLocation!.longitude)
    }
    
    @IBAction func CancelTask(_ sender: Any) {
        if acceptedParttimrRequest {
            parttimrCanceled = true
            acceptParttimrBtn.isHidden = true
            HireHandler.Instance.cancelRequestForParttimr()
            timer.invalidate()
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        if AuthProvider.Instance.logOut() {
            
            if acceptedParttimrRequest {
                acceptParttimrBtn.isHidden = true
                HireHandler.Instance.cancelRequestForParttimr()
                timer.invalidate()
            }
            
            dismiss(animated: true, completion: nil)
            
            print("LOGOUT SUCCESSFUL")
            
        } else {
            partTimrRequest(title: "Could Not Logout", message: "We could not logout at the moment, please try again later", requestAlive: false)
            
        }
        
    }
    
    
    
    private func partTimrRequest(title: String, message: String, requestAlive: Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if requestAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                
                self.acceptedParttimrRequest = true
                self.acceptParttimrBtn.isHidden = false
                
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(EmployeeVC.updateParttimrsLocation), userInfo: nil, repeats: true);
                
                //inform that we accepted the Parttimr
                
                HireHandler.Instance.parttimrAccepted(lat: Double(self.userLocation!.latitude), long: Double(self.userLocation!.longitude))
                
                
            })
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(accept)
            alert.addAction(cancel)
            
        } else {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    private func alertTheUser(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction (UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
    }
    
    
    
}
