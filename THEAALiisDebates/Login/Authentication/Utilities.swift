//
//  Utilities.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/6/23.
//

//MARK: - This Top ViewController is for Google & Apple Sign In
import UIKit

final class Utilities {
    static let shared = Utilities ()
    
    private init() {}
    
//    @MainActor
//    func topViewController (controller: UIViewController? = nil) -> UIViewController? {
//        
//        ///ignore the keyWindow error
//        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
//        
//        if let navigationController = controller as? UINavigationController {
//            return topViewController (controller: navigationController.visibleViewController)
//        }
//        if let tabController = controller as? UITabBarController {
//            if let selected = tabController.selectedViewController {
//                return topViewController (controller: selected)
//            }
//        }
//        if let presented = controller?.presentedViewController {
//            return topViewController(controller: presented)
//        }
//        return controller
//    }
    @MainActor                              //From ChatGPT
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
            .first?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

}
