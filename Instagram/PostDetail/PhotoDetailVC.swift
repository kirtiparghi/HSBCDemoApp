//
//  PhotoDetailVC.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class PhotoDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var isFromProfile:Int!
    var arrComments:[Comment]!
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photo: Photos!
    var imgName: String!
    let userDefaults = UserDefaults.standard
    var gradientLayer: CAGradientLayer!

    @IBOutlet weak var imgViewPhoto : UIImageView!
    @IBOutlet weak var txtViewDesc : UITextView!
    @IBOutlet weak var tblViewComments: UITableView!
    @IBOutlet weak var btnAddComment: UIButton!
    @IBOutlet weak var lblComment: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrComments = [Comment]()
        
        self.title = "PHOTO DETAIL"
        setLogoutButton()
        setBackButton()
        createGradientLayer()
        
        loadData()
        loadComments()
        activateConstraints()
    }

    //give constraints using VFL Language
    func activateConstraints() {
        imgViewPhoto.translatesAutoresizingMaskIntoConstraints = false
        txtViewDesc.translatesAutoresizingMaskIntoConstraints = false
        tblViewComments.translatesAutoresizingMaskIntoConstraints = false
        btnAddComment.translatesAutoresizingMaskIntoConstraints = false
        lblComment.translatesAutoresizingMaskIntoConstraints = false

        let viewDictionary:[String:Any] = [                "imgViewPhoto":imgViewPhoto,"txtViewDesc":txtViewDesc,"tblViewComments":tblViewComments,"btnAddComment":btnAddComment,"lblComment":lblComment]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //give constraint to imageview
        let imgViewConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(74)-[imgViewPhoto(==230)]", options:[], metrics: [:], views: viewDictionary)
        let imgViewConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[imgViewPhoto]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += imgViewConstraint1
        allConstraints += imgViewConstraint2
        
        //give constraint to description
        let txtViewDescConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[imgViewPhoto]-(0)-[txtViewDesc(==70)]", options:[], metrics: [:], views: viewDictionary)
        let txtViewDescConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[txtViewDesc]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += txtViewDescConstraint1
        allConstraints += txtViewDescConstraint2
        
        //give constraint to label comment
        let lblCommentConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[txtViewDesc]-(0)-[lblComment(==21)]", options:[], metrics: [:], views: viewDictionary)
        let lblCommentConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lblComment]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += lblCommentConstraint1
        allConstraints += lblCommentConstraint2
        
        //give constraint to btn add comment
        let btnAddCommentConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnAddComment(==30)]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        let btnAddCommentConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[btnAddComment]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += btnAddCommentConstraint1
        allConstraints += btnAddCommentConstraint2
        
        //give constraint to tableview comment
        let tblViewCommentsConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[lblComment]-(0)-[tblViewComments]-(10)-[btnAddComment]", options:[], metrics: [:], views: viewDictionary)
        let tblViewCommentsConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[tblViewComments]-(0)-|", options:[], metrics: [:], views: viewDictionary)
        allConstraints += tblViewCommentsConstraint1
        allConstraints += tblViewCommentsConstraint2
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    //fetching comments from local database
    func loadComments() {
        let request : NSFetchRequest<Comment> = Comment.fetchRequest()
        request.predicate = NSPredicate(format: "photoid=%@", self.photo.photoid!)
        do {
            let result = try self.myContext.fetch(request)
            self.arrComments = result
            self.tblViewComments.reloadData()
        }
        catch {
            print("Error while saving users")
        }
    }
    
    //load view contents ie.. imageview photo, textview description
    func loadData() {
        if let decodedData = Data(base64Encoded: self.photo.imgdata!, options: .ignoreUnknownCharacters) {
            self.imgViewPhoto.image = UIImage(data: decodedData)
        }
        self.txtViewDesc.text = self.photo.desc
    }
    
    //funtion to create gradient backgroud for the comment button
    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.btnAddComment.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        
        self.btnAddComment.layer.addSublayer(gradientLayer)
    }
    
    //function to setup back button
    func setBackButton()
    {
        let btnBack : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        btnBack.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = btnBack
    }

    //function to setup logout button
    func setLogoutButton() {
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
    }
    
    //action peform when back button tapped
    @objc func backTapped() {
        if self.isFromProfile == 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    //action peformed when log button tapped
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
    
    //TABLE VIEW DATA SOURCE AND DELEGATES METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! CommentCell
        cell.imgViewUser.layer.borderWidth = 3.0
        cell.imgViewUser.layer.borderColor = UIColor.clear.cgColor
        cell.imgViewUser.layer.cornerRadius = 20.0
        cell.imgViewUser.layer.masksToBounds = true
        var imgname = String(indexPath.row)
        imgname.append(".jpg")
        cell.imgViewUser.image = UIImage(named:String(imgname))
        
        var comment = self.arrComments[indexPath.row] as! Comment
        cell.lblComment.text = comment.commentdesc
        cell.lblUserName.text = comment.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrComments.count
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var contr = segue.destination as! PhotoLocationVC
        contr.latitude = self.photo.latitude
        contr.longitude = self.photo.longitude
    }

    //action performed when add comment button tapped
    //it will open a new alert controlle and then user can add comment for the photo
    @IBAction func btnAddCommentTapped(sender:UIButton) {
        let alert = UIAlertController(title: "Add Comment", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let request : NSFetchRequest<Comment> = Comment.fetchRequest()
            do {
                var result = try self.myContext.fetch(request)

                var id = result.count + 1
                
                let comment = Comment(context: self.myContext)
                comment.commentid = String(id)
                comment.commentdesc = textField?.text
                comment.datetime = String("\(Date())")
                comment.username = String("\(self.userDefaults.value(forKey: "firstname") as! String) \(self.userDefaults.value(forKey: "lastname") as! String)")
                comment.photoid = String("\(self.photo.photoid!)")
                
                try self.myContext.save()
                
                self.loadComments()
            }
            catch {
                print("Error while saving users")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
