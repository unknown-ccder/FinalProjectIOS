//
//  MapLocationViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/28/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import MapKit
import FirebaseStorage
import FirebaseDatabase

class MapLocationViewController: UIViewController {
    var user = Auth.auth().currentUser;
    var loadedZector: [String : (String, HyperZector)] = [:]
    
    var loadedZectorPic: [String: (UIImage, String, HyperZector)] = [:]
    //var loadedZectorPic2: [String: S]
    var bchoosen : UIImage?
    
    
    var readZector: [String : (String, HyperZector)] = [:]
    var readZectorPic: [String: (UIImage, String, HyperZector)] = [:]

    
    let currentUser = CurrentUser()
    var manager: CLLocationManager!
    
    var add : String?
    
    var returnresult : UIImage?
    var returntext : String?
    
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    var selectedZector : HyperZector?

    
//    var readZector : [String : HyperZector] = [:]
    
    var ZectorList : [HyperZector] = []
    //okay a .meicizijizhaojiuxingle
    
    
    private var currentCoordinate: CLLocationCoordinate2D?

    @IBOutlet weak var MapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        //manager.delegate = self
        manager.delegate = self
        configuelocation()
        MapView.delegate = self
        add = "nill"
        
        //DO IT HERE once
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleReceived()
        beginLocationUpdates(locationManager: manager)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //beginLocationUpdates(locationManager: manager)
    }
    
    func configuelocation(){
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            manager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            //beginLocationUpdates(locationManager: manager)
            print("good to load")
           
        }else{
            print("excuesme??")
        }
        
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        MapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        MapView.setRegion(zoomRegion, animated: true)
    }
    
    
    func getAddFromLocation(){
        let userLocation = MapView.userLocation
       // let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 1000, 1000)
        
        let region = MKCoordinateRegionMakeWithDistance(currentCoordinate!, 1000, 1000)
        var longtitude: CLLocationDegrees = (self.manager.location?.coordinate.longitude)!
        var latitude: CLLocationDegrees = (self.manager.location?.coordinate.latitude)!
        
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
               // print(address)
                self.add = address
                //okay, then lets put this add back for them.. 
            }else{
                print("error")
            }
        })
        
    }
    
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
//    {
//        if let annotationTitle = view.annotation?.title
//        {
//            print("User tapped on annotation with title: \(annotationTitle!)")
//            //good then lets get back
//            //able to confirm now.
//
//            //question. how do we avoid create something that u do not wish to ??
//            //how to check which view controller u come from?
//            performSegue(withIdentifier: "GetAddToEdit", sender: self)
//            //this can use. but not for that one....
//            //unwind(for: unwindToCreate, towardsViewController: CreateViewController)
//
//        }
//    }
    func handledownloadpic(path: String){
        //get a handle download pic
        
//        let url = URL(string: path)
//        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            if error != nil{
//                print(error!)
//                print("sorry unable to find ")
//                return
//            }
//            DispatchQueue.main.async {
//                //self.profile_image?.image = UIImage(data: data!)
//                self.returnresult = UIImage(data: data!)
//            }
//        }).resume()
        let storageRef = Storage().reference(withPath: path)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            if error != nil{
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.returnresult = UIImage(data: data!)
            }
        }.resume()
        
        
      
    }
    
    func handledownloadtext(path: String){
        //get a handle download pic
       // let url = URL(string: path)
//        let url = URL(fileURLWithPath: path)
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if error != nil{
//                print(error!)
//                print("sorry unable to find ")
//                return
//            }
//            DispatchQueue.main.async {
//                //self.profile_image?.image = UIImage(data: data!)
//                self.returntext = String(data: data!, encoding: String.Encoding.utf8)
//            }
//        }).resume()
        
        let storageRef = Storage().reference(withPath: path)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            if error != nil{
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.returntext = String(data: data!, encoding: String.Encoding.utf8)
            }
            }.resume()
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetAddToEdit"{
            let destination = segue.destination as! CreateViewController
            // print(add)
            destination.area = add!
            print(destination)
            
        }
        if segue.identifier == "ShowInMap"{
            let destination = segue.destination as! OpenCardViewController
            // print(add)
            //let deterimine right?
            destination.passedinimage = self.returnresult
            destination.passedintext = self.returntext
            
            //call it from dig
            destination.passedindate = selectedZector?.StartDate
            print("so hello world is ",destination.passedintext)
            destination.location = selectedZector?.Location
        }
    }
    
    func handleReceived(){
        //remember to clear that part.
        //this one handle the receive function
//        getPosts(user: currentUser) { (Zectors) in
//            if let Zectors = Zectors {
//                clearThreads()
//                print("clear zector")
//                self.readZector = [:]
//                self.ZectorList = []
//                for Zector in Zectors {
//                    addZectorToLists(kabuto: Zector)
//                    //do the difference here
//                    // print(Zector.Section)
//                    if(Zector.Read == true){
//                        print(Zector.id, "already read")
//                        //need to consider if it is what form..
//                        self.readZector[Zector.id] = Zector
//                        self.ZectorList.append(Zector)
//                    }else{
//                        print("not read for this one ")
//                    }
//                }
//            }
//        }
        
            
            getPosts(user: currentUser) { (Zectors) in
                if let Zectors = Zectors {
                    clearThreads()
                    // print("clear zector")
                    self.loadedZector = [:]
                    self.loadedZectorPic = [:]
                    self.readZector = [:]
                    self.readZectorPic = [:]
                    self.ZectorList = []
                    for Zector in Zectors {
                        addZectorToLists(kabuto: Zector)
                        if Zector.Read == true{
                            self.ZectorList.append(Zector)
                        if Zector.Section == "Text"{
                            var path = "ZectorsWord/" + Zector.StorePath
                            getDataFromPath(path: path, completion: { (data) in
                                if let data = data {
                                    if let text = String(data: data, encoding: String.Encoding.utf8){
                                            self.readZector[Zector.id] = (text,Zector)
                                        
                                    }
                                }
                            })
                            
                        }else if Zector.Section == "Image"{
                            var tempString = ""
                            var secondpath = "ZectorsWord/"+Zector.StorePath
                            getDataFromPath(path: secondpath, completion: { (data) in
                                if let data = data {
                                    if let text = String(data: data, encoding: String.Encoding.utf8){
                                        //self.loadedZector[Zector.id] = (text, Zector)
                                        print(text)
                                        tempString = text
                                    }
                                }
                            })
                            var path = "Zectors/" + Zector.StorePath
                            getDataFromPath(path:path, completion: { (data) in
                                if let data = data {
                                    if let image = UIImage(data: data) {
                                            self.readZectorPic[Zector.id] = (image,tempString,Zector)
                                    }
                                }
                            })
                        }else{
                            print("error")
                        }
                    }
                    }
                    
                    
                    
                }
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
    
    func addanoation(){
        var annotations = MapView.annotations
        if annotations != nil{
            MapView.removeAnnotations(annotations)
        }
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(currentCoordinate!.latitude, currentCoordinate!.longitude);
        myAnnotation.title = "Current location"
        MapView.addAnnotation(myAnnotation)
 
        
        for HyperZector in ZectorList{
            print(HyperZector.id, HyperZector.Location)
            var ZectorAnnotation: MKPointAnnotation = MKPointAnnotation()
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(HyperZector.Location) {(placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?[0] {
                        let location = placemark.location!
                        //print("testing", location.coordinate, HyperZector.id, HyperZector.Location)
                       // return
                        ZectorAnnotation.coordinate = location.coordinate
                    }
                }else{
                    print("unable to found places", HyperZector.Location)
                }
            }
            
            ZectorAnnotation.title = HyperZector.id
            print(ZectorAnnotation.title)
            MapView.addAnnotation(ZectorAnnotation)
            
            
        }
        manager.stopUpdatingLocation()
    }
    
    
}





extension MapLocationViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            
            zoomToLatestLocation(with: latestLocation.coordinate)
           // addanoation()
            
        }
        
        currentCoordinate = latestLocation.coordinate
        
        getAddFromLocation()
       
        addanoation()
        
    }
    
    

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    //we can create an annotation view and let user click on it to make something happen
    
    
    
}

extension MapLocationViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation.title == "Current location"{
            //dont do anything??
            print("current location do exist")
            return nil
        }
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
         annotationView.image = UIImage(named: "anno")
         annotationView.canShowCallout = true
         print("inside view for the annotation is", annotation.title)
         return annotationView

    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
            //good then lets get back
            //able to confirm now.
            
            //question. how do we avoid create something that u do not wish to ??
            //how to check which view controller u come from?
            if(annotationTitle == "Current location" || annotationTitle == "My Location"){
                performSegue(withIdentifier: "GetAddToEdit", sender: self)
            }else{
                //selectedZector = readZector[annotationTitle!]
                if let val = readZectorPic[annotationTitle!] {
                    // now val is not nil and the Optional has been unwrapped, so use it
                    //mean it is...
                    self.returntext = val.1
                    self.returnresult = val.0
                    self.selectedZector = val.2
                    
                }else if let val = readZector[annotationTitle!]{
                    //mean that it is pic
                    self.returntext = val.0
                    self.selectedZector = val.1
                    
                }
                performSegue(withIdentifier: "ShowInMap", sender: self)
            }
            
            //this can use. but not for that one....
            //unwind(for: unwindToCreate, towardsViewController: CreateViewController)
            
        }
    }
}
