//
//  Convenience.swift
//  FOSSAsia
//
//  Created by Apple on 29/06/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import Foundation
import Alamofire

extension Client {
    
    
    
    func registerUser(_ params: [String: AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {
        
        let url = Constants.Url.registerUrl
        let headers = [
            "Content-Type": "application/vnd.api+json"
        ]
        
        _ = makeRequest(url, .post, headers, parameters: params, completion: { (results,message)  in
            
            
            if let _ = message {
                completion(false, "Unable to Signin")
            } else if let results = results {
                
                guard let response = results as? [String: AnyObject] else {
                    completion(false, Constants.ResponseMessages.InvalidParams)
                    return
                }
                
                completion(true, "Successfully Signed Up")
            }
          
            
            return
            
        })
        
    }
    
    
    
}

