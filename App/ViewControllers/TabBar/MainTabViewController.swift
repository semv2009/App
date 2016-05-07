//
//  MainTabViewController.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class MainTabViewController: UITabBarController {
    
    var stack: CoreDataStack
    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listController = UINavigationController(rootViewController: PersonTableViewController(coreDataStack: stack))
        let galleryController = GalleryViewController()
        let serviceController = ServiceViewController()
        let controllers = [listController, galleryController, serviceController]
        viewControllers = controllers
        
        listController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(imageLiteral: "List"),
            tag: 1)
        galleryController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(imageLiteral: "Gallery"),
            tag: 1)
        serviceController.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(imageLiteral: "Service"),
            tag: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("\(item.title)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
