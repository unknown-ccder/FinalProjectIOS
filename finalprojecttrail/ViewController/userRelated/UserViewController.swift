//
//  UserViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/11/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ChameleonFramework
import Hero
class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var UserIDText: UILabel!
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    let currentUser = CurrentUser()
    
    var readZector : [String : HyperZector] = [:]
    
    var ZectorList : [HyperZector] = []
    
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBAction func UploadImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func SavePressed(_ sender: UIButton) {
        save()
        let alertController = UIAlertController(title: "Update User Photo", message: "You have sucessfully update your image", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //setupProfile()
       handleReceived()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hero.isEnabled = true
        self.view.hero.id = "userList"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        setupProfile()
        view.backgroundColor = UIColor.flatYellow()
      
        navigationItem.title = "User Page"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSignOutButtonTapped))

        // Do any additional setup after loading the view.
    }
    @IBAction func ReceivePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewAllReceived", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReceivedListViewController{
            destination.ZectorList = self.ZectorList
        }
        
    }
    
    func setupProfile(){
        
        if let username = Auth.auth().currentUser?.displayName{
            UserIDText.text = " Username : " + username
        }else{
            UserIDText.text = " Username : Default"
            
        }
        if let uid = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
//                    self.unsernameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["pic"] as? String
                    {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                print("sorry unable to find ")
                                return
                            }
                            DispatchQueue.main.async {
                                self.profile_image?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
            
        }
    
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            
//            if((selectedImage.resize(toWidth: 10.5)) != nil){
//                print("nice resize")
//            }else{
//                print("go find othe")
//            }
            //selectedImage.resize(toWidth: 10.5)
            //var change_height = selectedImage.resize(toWidth: 50.5)
            //profile_image.image =  change_height!.resize(toWidth: 50.5)
            
            
            profile_image.image = selectedImage
        
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func handleReceived(){
        //remember to clear that part.
        
        getPosts(user: currentUser) { (Zectors) in
            if let Zectors = Zectors {
                clearThreads()
                print("clear zector")
                self.readZector = [:]
                for Zector in Zectors {
                    addZectorToLists(kabuto: Zector)
                    //do the difference here
                    // print(Zector.Section)
                    if(Zector.Read == true){
                        print(Zector.id, "already read")
                        //need to consider if it is what form..
                        self.readZector[Zector.id] = Zector
                        self.ZectorList.append(Zector)
                    }else{
                        print("not read for this one ")
                    }
                }
            }
        }
    }
    
    
    
    func save(){
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.profile_image.image!)
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
        
    }
    
    @objc func handleSignOutButtonTapped(){
        do{
            try Auth.auth().signOut()
           // performSegue(withIdentifier: "BackToLogin", sender: self)
            //need to work on more
           // let WelcomePage = WelcomeViewController()
           // let loginNavigationController = UINavigationController(rootViewController: WelcomePage)
           // self.present(loginNavigationController, animated: true, completion: nil)
            
            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }catch let err {
            print(err)
        }
    }
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
