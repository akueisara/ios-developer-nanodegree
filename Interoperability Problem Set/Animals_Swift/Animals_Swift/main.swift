//
//  main.swift
//  Animals_Swift
//
//  Created by Gabrielle Miller-Messner on 4/12/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

// Initialize some animals
let babe = Pig()
let snoopy = GoldenDoodle()
let templeton = Rat()
let sinatra = Rat()
let cary = Pigeon()

// Initialize my dwellings with some animals
let myFarm = Farm(animals:[babe, snoopy, templeton])
let myApartment = Apartment(animals:[sinatra, cary, snoopy])

// Choose an animal to invoke a method
let randomNumber = Int(arc4random_uniform(3))
let farmAnimal = myFarm?.animals![randomNumber]
let cityAnimal = myApartment?.animals![randomNumber]

if let pig = farmAnimal as? Pig {
    pig.wallow()
} else if let goldenDoodle = farmAnimal as? GoldenDoodle {
    goldenDoodle.romp()
} else if let rat = farmAnimal as? Rat {
    rat.scurry()
}

if let rat = cityAnimal as? Rat {
    rat.scurry()
} else if let pigeon = cityAnimal as? Pigeon {
    pigeon.deliverMessage()
} else if let goldenDoodle = cityAnimal as? GoldenDoodle {
    goldenDoodle.romp()
}
