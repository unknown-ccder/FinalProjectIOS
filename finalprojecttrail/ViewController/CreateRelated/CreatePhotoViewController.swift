//
//  CreatePhotoViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/26/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import Photos
import ChameleonFramework
import CoreLocation
import MapKit
import Hero
class CreatePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var Location: UILabel!
    
    @IBAction func GetLocation(_ sender: UIButton) {
        getAddFromLocation()
    }
    private var currentCoordinate: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    var Content : UIImage?
    var shouldDismiss : Bool = false
    
    @IBOutlet weak var ZectorContent: UITextField!
    
    
    var area = "@Berkeley CA"
    
    @IBOutlet weak var FinishEdition: UIButton!
    
    
    
    @IBAction func FinishPressed(_ sender: UIButton) {
        
        //say that we did finish make the image.
        shouldDismiss = false
        guard let Content = imageView.image else { return }
        if Content == nil{
            let alertController = UIAlertController(title: "Create Error", message: "Please enter your select a image.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            print("at least content is here")
            print(Content)
            performSegue(withIdentifier: "PicSubmitted", sender: nil)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConfirmCreateViewController{
        //destination.ZectorContent = TextContent.text
        if(ZectorContent.text == ""){
            destination.ZectorContent = "Hope You have a nice time"
        }else{
            destination.ZectorContent = ZectorContent.text
        }
        
        destination.createPhotoViewController = self
        destination.ZectorContentPic = imageView.image
        destination.Area = area
        }
        
    }
    
    
    @IBAction func unwindToCreate(segue: UIStoryboardSegue) {
        
    }
    
    
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }

    
    
    
    
    
    
    @IBAction func ChooseAction(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else{
                let alertController = UIAlertController(title: "Camera Error", message: "Your Camera is not avaliable", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                imagePickerController.sourceType = .savedPhotosAlbum
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else{
                let alertController = UIAlertController(title: "Library Error", message: "Your PhotoLibrary is not avaliable", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated:true, completion: nil)
        
        
    }
  
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        let selectedImage = info[UIImagePickerControllerOriginalImage]! as! UIImage
    
        imageView.image = selectedImage
        print(selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldDismiss {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func getAddFromLocation(){
        // let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 1000, 1000)
        
        let region = MKCoordinateRegionMakeWithDistance(currentCoordinate!, 1000, 1000)
        var longtitude: CLLocationDegrees = (self.locationManager.location?.coordinate.longitude)!
        var latitude: CLLocationDegrees = (self.locationManager.location?.coordinate.latitude)!
        
        var location = CLLocation(latitude: latitude, longitude: longtitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            if error != nil{
                print("failed")
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0] as CLPlacemark!
                //                let subfair = (pm?.subThoroughfare)!
                //                let through = (pm?.thoroughfare)!
                let locat = (pm?.locality)!
                let addm = (pm?.administrativeArea)!
                let count = (pm?.isoCountryCode)!
                let address =  locat + "," + addm + " " + count
                
                print(address)
                //we need to assign the add
                self.area = address
                self.Location.text = address
                
                //okay, then lets put this add back for them..
            }else{
                print("error")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            currentCoordinate = manager.location?.coordinate
            
            
        }
        // currentCoordinate = manager.location?.coordinate
        
        currentCoordinate = latestLocation.coordinate
        
        //getAddFromLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatMint()
        checkPermission()
        
        //get the location stuff
        self.locationManager.requestAlwaysAuthorization()
        
        self.ZectorContent.delegate = self
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.view.hero.isEnabled = true
        self.view.hero.id = "confirm"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        
        //get the location good.
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ZectorContent.resignFirstResponder()
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
extension CreatePhotoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
