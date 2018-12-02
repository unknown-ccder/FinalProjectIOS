//
//  ConfirmCreateViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/24/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import ChameleonFramework
import Hero
class ConfirmCreateViewController: UIViewController {
    
    var ZectorContent : String?
    
    var createPhotoViewController: CreatePhotoViewController!
    var createViewController: CreateViewController!
    
    @IBOutlet weak var uploadingdata: UIActivityIndicatorView!
    //need also image work with it
    
    var ZectorContentPic : UIImage?
    
    var Area : String?
    
    @IBOutlet weak var Date: UITextField!
    private var datePicker : UIDatePicker?
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.flatSand()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        self.view.hero.id = "confirm"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        
        
        uploadingdata.hidesWhenStopped = true
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        
        
        
        datePicker?.addTarget(self, action: #selector(ConfirmCreateViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGestrure = UITapGestureRecognizer(target: self, action: #selector(ConfirmCreateViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGestrure)
        Date.inputView = datePicker
   
        

        // Do any additional setup after loading the view.
    }
    
    func complitionhandler()->Void{
        
        
    }
    
    
    
    
    @IBAction func SubmitPressed(_ sender: UIButton) {
        //lets actually do the submits
        uploadingdata.startAnimating()
        if let enddate = Date.text, enddate != "" {
            if let Content = ZectorContent {
                // TODO:
                // Uncomment the line below.
                if(ZectorContentPic != nil) {
                    //should also have a picture place. 
                    print("Success create image, where is section")
                    addPostPic(username: (Auth.auth().currentUser?.displayName)!, Content: Content, postedImage: ZectorContentPic!, EndDate: enddate, Section: "Image", Location: Area!){
                        DispatchQueue.main.async {
                            self.uploadingdata.stopAnimating()
                            self.createPhotoViewController.shouldDismiss = true
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }else{
                    addPost(username: (Auth.auth().currentUser?.displayName)!, content: Content, EndDate: enddate, Section: "Text", Location: Area!) {
                        DispatchQueue.main.async {
                            self.uploadingdata.stopAnimating()
                            self.createViewController.shouldDismiss = true
                            self.dismiss(animated: true, completion: nil)
                        
                            
                        }
                        
                    }
                }
                
            }
        } else {
            let alert = UIAlertController(title: "No Date Selected", message: "You must select a date.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        Date.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
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
