//
//  ReceivedListViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/28/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Hero
import ChameleonFramework

class ReceivedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //should we have a list of viewd file for this.
    //one issue. Yes, that is the thread
    var ZectorList : [HyperZector] = []
    enum Constants {
        static let postBackgroundColor = UIColor.black
        static let postPhotoSize = UIScreen.main.bounds
    }
    
    
    let dateFormatter = DateFormatter()
    
    
    let currentUser = CurrentUser()
    

    @IBOutlet weak var ReceiveList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        ReceiveList.delegate = self
        ReceiveList.dataSource = self
        self.view.hero.isEnabled = true
        self.view.hero.id = "userList"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        self.view.backgroundColor = UIColor.flatYellowColorDark()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ZectorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "receivedZector") as? ReceivedListTableViewCell{
            var HyperZector = ZectorList[indexPath.row]
            if HyperZector.Section == "Text"{
                cell.TypeLabel.image = UIImage(named: "text")
            }else{
                cell.TypeLabel.image = UIImage(named: "pic")
            }
            let enddateString = dateFormatter.string(from: HyperZector.EndDate)
            let dateString = dateFormatter.string(from: HyperZector.StartDate)
            cell.StartDate.text = "Start From: " + dateString
            cell.EndDate.text = "Open at " + enddateString
            return cell
        }else{
            print("Error creating table view cell")
            return UITableViewCell()
            
        }
        
    }
    
 
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "receivedZector", for: indexPath) as?ReceivedListTableViewCell{
            //display the stuff.
            var HyperZector = ZectorList[indexPath.row]
            //basically lets dont do anything so far??
        }
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "pokemontablecell", for: indexPath) as? TableViewCell {
//            pokemonTosend = pokemonArray![indexPath.row]
//            performSegue(withIdentifier:"ctopinfor" , sender: cell)
//
//        }
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
