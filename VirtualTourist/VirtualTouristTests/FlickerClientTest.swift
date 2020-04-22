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

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetMethodExpectedURL(){
        let flickerClient = FlickerClient()
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        flickerClient.session = mockURLSession
        flickerClient.taskForGETMethod(FlickerClient.Methods.Rest, parameters: [:]) { (data, error) in
            
        }
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, FlickerClient.Constants.ApiHost)
    }

    func testGetPhotosExpectedResponse(){
        XCTAssertEqual(1, 1)
    }
    
    func testGetPhotosReturnBadJSON(){
        XCTAssertEqual(1, 1)
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
