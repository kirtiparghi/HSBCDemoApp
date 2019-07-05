//
//  ViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController
{
    var isUserExist:Int!
    var user:User!
    var gradientLayer: CAGradientLayer!
    let userDefaults = UserDefaults.standard
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var textfield_Password: UITextField!
    @IBOutlet weak var textfield_Email: UITextField!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var label_RememberMe: UILabel!
    @IBOutlet weak var btn_CheckBox: UIButton!
    @IBOutlet weak var btn_Signup: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        user = User()
        
        self.title = "LOGIN"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
        
        gestureMethod()
        createGradientLayer()
        activateConstraints()
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        textfield_Email.translatesAutoresizingMaskIntoConstraints = false
        textfield_Password.translatesAutoresizingMaskIntoConstraints = false
        labelHeader.translatesAutoresizingMaskIntoConstraints = false
        label_RememberMe.translatesAutoresizingMaskIntoConstraints = false
        btn_Signup.translatesAutoresizingMaskIntoConstraints = false
        btn_Login.translatesAutoresizingMaskIntoConstraints = false
        btn_CheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = ["textfieldEmail":textfield_Email,"textfieldPassword":textfield_Password, "labelHeader":labelHeader,"label_RememberMe":label_RememberMe,"btn_Signup":btn_Signup,"btn_Login":btn_Login,"btn_CheckBox":btn_CheckBox]
        
        var allConstraints: [NSLayoutConstraint] = []

        //give constraint to instagram label
        let instaLabelConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(132)-[labelHeader]", options:[], metrics: [:], views: viewDictionary)
        let instaLabelConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelHeader]-|", options:.alignAllCenterX, metrics: [:], views: viewDictionary)
        allConstraints += instaLabelConstraint1
        allConstraints += instaLabelConstraint2

        //give constraint textfield email
        let txtEmailConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[labelHeader]-(25)-[textfieldEmail]", options:[], metrics: [:], views: viewDictionary)
        let txtEmailConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldEmail]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtEmailConstraint1
        allConstraints += txtEmailConstraint2

        //give constraint textfield password
        let txtPasswordConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldEmail]-(20)-[textfieldPassword]", options:[], metrics: [:], views: viewDictionary)
        let txtPasswordConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textfieldPassword]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtPasswordConstraint1
        allConstraints += txtPasswordConstraint2

        //give constraint button checkbox
        let btnCheckboxConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldPassword]-(27)-[btn_CheckBox(==24)]", options:[], metrics: [:], views: viewDictionary)
        let btnCheckboxConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[btn_CheckBox(==24)]", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnCheckboxConstraint1
        allConstraints += btnCheckboxConstraint2

        //give constraint label remember me
        let labelRememberMeConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[textfieldPassword]-(27)-[label_RememberMe(==24)]", options:[], metrics: [:], views: viewDictionary)
        let labelRememberMeConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:[btn_CheckBox]-(10)-[label_RememberMe]", options:[], metrics: [:], views: viewDictionary)
        allConstraints += labelRememberMeConstraint1
        allConstraints += labelRememberMeConstraint2

        //give constraint button login
        let btnLoginConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[label_RememberMe]-(20)-[btn_Login(==24)]", options:[], metrics: [:], views: viewDictionary)
        let btnLoginConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[btn_Login]-(20)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnLoginConstraint1
        allConstraints += btnLoginConstraint2
        
        //give constraint button Signup
        let btnSignupConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[btn_Signup(55)]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        let btnSignupConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btn_Signup]-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnSignupConstraint1
        allConstraints += btnSignupConstraint2

        NSLayoutConstraint.activate(allConstraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rememberMeCheck()
    }
    
    //function to handle remember me functionality
    func rememberMeCheck()
    {
        if(userDefaults.string(forKey: "RememberStatus") != "Remember")
        {
            if(userDefaults.string(forKey: "Email") == nil || userDefaults.string(forKey: "Pwd") == nil)
            {
                textfield_Email.text = ""
                textfield_Password.text = ""
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
            }
            else if(userDefaults.string(forKey: "Email") != "" || userDefaults.string(forKey: "Pwd") != "")
            {
                textfield_Email.text = userDefaults.string(forKey: "Email")
                textfield_Password.text = userDefaults.string(forKey: "Pwd")
                btn_CheckBox.setImage(UIImage(named: "rememberme_select"), for: .normal)
            }
            else
            {
                textfield_Email.text = ""
                textfield_Password.text = ""
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
            }
        }
    }
    
    //function to dismiss keyboard when user tap on anywhere when keyboard is visible
    func gestureMethod() {
        //Getures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        //Ends
    }
    
    //function to dismiss keyboard
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    //action performed when button signup tapped
    @IBAction func btn_Signup(_ sender: Any)
    {
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    
    //action performed when checkbox is checked or unchecked
    @IBAction func btn_CheckBox(_ sender: Any)//Remember me functionality
    {
        view.endEditing(true)
        if(textfield_Email.text != "" || textfield_Password.text != "")
        {
            if(btn_CheckBox.currentImage == UIImage(named: "remeberme_unselect"))
            {
                btn_CheckBox.setImage(UIImage(named: "rememberme_select"), for: .normal)
                userDefaults.setValue("Remember", forKey: "RememberStatus")
                userDefaults.setValue(textfield_Email.text, forKey: "Email")
                userDefaults.setValue(textfield_Password.text, forKey: "Pwd")
            }
            else if(btn_CheckBox.currentImage == UIImage(named: "rememberme_select"))
            {
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
                userDefaults.setValue("notRemember", forKey: "RememberStatus")
                userDefaults.setValue("", forKey: "Email")
                userDefaults.setValue("", forKey: "Pwd")
            }
        }
        else
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please fill the fields first.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
    }
    
    //action performed when button login tapped
    @IBAction func btn_Login(_ sender: Any)
    {
        view.endEditing(true)
        if(textfield_Email.text?.isEmpty != false || textfield_Password.text?.isEmpty != false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "All fields are mandatory", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(Utility.isValidEmail(testStr: textfield_Email.text!) == false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter valid Email-Id", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if((self.textfield_Password.text?.count)! <= 5)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password must be 6 or more characters", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else
        {
            let request : NSFetchRequest<User> = User.fetchRequest()
            do {
                let results = try myContext.fetch(request)
                var isExist = 0
                for user in results {
                    if (user.emailid == textfield_Email.text) {
                        isExist = 1
                        self.user = user
                        if (user.password == textfield_Password.text) {
                            let alertBox = UIAlertController(title: "Instagram", message: "Login Successfully", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                                action in
                                
                                if(self.btn_CheckBox.currentImage == UIImage(named: "rememberme_select"))
                                {
                                    self.userDefaults.setValue(self.textfield_Email.text, forKey: "Email")
                                    self.userDefaults.setValue(self.textfield_Password.text, forKey: "Pwd")
                                }
                                self.userDefaults.setValue(self.user.firstname, forKey: "firstname")
                                self.userDefaults.setValue(self.user.lastname, forKey: "lastname")
                                self.userDefaults.setValue(self.user.latitude, forKey: "latitude")
                                self.userDefaults.setValue(self.user.longitude, forKey: "longitude")
                                self.userDefaults.setValue(self.textfield_Email.text, forKey: "email")
                                self.userDefaults.setValue("true", forKey: "isLogin")
                                self.userDefaults.setValue(self.textfield_Password.text, forKey: "password")
                                                                
                                let request : NSFetchRequest<Photos> = Photos.fetchRequest()
                                do {
                                    var result = try self.myContext.fetch(request)
                                }
                                catch {
                                    print("Error while saving users")
                                }
                                

                                
                                self.performSegue(withIdentifier: "homeview", sender: self)
                            })
                            alertBox.addAction(okButton)
                            present(alertBox, animated: true)
                        }
                        else {
                            let alertBox = UIAlertController(title: "Instagram", message: "Email or password is incorrect.", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                                action in
                            })
                            alertBox.addAction(okButton)
                            present(alertBox, animated: true)
                        }
                        break
                    }
                }
                if (isExist == 0) {
                    let alertBox = UIAlertController(title: "Instagram", message: "Sorry!!! User with this email id doesn't exist.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                        action in
                    })
                    alertBox.addAction(okButton)
                    present(alertBox, animated: true)
                }
            }
            catch {
                print("Error while saving users")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)//Segue to send data to CheckResultView view controller.
    {
    }
    
    //function to create gradient view
    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        
        btn_Signup.backgroundColor = UIColor(white: 1, alpha: 0.25)
        
        self.view.layer.addSublayer(gradientLayer)
        self.view.addSubview(btn_Login)
        self.view.addSubview(textfield_Password)
        self.view.addSubview(textfield_Email)
        self.view.addSubview(labelHeader)
        self.view.addSubview(btn_CheckBox)
        self.view.addSubview(labelHeader)
        self.view.addSubview(label_RememberMe)
        self.view.addSubview(btn_Signup)
    }
}

