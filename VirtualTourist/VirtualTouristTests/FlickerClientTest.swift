//
//  FlickerClientTest.swift
//  VirtualTouristTests
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import XCTest
import MapKit
@testable import VirtualTourist

class FlickerClientTest: XCTestCase {
    
    var flickerClient: FlickerClient!

    override func setUp() {
        flickerClient = FlickerClient.sharedInstance()
    }

    override func tearDown() {
        flickerClient = nil
    }

    func testFlickerClientGetPhotosByCor() {
        let lat = 0.0
        let long = 0.0
        let url = URL(string:FlickerClient.Constants.ApiUrl + "?lat=\(lat)&long=\(long)&format=json&nojsoncallback=1")
        flickerClient.getPhotos(url){(photos, error) in
            
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
