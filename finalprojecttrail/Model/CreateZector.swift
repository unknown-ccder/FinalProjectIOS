//
//  CreateZector.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/14/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


var ZectorSection: [String: [HyperZector]] = ["Text": [], "Image": [], "Audio": [], "Video": []]

let SectionName = ["Text", "Image", "Audio", "Video"]
let curuser = CurrentUser()

func getPostFromIndexPath(indexPath: IndexPath) -> HyperZector? {
    let sectionName = SectionName[indexPath.section]
    if let postsArray = ZectorSection[sectionName] {
        return postsArray[indexPath.row]
    }
    print("Unfound posts at index \(indexPath.row)")
    return nil
}

func addZectorToLists(kabuto: HyperZector) {
    //threads[post.thread]?.append(post)
    
    ZectorSection[kabuto.Section]?.append(kabuto)
    
}

func clearThreads() {
   // threads = ["Memes": [], "Dog Spots": [], "Random": []]
    ZectorSection = ["Text": [], "Image": [], "Audio": [], "Video": []]
}


func addPost(username: String, content: String, EndDate: String, Section: String, Location: String ,completion: @escaping ()->Void) {
    // Uncomment the lines beneath this one if you've already connected Firebase:
    let dbRef = Database.database().reference()
    
    let data = content.data(using: .utf8)
    let path0 = "\(UUID().uuidString)"
    
    let path = "ZectorsWord/" + path0
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let dateString = dateFormatter.string(from: Date())
    
    let Read = "false"
    let userid = curuser.id


    let zectorDict: [String:AnyObject] = ["id": userid as AnyObject,
                                          "username": username as AnyObject,
                                        "startdate": dateString as AnyObject,
                                        "enddate": EndDate as AnyObject,
                                        "section": Section as AnyObject,
                                        "storePath": path0 as AnyObject,
                                        "location": Location as AnyObject,
                                        "read": Read as AnyObject]
    // YOUR CODE HERE
    dbRef.child(firPostsNode).childByAutoId().setValue(zectorDict)

    store(data: data, toPath: path, completion: completion)
    
   
}

func addPostPic(username: String, Content: String, postedImage: UIImage, EndDate: String, Section: String, Location: String, completion: @escaping ()->Void) {
    // Uncomment the lines beneath this one if you've already connected Firebase:
    let dbRef = Database.database().reference()
    
    let data = UIImageJPEGRepresentation(postedImage, 0.75)
    
    let data2 = Content.data(using: .utf8)
   // let data = postedImage.jpegData(compressionQuality: 0.75)
    
    let path0 = "\(UUID().uuidString)"
    
    let path = "Zectors/" + path0
    
    let secondPath = "ZectorsWord/" + path0
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let dateString = dateFormatter.string(from: Date())
    let Read = "false"
    
    let userid = curuser.id
    
    
    
    let zectorDict: [String:AnyObject] = ["id": userid as AnyObject,
                                          "username": username as AnyObject,
                                          "startdate": dateString as AnyObject,
                                          "enddate": EndDate as AnyObject,
                                          "section": Section as AnyObject,
                                          "storePath": path0 as AnyObject,
                                          "location": Location as AnyObject,
                                          "read": Read as AnyObject]
    // YOUR CODE HERE
    dbRef.child(firPostsNode).childByAutoId().setValue(zectorDict)
    // dbRef.child(firPostNode)
    store(data: data, toPath: path, completion: completion )
    store(data: data2, toPath: secondPath, completion: completion)
}

func store(data: Data?, toPath path: String, completion: @escaping ()->Void) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print("Oh there is an error when store stuff")
            print(error)
        }else{
            print("No error For storeing ")
            completion()
        }
    }
}

/*
 TODO:
 
 This function should query Firebase for all posts and return an array of Post objects.
 You should use the function 'observeSingleEvent' (with the 'of' parameter set to .value) to get a snapshot of all of the nodes under "Posts".
 If the snapshot exists, store its value as a dictionary of type [String:AnyObject], where the string key corresponds to the ID of each post.
 
 Then, make a query for the user's read posts ID's. In the completion handler, complete the following:
 - Iterate through each of the keys in the dictionary
 - For each key:
 - Create a new Post object, where Posts take in a key, username, imagepath, thread, date string, and read property. For the read property, you should set it to true if the key is contained in the user's read posts ID's and false otherwise.
 - Append the new post object to the post array.
 - Finally, call completion(postArray) to return all of the posts.
 - If any part of the function fails at any point (e.g. snapshot does not exist or snapshot.value is nil), call completion(nil).
 
 Remember to use constants defined in Strings.swift to refer to the correct path!
 */
//func getPosts(user: CurrentUser, completion: @escaping ([HyperZector]?) -> Void) {
//    let dbRef = Database.database().reference()
//    var postArray: [HyperZector] = []
//    dbRef.child("Posts").observeSingleEvent(of: .value, with: { zector -> Void in
//        if zector.exists() {
//
//        } else {
//            completion(nil)
//        }
//    })
//
//
//}

// TODO:
// Uncomment the lines in the function when you reach the appriopriate par in the README.
//func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
//    let storageRef = Storage.storage().reference()
//    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
//        if let error = error {
//            print(error)
//        }
//        if let data = data {
//            completion(data)
//        } else {
//            completion(nil)
//        }
//    }
//}



func getPosts(user: CurrentUser, completion: @escaping ([HyperZector]?) -> Void) {
    let dbRef = Database.database().reference()
    var postArray: [HyperZector] = []
    
    dbRef.child("Zectors").observeSingleEvent(of: .value, with: { timemazine -> Void in
        if timemazine.exists() {
            if let posts = timemazine.value as? [String:AnyObject] {
                    for postKey in posts.keys {
                        // COMPLETE THE CODE HERE
                        //need to check the user id here
                        let val = posts[postKey]
                        if let userid = val?.value(forKey: "id" ) as? String{
                            if userid != user.id{
                                //not match
                                continue
                                print("next one")
                            }else{
                                print("yes, correct user")
                            }
                        }
                        print("this user is")
                        print(val?.value(forKey: "id" ))
                        var username : String?
                        var storePath : String?
                        var Section : String?
                        var startDate : String?
                        var endDate : String?
                        var reaD : Bool?
                        var Location: String?
              
                        if let uservalue = val?.value(forKey: "username") as? String {
                            username = uservalue
                            //need to check if they are the same user
                        }
                        if let pathvalue = val?.value(forKey: "storePath") as? String {
                            storePath = pathvalue
                        }
                        if let threadvalue = val?.value(forKey: "section") as? String {
                            Section = threadvalue
                        }
                        if let datevalue = val?.value(forKey: "startdate") as? String {
                            startDate = datevalue
                           
                        }
                        if let datevalue2 = val?.value(forKey: "enddate") as? String {
                            endDate = datevalue2
                           // print(endDate)
                        }
                        if let read = val?.value(forKey: "read") as? String{
                            reaD = Bool(read)
                        }
                        if let location = val?.value(forKey: "location") as? String{
                            Location = location
                        }
                        
                        let newpobj = HyperZector(id: postKey,
                                           StorePath: storePath!,
                                           username: username!,
                                           StartDate: startDate!,
                                           EndDate: endDate!,
                                           Section :Section!,
                                           Read: reaD!,
                                           Location: Location!)
                        postArray.append(newpobj)
                    }
                    completion(postArray)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
    
    
}

// TODO:
// Uncomment the lines in the function when you reach the appriopriate par in the README.
func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print("trouble for get data from path")
            print(error)
        }
        if let data = data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}

