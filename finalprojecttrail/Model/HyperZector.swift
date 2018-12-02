//
//  HyperZector.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/14/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//
import Foundation
import UIKit

class HyperZector {
    
    //This is the main store of our post. it depend on whether it is text, image, or recording
    
    /// Username of the poster
    let username: String
    
    /// The date that the snap was posted
    let StartDate: Date
    
    /// The image path of the post
    let EndDate: Date
    
    /// The ID of the post, generated automatically on Firebase
    let id: String
    
    let StorePath : String
    
    let Location: String
    
    let Read: Bool
    let Section: String
    init(id: String, StorePath: String,username: String, StartDate: String, EndDate: String, Section: String, Read: Bool, Location: String) {
        self.username = username
        self.id = id
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        self.StartDate = dateFormatter.date(from: StartDate)!
        self.EndDate = dateFormatter.date(from: EndDate)!
        self.Section = Section
        self.StorePath = StorePath
        self.Read = Read
        self.Location = Location
        
    }
    
    func getTimeElapsedString() -> String {
        let secondsSincePosted = -StartDate.timeIntervalSinceNow
        let minutes = Int(secondsSincePosted / 60)
        if minutes == 1 {
            return "\(minutes) minute ago"
        } else if minutes < 60 {
            return "\(minutes) minutes ago "
        } else if minutes < 120 {
            return "1 hour ago"
        } else if minutes < 24 * 60 {
            return "\(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            return "1 day ago"
        } else {
            return "\(minutes / 1440) days ago"
        }
        
    }

}
