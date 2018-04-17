//
//  AppUtils.swift
//  MemeMe 2.0
//
//  Created by Kuei-Jung Hu on 16/04/2018.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit

struct AppUtils {
    static func getTextAttributes(textSize: CGFloat) ->  [String: Any] {
        let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: textSize)!,
        NSAttributedStringKey.strokeWidth.rawValue: -1.0 ]
        return memeTextAttributes
    }
    
    static func setupTextField(textField: UITextField, text: String, textSize: CGFloat) {
        textField.defaultTextAttributes = getTextAttributes(textSize: textSize)
        textField.text = text
        textField.textAlignment = .center
    }
}
