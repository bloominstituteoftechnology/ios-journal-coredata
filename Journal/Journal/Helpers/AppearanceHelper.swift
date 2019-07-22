//
//  AppearanceHelper.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import UIKit

enum AppearanceHelper {
    
    static func setAppearance() {
        let largeTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 36.0)!]
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18.0)!]
        
        
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = largeTextAttributes
        
//        UIButton.appearance().titleLabel?.font = UIFont(name: "Avenir", size: 18.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
}
