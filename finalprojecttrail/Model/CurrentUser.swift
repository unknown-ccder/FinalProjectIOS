//
//  CurrentUser.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/11/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class CurrentUser {
    var username: String!
    var id: String!
    let dbRef = Database.database().reference()
    
    var readPostIDs: [String]?
    
    init() {
        let currentUser = Auth.auth().currentUser
        username = currentUser?.displayName
        id = currentUser?.uid
        readPostIDs = []
    }
    
    
    func getUsername() -> String{
        return username
    }
    
    
    func getReadPostIDs(completion: @escaping ([String]) -> Void) {
        var postArray: [String] = []
        // YOUR CODE HERE
        dbRef.child(firUsersNode).child(id!).observeSingleEvent(of: .value, with: { (timemazine) in
            if(timemazine.exists()) {
                let values = timemazine.value as? [String: [String: String]]
                if let readDict = values?[firReadPostsNode] {
                    for(_, postID) in readDict {
                        postArray.append(postID)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        completion(postArray)
    }
    
    
    func addNewReadPost(postID: String) {
        // YOUR CODE HERE
        dbRef.child(firUsersNode).child(id!).child(firReadPostsNode).childByAutoId().setValue(postID)
        readPostIDs?.append(postID)
    }
    

    
}
