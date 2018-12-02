//
//  CreateViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/11/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import ChameleonFramework
import MapKit
import CoreLocation
import Hero


class CreateViewController: UIViewController,  UITextViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var TextContent: UITextView!
    
    private var currentCoordinate: CLLocationCoordinate2D?
    
    var area = "@Berkeley CA"
    
    //just get users current location is enough.
    let locationManager = CLLocationManager()
    
    

    @IBOutlet weak var Location: UILabel!
    
    
    
    // the content we just going to create
    
    var shouldDismiss : Bool = false
    
    var Content = ""
    // this is just a location
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldDismiss {
            self.dismiss(animated: true, completion: nil)
        }
        Location.text = area
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        self.view.hero.id = "confirm"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        self.TextContent.delegate = self
        
        //ask for permission
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //core location do not require map...
        
        //self.TextContent.isEditable = true
        self.TextContent.isScrollEnabled = false
        //prepareFABButton()
        view.backgroundColor = UIColor.flatMint()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        
        //try to see if we can get the button.
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.flatWhiteColorDark()
        textView.text = ""
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            currentCoordinate = manager.location?.coordinate
            print("current location is nil, try to update")


        }
       // currentCoordinate = manager.location?.coordinate
        
        currentCoordinate = latestLocation.coordinate
        print("successfuly update cur co")
        
        //getAddFromLocation()
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
    
    
    
    
    
    @IBAction func getLocationPressed(_ sender: UIButton) {
        //perform seague
       // performSegue(withIdentifier: "gogetlocation", sender: self)
        //do something else
        getAddFromLocation()
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        // once we pressed the submit button
        guard let Content = TextContent.text else { return }
        
        if Content == "" {
            // alert to the user that they have not created anything so far
            let alertController = UIAlertController(title: "Create Error", message: "Please enter your message.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            //content is not nil so we are trytin to create some conetent
            // change the stuff and perfom segue
            
         

            performSegue(withIdentifier: "TextSubmitted", sender: nil)
            
            
        }
    
    }
    
    
    @IBAction func unwindToCreate(segue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
            let destination = segue.destination as! ConfirmCreateViewController
            destination.createViewController = self
            destination.ZectorContent = TextContent.text
            destination.Area = area
        
        
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






