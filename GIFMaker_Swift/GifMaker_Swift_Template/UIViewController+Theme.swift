//
//  UIViewController+Theme.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/7.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

enum Theme {
    case Light, Dark, DarkTranslucent
}

extension UIViewController {
    func applyTheme(theme: Theme) {
        switch(theme) {
        case .Light:
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.tintColor = UIColor(red: 255.0/255.0, green:51.0/255.0, blue:102.0/255.0, alpha:1.0)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green:51.0/255.0, blue:102.0/255.0, alpha:1.0)]
            view.backgroundColor = UIColor.white
        case .Dark:
            view.backgroundColor = UIColor(red: 46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:1.0)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = UIColor(red: 46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:1.0)
            navigationController?.navigationBar.backgroundColor = UIColor(red: 46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:1.0)
            edgesForExtendedLayout = UIRectEdge()
            
//            navigationController?.navigationBar.barTintColor = UIColor(red: 46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:1.0)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        case .DarkTranslucent:
            view.backgroundColor = UIColor(red: 46.0/255.0, green:61.0/255.0, blue:73.0/255.0, alpha:0.9)
        }
    }
}
