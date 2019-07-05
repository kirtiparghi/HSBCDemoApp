//
//  AddPhotoVC.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddPhotoVC: UIViewController,CLLocationManagerDelegate, UITextViewDelegate
{
    let userDefaults = UserDefaults.standard
    var locationManager: CLLocationManager!
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var gradientLayer: CAGradientLayer!
    var image:UIImage!
    var currentLocation: CLLocation!
    
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var textviewDesc:UITextView!
    @IBOutlet weak var lblDesc:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ADD PHOTO"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
        
        imgView.image = image
        createGradientLayer()
        getUserLocation()
        setupDescriptionTextView()
        activateConstraints()
    }
    
    //setup description textview
    func setupDescriptionTextView() {
        textviewDesc.text = "Enter Description"
        textviewDesc.textColor = UIColor.lightGray
        textviewDesc.selectedTextRange = textviewDesc.textRange(from: textviewDesc.beginningOfDocument, to: textviewDesc.beginningOfDocument)
        textviewDesc.returnKeyType = UIReturnKeyType.done
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        textviewDesc.translatesAutoresizingMaskIntoConstraints = false
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = [                "btnAdd":btnAdd,"imgView":imgView,"textviewDesc":textviewDesc,"lblDesc":lblDesc]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //give constraint to imageview
        let imgViewConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(74)-[imgView(==266)]", options:[], metrics: [:], views: viewDictionary)
        let imgViewConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[imgView]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += imgViewConstraint1
        allConstraints += imgViewConstraint2
        
        //give constraint to description label
        let lblDescriptionConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[imgView]-(0)-[lblDesc]", options:[], metrics: [:], views: viewDictionary)
        let lblDescriptionConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lblDesc]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += lblDescriptionConstraint1
        allConstraints += lblDescriptionConstraint2
        
        //give constraint to button add
        let btnAddConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnAdd]-(30)-|", options:[], metrics: [:], views: viewDictionary)
        let btnAddConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btnAdd]-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnAddConstraint1
        allConstraints += btnAddConstraint2

        //give constraint to textview description
        let txtViewDescriptionConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[lblDesc]-(5)-[textviewDesc(==128)]", options:[], metrics: [:], views: viewDictionary)
        let txtViewDescriptionConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[textviewDesc]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtViewDescriptionConstraint1
        allConstraints += txtViewDescriptionConstraint2
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    //TEXTVIEW DELEGATES AND DATA SOURCE METHODS...
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {            
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        else if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    //LOCATION MANAGER DELEGATE METHODS....
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       currentLocation = locations.last! as CLLocation
    }
    
    //get current user location using location manager
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    //action performed when add photo button tapped
    @IBAction func btnAddPhotoTapped(sender:UIButton)
    {
        if(textviewDesc.text == "") {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter description", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else {
          self.addNewPhotoDB()
        }
    }

    //add new photo detail into the database to show it later on.
    func addNewPhotoDB() {
        view.endEditing(true)
        if(textviewDesc.text?.isEmpty == true || textviewDesc.text == nil)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter photo description", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
            return
        }
        
        //GET TOTAL PHOTOS IN DB
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        var count = 0
        do {
            let results = try myContext.fetch(request)
            count = results.count
        }
        catch {
            print("Error while fetching photos")
        }
        
        let photo = Photos(context: myContext)
        photo.photoid = String("\(count+1)")
        photo.desc = textviewDesc.text
        photo.datetime = String("\(Date())")
        photo.useremail = self.userDefaults.value(forKey: "email") as? String
        let imageData:NSData = self.image!.pngData()! as NSData
        photo.imgdata = imageData.base64EncodedString(options: .lineLength64Characters)
        photo.latitude = String("\(self.currentLocation.coordinate.latitude)")
        photo.longitude = String("\(self.currentLocation.coordinate.longitude)")
        let user = User(context: myContext)
        user.firstname = self.userDefaults.value(forKey: "firstname") as! String
        user.lastname = self.userDefaults.value(forKey: "lastname") as! String
        user.emailid = self.userDefaults.value(forKey: "email") as! String
        user.password = self.userDefaults.value(forKey: "password") as! String
        user.latitude = self.userDefaults.value(forKey: "latitude") as! String
        user.longitude = self.userDefaults.value(forKey: "longitude") as! String
        
        photo.user = user
        do {
            try myContext.save()
            let alertBox = UIAlertController(title: "Instagram", message: "Photo Added Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.navigationController?.popViewController(animated: true)
            })
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
            
        }
        catch {
            print("an error occured while saving: \(error)")
        }
    }

    //function which create gradient color to give intuitive look to the app
    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.btnAdd.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        self.btnAdd.layer.addSublayer(gradientLayer)
    }
}
