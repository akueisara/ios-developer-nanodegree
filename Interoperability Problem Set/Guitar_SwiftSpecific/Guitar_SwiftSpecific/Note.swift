//
//  Note.swift
//  Guitar
//
//  Created by Gabrielle Miller-Messner on 4/13/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Cocoa

class Note: NSObject {
    
    let velocity: Float
    
    @objc init(velocity: Float) {
        self.velocity = velocity
    }
}
