//
//  DigViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/11/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ChameleonFramework


class DigViewController: UIViewController {
    
    let currentUser = CurrentUser()
    //var ZectorList : [HyperZector] = []
    
    let backgroundimage = ["Backgrounds/background1.jpg","Backgrounds/background2.jpg","Backgrounds/background3.jpg","Backgrounds/background4.jpg","Backgrounds/background5.jpg" ]
    
    var loadedZector: [String : (String, HyperZector)] = [:]
    
    var loadedZectorPic: [String: (UIImage, String, HyperZector)] = [:]
    //var loadedZectorPic2: [String: S]
    var bchoosen : UIImage?
    
    
    var readZector: [String : (String, HyperZector)] = [:]
    var readZectorPic: [String: (UIImage, String, HyperZector)] = [:]

    let dbRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatSand()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleupdate()
        preparebackground()
    }
    
    //we need to handle the open of the candle. so get one and return it
    
    @IBAction func DigPressed(_ sender: UIButton) {
        //fetch all the data and present it
        performSegue(withIdentifier: "TextDig", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //how to pick a random pair in loaded zector
        if segue.identifier == "TextDig" {
            if let destination = segue.destination as? OpenCardViewController {
                //here, I need to access the post and do the update
              //  currentUser.addNewReadPost(postID: Array(loadedZector.keys)[0])
                //print("I am reading ", Array(loadedZector.keys)[0])
                //I need to do one update on firebase
                var id : String?
                //id = Array(loadedZector.keys)[0]
                var textcount = Array(loadedZector.keys).count
                var piccount = Array(loadedZectorPic.keys).count
                if (textcount > 0){
                    //do it for text
                    var random = Int.random(in: 0..<textcount)
                    id = Array(loadedZector.keys)[random]
                    dbRef.child(firPostsNode).child(id!).updateChildValues(["read": "true"])
                    
                    
                    //lets get the id for iterate it through
                    var zectorcontent = loadedZector[id!]
                    destination.passedindate = zectorcontent!.1.StartDate
                    destination.passedintext = zectorcontent!.0
                    destination.location = zectorcontent!.1.Location
                    destination.passedinimage = self.bchoosen
                    
                }else if(piccount > 0){
                    //do it for the other
                    var random = Int.random(in: 0..<piccount)
                    id = Array(loadedZectorPic.keys)[random]
                    //print("I am reading ", id, "its content is", Array(loadedZectorPic.values)[random])
                    dbRef.child(firPostsNode).child(id!).updateChildValues(["read": "true"])
                     var zectorcontent = loadedZectorPic[id!]
                    
                    //destination.passedinimage = Array(loadedZectorPic.values)[random]
                    destination.passedinimage = loadedZectorPic[id!]!.0
                    destination.location = zectorcontent!.2.Location
                    destination.passedintext = zectorcontent!.1
                    destination.passedindate = zectorcontent!.2.StartDate
                    
                    
                }else{
                    //we have no text nor others. show the other pages...
                    print("unable to do anything . die")
                    
                    
                }
            }
        }
        
//        if segue.identifier == "PicDig" {
//            if let destination = segue.destination as?PresentImageViewController {
//               // currentUser.addNewReadPost(postID: Array(loadedZectorPic.keys)[0])
//
//               // print("I am reading ", Array(loadedZectorPic.keys)[0])
//                //I need to do one update on firebase
//
//              //  id = Array(loadedZectorPic.keys)[0]
//
//
//                var id : String?
//
//                var size = Array(loadedZectorPic.keys).count
//                var random = Int.random(in: 0..<size)
//                id = Array(loadedZectorPic.keys)[random]
//                //print("I am reading ", id, "its content is", Array(loadedZectorPic.values)[random])
//                dbRef.child(firPostsNode).child(id!).updateChildValues(["read": "true"])
//
//                //destination.passedinimage = Array(loadedZectorPic.values)[random]
//                destination.passedinimage = loadedZectorPic[id!]!.0
//
//            }
//        }
        
    }
    
    
    func preparebackground(){
        //get the url first. 
        //if no background images. what should we do??
        
    //lets work on the handle update first
        //give them the freedom to just view image.
        //lets try to get other image data
        var bpath = backgroundimage.randomElement()
        getDataFromPath(path: bpath!, completion: { (data) in
            if let data = data {
                if let image = UIImage(data: data) {
                    //self.loadedImagesById[post.postId] = image
                   // self.loadedZectorPic[Zector.id] = image
                    //set the image
                    self.bchoosen = image
                    print("why I get the value already??")
                    
                }
                
                //meanning we do have data. so lets do a dictionary
            }
        })
        
        
        
    }
    
    func handleupdate(){
        //remember to clear that part.
        
        getPosts(user: currentUser) { (Zectors) in
            if let Zectors = Zectors {
                clearThreads()
               // print("clear zector")
                self.loadedZector = [:]
                self.loadedZectorPic = [:]
                self.readZector = [:]
                self.readZectorPic = [:]
                for Zector in Zectors {
                    addZectorToLists(kabuto: Zector)
                    //do the difference here
                   // print(Zector.Section)
                if Zector.Section == "Text"{
                        var path = "ZectorsWord/" + Zector.StorePath
                        getDataFromPath(path: path, completion: { (data) in
                            if let data = data {
                                if let text = String(data: data, encoding: String.Encoding.utf8){
                                    if Zector.Read == true{
                                        self.readZector[Zector.id] = (text,Zector)
                                    }else{
                                        self.loadedZector[Zector.id] = (text, Zector)
                                    }
                                    
                                    
                                  //  print(text)
                                }
                                
                                //meanning we do have data. so lets do a dictionary
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
                                
                                //meanning we do have data. so lets do a dictionary
                            }
                        })
                        
                        var path = "Zectors/" + Zector.StorePath
                        getDataFromPath(path:path, completion: { (data) in
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    //self.loadedImagesById[post.postId] = image
                                    if Zector.Read == true{
                                        self.readZectorPic[Zector.id] = (image,tempString,Zector)

                                    }else{
                                        self.loadedZectorPic[Zector.id] = (image,tempString,Zector)

                                    }
//                                    self.loadedZectorPic[Zector.id] = (image,tempString,Zector)
                                  //  print(image)
                                }
                                
                        //meanning we do have data. so lets do a dictionary
                            }
                        })
                        
                  
                        
                    }else{
                        print("error")
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

}
