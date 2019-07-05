//
//  HomeViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentPhoto : Photos!
    var arrayPhotos: [Photos]!
    var image:UIImage!
    let userDefaults = UserDefaults.standard
    var window: UIWindow?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblViewFeeds: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.currentPhoto = Photos(context: myContext)
        self.arrayPhotos = [Photos]()
    
        setupNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
        activateConstraints()
    }
    
    //navigation bar setup
    func setupNavigationBar() {
        self.title = "HOME"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
        
        let btnProfile : UIBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItem.Style.plain, target: self, action: #selector(profileTapped))
        btnProfile.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = btnProfile
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        tblViewFeeds.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = ["tblViewFeeds":tblViewFeeds,"imgView":imgView,"superview":view]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //give constraint to table view feeds
        let tblViewFeedsConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[tblViewFeeds]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        let tblViewFeedsConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[tblViewFeeds]-(0)-|", options:.alignAllCenterX, metrics: [:], views: viewDictionary)
        allConstraints += tblViewFeedsConstraint1
        allConstraints += tblViewFeedsConstraint2
        
        let bottomCenter = (self.view.frame.width/2) - (self.imgView.frame.width/2)
        let metrics = ["bottomCenter":bottomCenter]
        
        //give constraint to imageview plus
        let imgViewConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[imgView(==50)]-(20)-|", options:.alignAllCenterX, metrics: metrics, views: viewDictionary)
        let imgViewConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(bottomCenter)-[imgView(==50)]", options:[], metrics: metrics, views: viewDictionary)
        allConstraints += imgViewConstraint1
        allConstraints += imgViewConstraint2
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPhotos()
    }
    
    //fetching feeds list from the database of all users
    func fetchPhotos() {
        self.arrayPhotos.removeAll()
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        request.predicate = NSPredicate(format: "(useremail!=%@) || (useremail!=nil)", self.userDefaults.value(forKey: "email") as! CVarArg)
        do {
            self.arrayPhotos = try myContext.fetch(request)
            var index = 0
            for item in self.arrayPhotos {
                if item.useremail == nil {
                    self.arrayPhotos.remove(at: index)
                }
                index = index + 1
            }
            
            tblViewFeeds.reloadData()
        }
        catch {
            print("Error while saving users")
        }
    }
    
    //action performed when plus icon is tapped (open pop up for selecting photo from camera or gallery)
    @objc func addTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //open camera
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //open photo library
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //action performed when profile button tapped
    @objc func profileTapped()
    {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    //action performed when logout ubtton tapped
    @objc func logoutTapped()
    {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: "Instagram", message: "Do you really logout?", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            (result : UIAlertAction) -> Void in
            //On click of yes
            self.userDefaults.setValue("notRemember", forKey: "RememberStatus")
            //self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            let viewController: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "loginvc") as! UINavigationController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //TABLE VIEW DATA SOURCE AND DELEGATES METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedsTableViewCell
        cell.imgViewUser.layer.borderWidth = 3.0
        cell.imgViewUser.layer.borderColor = UIColor.clear.cgColor
        cell.imgViewUser.layer.cornerRadius = 20.0
        cell.imgViewUser.layer.masksToBounds = true
        let photo = self.arrayPhotos[indexPath.row]
        if (photo.imgdata != nil) {
            if let decodedData = Data(base64Encoded: photo.imgdata!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                cell.imgViewPic.image = image
            }
            let index = Int(arc4random_uniform(9))
            cell.imgViewUser.image = UIImage(named: String("\(index).jpg"))
            cell.lblUserName.text = String("\(photo.user!.firstname!) \(photo.user!.lastname!)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPhotos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentPhoto = self.arrayPhotos[indexPath.row]
        self.performSegue(withIdentifier: "photodetailsegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "photosegue"
        {
            let viewcontroller = segue.destination as! AddPhotoVC
            viewcontroller.image = self.image
        }
        else if segue.identifier == "searchview"
        {
            let searchview = segue.destination as! SearchViewController
        }
        else if segue.identifier == "photodetailsegue" {
            let viewcontroller = segue.destination as! PhotoDetailVC
            viewcontroller.photo = self.currentPhoto
        }
    }
    
    //uiimagepickercontrolle handler
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.image = info[.originalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        self.performSegue(withIdentifier: "photosegue", sender: self)
    }
}

