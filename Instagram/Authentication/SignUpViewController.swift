//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SignUpViewController: UIViewController,CLLocationManagerDelegate
{
    var locationManager: CLLocationManager!
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var gradientLayer: CAGradientLayer!
    var currentLocation: CLLocation!
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var textfield_FirstName: UITextField!
    @IBOutlet weak var textfield_Lastname: UITextField!
    @IBOutlet weak var textfield_Emailid: UITextField!
    @IBOutlet weak var textfield_Password: UITextField!
    @IBOutlet weak var textfield_ConfirmPwd: UITextField!
    @IBOutlet weak var btn_SignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //function to do initial setup for the main view
    func initialSetup() {
        self.title = "SIGNUP"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
        
        gestureMethod()
        createGradientLayer()
        locationSetup()
        getUserLocation()
        activateConstraints()
    }

    // configure location manager
    func locationSetup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        labelHeader.translatesAutoresizingMaskIntoConstraints = false
        textfield_FirstName.translatesAutoresizingMaskIntoConstraints = false
        textfield_Lastname.translatesAutoresizingMaskIntoConstraints = false
        textfield_Emailid.translatesAutoresizingMaskIntoConstraints = false
        textfield_Password.translatesAutoresizingMaskIntoConstraints = false
        textfield_ConfirmPwd.translatesAutoresizingMaskIntoConstraints = false
        btn_SignUp.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = ["labelHeader":labelHeader,"textfieldFirstName":textfield_FirstName, "textfieldLastname":textfield_Lastname,"textfieldEmailid":textfield_Emailid,"textfieldPassword":textfield_Password,"textfieldConfirmPwd":textfield_ConfirmPwd,"btn_SignUp":btn_SignUp]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //give constraint to instagram label
        let instaLabelConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(132)-[labelHeader]", options:[], metrics: [:], views: viewDictionary)
        let instaLabelConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelHeader]-|", options:.alignAllCenterX, metrics: [:], views: viewDictionary)
        allConstraints += instaLabelConstraint1
        allConstraints += instaLabelConstraint2
        
        //give constraint textfield first name
        let txtFirstNameConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[labelHeader]-(25)-[textfieldFirstName]", options:[], metrics: [:], views: viewDictionary)
        let txtFirstNameConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldFirstName]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtFirstNameConstraint1
        allConstraints += txtFirstNameConstraint2

        //give constraint textfield last name
        let txtLastNameConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldFirstName]-(15)-[textfieldLastname]", options:[], metrics: [:], views: viewDictionary)
        let txtLastNameConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldLastname]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtLastNameConstraint1
        allConstraints += txtLastNameConstraint2

        //give constraint textfield email
        let txtEmailConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldLastname]-(15)-[textfieldEmailid]", options:[], metrics: [:], views: viewDictionary)
        let txtEmailConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldEmailid]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtEmailConstraint1
        allConstraints += txtEmailConstraint2

        //give constraint textfield password
        let txtPasswordConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldEmailid]-(15)-[textfieldPassword]", options:[], metrics: [:], views: viewDictionary)
        let txtPasswordConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldPassword]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtPasswordConstraint1
        allConstraints += txtPasswordConstraint2

        //give constraint textfield confirm password
        let txtConfirmPasswordConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldPassword]-(15)-[textfieldConfirmPwd]", options:[], metrics: [:], views: viewDictionary)
        let txtConfirmPasswordConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldConfirmPwd]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtConfirmPasswordConstraint1
        allConstraints += txtConfirmPasswordConstraint2
        
        //give constraint button signup
        let btnSignupConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldConfirmPwd]-(15)-[btn_SignUp]", options:[], metrics: [:], views: viewDictionary)
        let btnSignupConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[btn_SignUp]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnSignupConstraint1
        allConstraints += btnSignupConstraint2

        NSLayoutConstraint.activate(allConstraints)
    }
    
    //Location manager delegate method...
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
    }
    
    //get current user location
    func getUserLocation() {
        let locManager = CLLocationManager()
        locationManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            currentLocation = locManager.location
        }
    }
    
    //function to dismiss keyboard
    func gestureMethod()
    {
        //Getures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        //Ends
    }
    
    //function invoke when user tap on area other than keyboard when keyboard is visible
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }

    //action performed when button signup tapped
    @IBAction func btn_SignUp(_ sender: Any)
    {
        view.endEditing(true)
        if(textfield_FirstName.text?.isEmpty != false || textfield_Lastname.text?.isEmpty != false || textfield_Emailid.text?.isEmpty != false || textfield_Password.text?.isEmpty != false || textfield_ConfirmPwd.text?.isEmpty != false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "All fields are mandatory", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(Utility.isValidEmail(testStr: textfield_Emailid.text!) == false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter valid Email-Id", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if((textfield_Password.text?.count)! <= 5)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password must be 6 or more characters", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(textfield_Password.text != textfield_ConfirmPwd.text)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password and Confirm Password doesn't match", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else
        {
            createNewUser()
        }
    }
    
    //core data entry for new user
    func createNewUser() {
        let user = User(context: myContext)
        user.firstname = textfield_FirstName.text
        user.lastname = textfield_Lastname.text
        user.emailid = textfield_Emailid.text
        user.password = textfield_Password.text
        
        user.latitude = "43.772534"
        user.longitude = "-79.343370"
        
        do {
            try myContext.save()
            
            let request : NSFetchRequest<Photos> = Photos.fetchRequest()
            do {
                var result = try myContext.fetch(request)
            }
            catch {
                print("Error while saving users")
            }
            
            let alertBox = UIAlertController(title: "Instagram", message: "Registered Successfully", preferredStyle: .alert)
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
    
    //function to create gradient view
    func createGradientLayer()
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
                
        self.view.layer.addSublayer(gradientLayer)
        self.view.addSubview(textfield_FirstName)
        self.view.addSubview(textfield_Lastname)
        self.view.addSubview(textfield_Emailid)
        self.view.addSubview(textfield_Password)
        self.view.addSubview(textfield_ConfirmPwd)
        self.view.addSubview(btn_SignUp)
        self.view.addSubview(labelHeader)
    }
}
