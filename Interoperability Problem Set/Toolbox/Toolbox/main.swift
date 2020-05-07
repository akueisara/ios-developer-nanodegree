//
//  main.swift
//  Toolbox
//
//  Created by Gabrielle Miller-Messner on 4/12/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

let myToolbox = Toolbox()
let myHammer =  Hammer()
let myDrill = Drill()

myToolbox.tools = [myHammer, myDrill]

let randomIndex = Int(arc4random_uniform(2))
let tool = myToolbox.tools[randomIndex]

if let hammer = tool as? Hammer {
    hammer.drive()
} else if let drill = tool as? Drill {
    drill.screw()
}
