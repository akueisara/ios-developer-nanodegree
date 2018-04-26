//
//  UdacityClient.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/24.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // get the app delegate
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var userID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Authentication (POST) Methods
    func getUserId(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?, _ errormsg: String?) -> Void) {
        
         /* Build the URL, Configure the request */
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.Session
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, _ errormsg: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForAuth(false, NSError(domain: "getUserId", code: 1, userInfo: userInfo), errormsg)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)", ErrorMessage.NoNetwork)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", ErrorMessage.InvalidEmailOrPassword)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", ErrorMessage.NoNetwork)
                return
            }
            
            /* Parse the data and use the data*/
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
                completionHandlerForAuth(false, NSError(domain: "getUserId", code: 1, userInfo: userInfo), ErrorMessage.NoNetwork)
            }
            
            guard let account = parsedResult?[UdacityClient.JSONResponseKeys.Account] as? [String:Any] else {
                sendError("Could not find \(UdacityClient.JSONResponseKeys.Account) in \(parsedResult!)", ErrorMessage.NoNetwork)
                return
            }
            
            guard let userID = account[UdacityClient.JSONResponseKeys.UserId] as? String else {
                sendError("Could not find \(UdacityClient.JSONResponseKeys.UserId) in \(account)", ErrorMessage.NoNetwork)
                return
            }
            
            self.userID = userID
 
            completionHandlerForAuth(true, nil, nil)
        }
        
        /* Start the request */
        task.resume()
    }
    
    func getUserData(userID: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.User
        method = substituteKeyInMethod(method, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
           
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            print(parsedResult)
            
            completionHandlerForAuth(true, nil)
        }
        task.resume()
    }
    
    func logout() {
        
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.Session
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let _ = data else {
                sendError("No data was returned by the request!")
                return
            }
        }
        
        task.resume()
    }
    
    func getStudentLocations(completionHandlerForStudentData: @escaping (_ result: [UdacityStudent]?, _ error: NSError?) -> Void) {
        
        let parameters = [UdacityClient.ParameterKeys.Limit: UdacityClient.ParameterValues.MaxNumber, UdacityClient.ParameterKeys.Order: UdacityClient.ParameterValues.SortedOrder] as [String : AnyObject]
        let method: String = ParseMethods.StundetLocation
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.ParseApiHost, UdacityClient.Constants.ParseApiPath, parameters, withPathExtension: method))
        request.addValue(UdacityClient.Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            if let results = parsedResult?[UdacityClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                let students = UdacityStudent.studentsFromResults(results)
                completionHandlerForStudentData(students, nil)
            } else {
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
            }
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ apiHost: String, _ apiPath: String ,_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = apiHost
        components.path = apiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.url!)
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
