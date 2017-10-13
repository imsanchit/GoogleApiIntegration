//
//  ViewController.swift
//  GoogleApiIntegration
//
//  Created by Sanchit Mittal on 10/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    var locationMarker: GMSMarker!
    var locationManager = CLLocationManager()
    var customLocationResponse: CustomLocationResponse?
    {
        didSet {
            let geometryLocation = customLocationResponse?.results?[0].geometry?.geometryLocation
            
            let coordinate = CLLocationCoordinate2D(latitude: (geometryLocation?.lat)!, longitude: (geometryLocation?.lng)!)
            viewMap.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
            setuplocationMarker(coordinate: coordinate, title: (customLocationResponse?.results?[0].formatted_address!)!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewMap.isMyLocationEnabled=true

        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 28.533520, longitude: 77.210886, zoom: 8.0)
        viewMap.camera = camera
    }
    
    @IBAction func searchByAddress(_ sender: UIBarButtonItem) {
        let addressAlert = UIAlertController(title: "Address Finder", message: "Type the address you want to find:", preferredStyle: UIAlertControllerStyle.alert)
        
        addressAlert.addTextField { (textField) -> Void in
            textField.placeholder = "Address?"
        }
        
        let findAction = UIAlertAction(title: "Find Address", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            let address = (addressAlert.textFields![0] as UITextField).text!
            print(address)
            if address != "" {

                ApiManager.sharedInstance.getLocations(address: address, showResponse: { [weak self] (_ customLocationResponse: CustomLocationResponse?) -> Void in
                    guard let strongSelf = self else { return }
                    strongSelf.customLocationResponse = customLocationResponse
                    if customLocationResponse?.status != "OK" {
                        strongSelf.showAlertDialog(message: "No location found. Try other address")
                    }
                    },showError: { [weak self] () -> Void in
                        guard let strongSelf = self else { return }
                        strongSelf.showAlertDialog(message: "Some error occurred . Try again")
                })
            }
        }
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
        }
        
        addressAlert.addAction(findAction)
        addressAlert.addAction(closeAction)
        present(addressAlert, animated: true, completion: nil)
    }
    
    func showAlertDialog(message: String) {
        let alertController = UIAlertController(title: "GMapsDemo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
        }
        alertController.addAction(closeAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchByLatAndLong(_ sender: UIBarButtonItem) {
        let addressAlert = UIAlertController(title: "Address Finder", message: "Type the latitudes and longitudes you want to find:", preferredStyle: UIAlertControllerStyle.alert)
        
        addressAlert.addTextField { (textField) -> Void in
            textField.placeholder = "Latitude?"
        }
        addressAlert.addTextField { (textField) -> Void in
            textField.placeholder = "Longitude?"
        }
        
        let findAction = UIAlertAction(title: "Find Address", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            let latitude = Double((addressAlert.textFields![0] as UITextField).text!)
            let longitude = Double((addressAlert.textFields![1] as UITextField).text!)
        
            if latitude != nil && longitude != nil {
                self.viewMap.camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 14.0)
                let title = "Lat: " + (latitude?.description)! + " Long: " + (longitude?.description)!
                self.setuplocationMarker(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), title: title)
            }
            
        }
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
        }
        
        addressAlert.addAction(findAction)
        addressAlert.addAction(closeAction)
        present(addressAlert, animated: true, completion: nil)

    }
    
    func setuplocationMarker(coordinate: CLLocationCoordinate2D, title: String) {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = viewMap
        locationMarker.title = title
        locationMarker.appearAnimation = .pop
        locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
        locationMarker.opacity = 0.75
        locationMarker.isFlat = true
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.isMyLocationEnabled = true
            viewMap.settings.myLocationButton = true
            viewMap.settings.compassButton = true
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
    }
}
