//
//  AppDelegate.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            application.registerForRemoteNotifications()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navMasterController = UINavigationController(rootViewController: MasterController())
        let navDetailController = UINavigationController(rootViewController: DetailController())
        let splitController = UISplitViewController()
        splitController.viewControllers = [navMasterController, navDetailController]
        splitController.preferredDisplayMode = .allVisible
        splitController.delegate = self
        splitController.preferredPrimaryColumnWidthFraction = 0.3
        splitController.maximumPrimaryColumnWidth = 2000
        
        window?.rootViewController = splitController
        window?.makeKeyAndVisible()
        return true
    }
}
extension AppDelegate: UISplitViewControllerDelegate{
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        return true
    }
}


