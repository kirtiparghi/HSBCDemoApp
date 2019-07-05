//
//  mapViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotoLocationVC: UIViewController, CLLocationManagerDelegate
{
    var latitude:String!
    var longitude:String!
    let LocationManager = CLLocationManager()
    var noLocation:CLLocationCoordinate2D!
    var viewRegion = MKCoordinateRegion()
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        setLogoutButton()
        setBackButton()
        locationSettings()
        activateConstraints()
    }
    
    //location settings
    func locationSettings() {
        LocationManager.delegate = self
        LocationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        map.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = ["map":map]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //give constraint to mapview
        let mapViewConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[map]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        let mapViewConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[map]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += mapViewConstraint1
        allConstraints += mapViewConstraint2
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    //implement back button functionality
    func setBackButton()
    {
        let btnBack : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        btnBack.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    //implement logout button functionality
    func setLogoutButton() {
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
    }
    
    //action performed when back button tapped
    @objc func backTapped()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //action performed when logout button tapped
    @objc func logoutTapped()
    {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: "Instagram", message: "Do you really logout?", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            (result : UIAlertAction) -> Void in
            //On click of yes
            self.userDefaults.setValue("notRemember", forKey: "RememberStatus")
            //self.navigationController?.popToRootViewController(animated: true)
            
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "loginvc") as UIViewController
            self.present(initialViewControlleripad, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Location manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {                
        let newPin = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: (latitude! as NSString).doubleValue, longitude: (longitude! as NSString).doubleValue)
        let region = MKCoordinateRegion( center: center,  span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
        
        //set region on the map
        map.setRegion(region, animated: true)
        
        newPin.coordinate = CLLocationCoordinate2DMake((latitude! as NSString).doubleValue, (longitude! as NSString).doubleValue)
        newPin.title = "Your location"
        map.addAnnotation(newPin)
    }
}
