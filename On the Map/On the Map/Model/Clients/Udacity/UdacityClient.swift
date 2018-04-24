//
//  UdacityClient.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/24.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
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
                sendError("There was an error with your request: \(error!)", ErrorMessage().NoNetwork)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", ErrorMessage().InvalidEmailOrPassword)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", ErrorMessage().NoNetwork)
                return
            }
            
            /* Parse the data and use the data*/
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            completionHandlerForAuth(true, nil, nil)
        }
        
        /* Start the request */
        task.resume()
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
