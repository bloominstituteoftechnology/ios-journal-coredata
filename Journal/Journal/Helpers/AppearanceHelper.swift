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
    
    static var whiteBackground = UIColor(red: 245.0/255.0, green: 251.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    static var highlightColor = UIColor(red: 30.0/255.0, green: 190/255.0, blue: 86/255.0, alpha: 1.0)
    static var darkColor = UIColor(red: 71.0/255.0, green: 91.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    
    static func setAppearance() {
        let largeTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 36.0)!]
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18.0)!]
        
        
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = largeTextAttributes
        
//        UIButton.appearance().titleLabel?.font = UIFont(name: "Avenir", size: 18.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        UINavigationBar.appearance().barTintColor = whiteBackground
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = highlightColor.withAlphaComponent(0.7)
        UITableView.appearance().backgroundColor = whiteBackground
        UITableViewCell.appearance().backgroundColor = whiteBackground
        UISegmentedControl.appearance().tintColor = highlightColor.withAlphaComponent(0.6)
    }
}
