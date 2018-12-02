//
//  OpenCardViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/30/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
//this is the view controller for present the general one
import Material
//

import ChameleonFramework
class OpenCardViewController: UIViewController {
    var passedintext: String?
    var passedinimage: UIImage?
    
    var passedindate: Date?
    
    var location: String?
    fileprivate var card: PresenterCard!
    
    
    fileprivate var presenterView: UIImageView!
    fileprivate var contentView: UILabel!

    
    
    // Bottom Bar views.
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    fileprivate var shareButton: IconButton!
    
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatYellow()
        print("I am loading the page??")
        preparePresenterView()
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        preparePresenterCard()
        
        
    }
    
    
    
    
    //demonstrate
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension OpenCardViewController {
    fileprivate func preparePresenterView() {
        presenterView = UIImageView()
        if (passedinimage == nil){
            presenterView.image = UIImage(named: "p2")?.resize(toWidth: view.frame.width)
        }else{
            presenterView.image = passedinimage?.resize(toWidth: view.frame.width)
            presenterView.image = presenterView.image?.resize(toHeight: view.frame.width - 20)
        }
//        presenterView.image = passedinimage?.resize(toWidth: view.frame.width)
      //  presenterView.image = UIImage(named: "p2")?.resize(toWidth: view.frame.width)
        
        presenterView.contentMode = .scaleAspectFill
    }
    
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: passedindate ?? Date())
    }
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        
    }
    
    fileprivate func prepareShareButton() {
       // shareButton = IconButton(image: Icon.cm.close, tintColor: Color.blueGrey.base)
      //  shareButton.addTarget(self, action: #selector(handleRegister(sender:)), for: .touchUpInside)
    }
    
   
    
    fileprivate func prepareMoreButton() {

            moreButton = IconButton(image: Icon.cm.close, tintColor: Color.blueGrey.base)
            
            moreButton.addTarget(self, action: #selector(handleRegister(sender:)), for: .touchUpInside)

       
    }
    @objc func handleRegister(sender: UIButton){
        //performSegue(withIdentifier: "toCreate", sender: nil)
        self.dismiss(animated: true, completion: nil)
        print("hello???")
        
    }
    
    fileprivate func prepareToolbar() {
        if(self.parent == nil){
        toolbar = Toolbar(rightViews: [moreButton])
        }else{
            toolbar = Toolbar(rightViews: [])
        }
        
        toolbar.title = "Time Mazine"
        toolbar.titleLabel.textAlignment = .left
        
        //toolbar.detail = "Record your Time with us"
        toolbar.detail = location
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    fileprivate func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        if let textcontent = passedintext{
            contentView.text = textcontent
        }else{
            contentView.text = "How did it get so late so soon? -- Dr. Seuss"
        }
       // contentView.text = "How did it get so late so soon? -- Dr. Seuss"
        
        print(passedintext)
        contentView.font = RobotoFont.regular(with: 15)
    }
    

    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar(leftViews: [favoriteButton], rightViews: [], centerViews: [dateLabel])
    }
    
    fileprivate func preparePresenterCard() {
        card = PresenterCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        
        card.presenterView = presenterView
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3
        
        
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        view.layout(card).horizontally(left: 20, right: 20).center()
        view.layout(card).vertically(top: 20, bottom: 20).center()
    }
    
    
}

    
