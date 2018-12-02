//
//  MainPageViewController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/11/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import Material
import Hero

class MainPageViewController: UIViewController{
    fileprivate var card: PresenterCard!
    
    //lets check if has email verified. if not. send email
  
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
        view.backgroundColor = Color.grey.lighten5
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
        self.view.backgroundColor = UIColor.flatYellow()
        self.view.hero.isEnabled = true
        self.view.hero.id = "wired"
        self.view.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        
    
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


extension MainPageViewController {
    fileprivate func preparePresenterView() {
        presenterView = UIImageView()
        presenterView.image = UIImage(named: "p2")?.resize(toWidth: view.frame.width)
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
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        
    }
    
    fileprivate func prepareShareButton() {
        shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
      //  shareButton.addTarget(self, action: #selector(handleRegister(sender:)), for: .touchUpInside)
    }
    
   
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: [moreButton])
        
        toolbar.title = "Time Mazine"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Record your Time with us"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    fileprivate func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "How did it get so late so soon? -- Dr. Seuss"
        contentView.font = RobotoFont.regular(with: 14)
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
    }
    
    
}
