//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayPhotos: [Photos]!
    var currentPhoto : Photos!
    var window: UIWindow?
    let images : [String] = ["1","2","3","4","5","6","7","8","9","10","11"]
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var feedPhotoCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var stackViewTopSection: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarContent()
        
        self.arrayPhotos = [Photos]()
        feedPhotoCollectionView.delegate = self
        feedPhotoCollectionView.dataSource = self
        
        setProfilePicNameEmail()
        implementColletionLayout()

        //Fetch photos current user from database
        let email = self.userDefaults.value(forKey: "email")!
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        request.predicate = NSPredicate(format: "useremail=%@", email as! CVarArg)
        do {
            self.arrayPhotos.removeAll()
            self.arrayPhotos = try myContext.fetch(request)
                        
            for item in 0..<self.arrayPhotos.count {
                let i = self.arrayPhotos[item]
                if i.useremail == nil {
                    self.arrayPhotos.remove(at: item)
                }
            }
        }
        catch {
            print("Error while saving users")
        }
        
        activateConstraints()
    }
    
    //give constraints using VFL Language
    func activateConstraints() {
        feedPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary:[String:Any] = [                "feedPhotoCollectionView":feedPhotoCollectionView,"imageCollectionView":imageCollectionView,"profilePhotoImageView":profilePhotoImageView,"photoLabel":photoLabel,"stackviewTop":stackViewTopSection]
        
        var allConstraints: [NSLayoutConstraint] = []
                
        //give constraint to label photo
        let lblPhotoConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[profilePhotoImageView]-(24)-[photoLabel(==22)]", options:[], metrics: [:], views: viewDictionary)
        let lblPhotoConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[photoLabel]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += lblPhotoConstraint1
        allConstraints += lblPhotoConstraint2

        //give constraint to collectionview
        let collectionViewConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[photoLabel]-(0)-[feedPhotoCollectionView]-|", options:[], metrics: [:], views: viewDictionary)
        let collectionViewConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[feedPhotoCollectionView]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        let collectionViewConstraint3 = NSLayoutConstraint.constraints(withVisualFormat: "V:[photoLabel]-(0)-[imageCollectionView]-|", options:[], metrics: [:], views: viewDictionary)
        let collectionViewConstraint4 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[imageCollectionView]-(0)-|", options:[], metrics: [:], views: viewDictionary)

        allConstraints += collectionViewConstraint1
        allConstraints += collectionViewConstraint2
        allConstraints += collectionViewConstraint3
        allConstraints += collectionViewConstraint4
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    //setup navigation bar
    func setupNavigationBarContent() {
        self.title = "PROFILE"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
    }
    
    //implement collection layout
    func implementColletionLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width / 3 - 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        imageCollectionView.collectionViewLayout = layout
    }
    
    //set profile pic and name and email id
    func setProfilePicNameEmail() {
        nameLabel.text = "\(self.userDefaults.value(forKey: "firstname") as! String) \(self.userDefaults.value(forKey: "lastname") as! String)"
        emailLabel.text = self.userDefaults.value(forKey: "email") as? String
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.width/2
        self.profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.image = UIImage(named: "0")
    }
    
    //action performed when search button is tapped
    @IBAction func btn_Search(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "searchview", sender: self)
    }
    
    //Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)//Segue to send data to CheckResultView view controller.
    {
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
            self.dismiss(animated: true, completion: nil)
            let viewController: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "loginvc") as! UINavigationController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //COLLECTION VIEW DELEGATES AND DATASOURCE METHODS....
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedPhotoViewCell
        let photo = self.arrayPhotos[indexPath.row]
        
        if (photo.imgdata != nil) {
            if let decodedData = Data(base64Encoded: photo.imgdata!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                cell.feedPhotoCell.image = image
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentPhoto = self.arrayPhotos[indexPath.row]

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailVC") as! PhotoDetailVC
        secondViewController.photo = self.currentPhoto
        secondViewController.isFromProfile = 1
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
