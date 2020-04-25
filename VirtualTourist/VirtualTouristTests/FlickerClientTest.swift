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
    var mockURLSession: MockURLSession!
    
    let getPhotosJson = "{ \"photos\": { \"page\": 1, \"pages\": 109, \"perpage\": \"250\", \"total\": \"27127\", \"photo\": [{ \"id\": \"49768938046\", \"owner\": \"28074232@N06\", \"secret\": \"32f27f7b75\", \"server\": \"65535\", \"farm\": 66, \"title\": \"Misato Saitama, manhole cover （埼玉県三郷市のマンホール）\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0 }, { \"id\": \"49768938046\", \"owner\": \"28074232@N06\", \"secret\": \"32f27f7b75\", \"server\": \"65535\", \"farm\": 66, \"title\": \"Misato Saitama, manhole cover （埼玉県三郷市のマンホール）\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0 }, { \"id\": \"49768938046\", \"owner\": \"28074232@N06\", \"secret\": \"32f27f7b75\", \"server\": \"65535\", \"farm\": 66, \"title\": \"Misato Saitama, manhole cover （埼玉県三郷市のマンホール）\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0 }, { \"id\": \"49768938046\", \"owner\": \"28074232@N06\", \"secret\": \"32f27f7b75\", \"server\": \"65535\", \"farm\": 66, \"title\": \"Misato Saitama, manhole cover （埼玉県三郷市のマンホール）\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0 }, { \"id\": \"49768938046\", \"owner\": \"28074232@N06\", \"secret\": \"32f27f7b75\", \"server\": \"65535\", \"farm\": 66, \"title\": \"Misato Saitama, manhole cover （埼玉県三郷市のマンホール）\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0 }] }, \"stat\": \"ok\" }"

    override func setUp() {
        super.setUp()
        flickerClient = FlickerClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        flickerClient.session = mockURLSession
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_GetMethod_ExpectedURL(){
        _ = flickerClient.taskForGETMethod(parameters: [:]) { (data, error) in }
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, FlickerClient.Constants.ApiHost)
        XCTAssertEqual(urlComponents?.path, FlickerClient.Constants.ApiPath)
        XCTAssertEqual(urlComponents?.percentEncodedQuery, "\(FlickerClient.ParameterKeys.ApiKey)=\(FlickerClient.Constants.ApiKey)&\(FlickerClient.ParameterKeys.Format)=\(FlickerClient.ParameterValues.Json)&\(FlickerClient.ParameterKeys.NoJsonCallback)=\(FlickerClient.ParameterValues.JsonCallbackValue)")
    }

    func test_GetPhotos_WhenSuccessful_ExpectedResponse(){
        let jsonData = getPhotosJson.data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.flickr.com/services/rest")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockURLSession = MockURLSession(data: jsonData, urlResponse: urlResponse, error: nil)
        flickerClient.session = mockURLSession
        let photoExpectation = expectation(description: "Photo")
        var caughtFlickerImages: [FlickerImage]? = nil
        var caughtPages: Int? = nil
        flickerClient.getPhotos(coord: CLLocationCoordinate2D(latitude: 35.822213485920344, longitude: 139.8319319429873), page: 1) { images, pages, error in
            caughtFlickerImages = images
            caughtPages = pages
            
            // Fullfil the expectation to let the test runner
            // know that it's OK to proceed
            photoExpectation.fulfill()
        }
        
        // Wait for the expectation to be fullfilled, or time out
        // after 5 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 5) { _ in
            XCTAssertEqual(caughtFlickerImages?[0].id, "49768938046")
            XCTAssertEqual(caughtPages, 109)
        }
    }
    
    func test_GetPhotos_WhenJSONIsInvalid_ReturnsError(){
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        flickerClient.session = mockURLSession
        let errorExpectation = expectation(description: "Error")
        var catchedError: NSError? = nil
        flickerClient.getPhotos(coord: CLLocationCoordinate2D(latitude: 35.822213485920344, longitude: 139.8319319429873), page: 1) { images, pages, error in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { _ in
            XCTAssertNotNil(catchedError)
        }
    }
}

extension FlickerClientTest {
  
  class MockURLSession: SessionProtocol {
    
    var url: URL?
    private let dataTask: MockTask
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
      dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        self.url = url
        dataTask.completionHandler = completionHandler
        return dataTask
    }
  }
  
  class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let responseError: Error?
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?)-> Void
    var completionHandler: CompletionHandler?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
      self.data = data
      self.urlResponse = urlResponse
      self.responseError = error
    }
    
    override func resume() {
      DispatchQueue.main.async() {
        self.completionHandler?(self.data, self.urlResponse, self.responseError)
      }
    }
  }
}
