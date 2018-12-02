//
//  TabBarController.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/13/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit
import ChameleonFramework
import Hero
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBInspectable var defaultIndex: Int = 0
    
//    let plusimage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
//    let button = MDCFloatingButton()
//
    //let button = UIButton()
    
    
    //we should assigh all the view controller if u wish
    
//    var Create: CreateViewController!
//    var MainPage: MainPageViewController!
//    var Dig: DigViewController!
//    var SendToOther: SendToOtherViewController!
//    var User: UserViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
//        Create = CreateViewController()
//        MainPage = MainPageViewController()
//        Dig = DigViewController()
//        SendToOther = SendToOtherViewController()
//        User = UserViewController()

        self.delegate = self
        self.hero.isEnabled = true
       // self.tabBar.barTintColor = UIColor.gray
      //  self.tabBar.tintColor = UIColor.yellow
        //self.tabBar.unselectedItemTintColor = UIColor.darkGray
        
    //    self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        
     //   self.view.insertSubview(button, belowSubview: self.tabBar)
        
    //    button.translatesAutoresizingMaskIntoConstraints = false //<- Important
        //Because you are adding the button programmatically you need set the
        //constraints. to do it, you need set to false the autoresizing mask.
        
        //Here set the constraints.
        //These constraints put the button in the lower right corner, over the tab bar
//        let viewDictionary = ["button":button, "tabBar":self.tabBar]
//        let btn_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(340)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//        let btn_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(340)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//        let btn_POS_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-(-100)-[tabBar]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//        let btn_POS_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button]-(-100)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//        
//        button.addConstraints(btn_V)
//        button.addConstraints(btn_H)
//        self.view.addConstraints(btn_POS_H)
//        self.view.addConstraints(btn_POS_V)
//        viewControllers = [ MainPage, Dig, Create, SendToOther, User]

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController.isKind(of: CreateViewController.self) {
          //  print("I did it or not")
            let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateViewController")
            vc.modalPresentationStyle = .overFullScreen
           // vc.view.hero.modifiers = [.source(heroID: "selected")]
            
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
     //   print(123)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      //  print(321)
    }
}
