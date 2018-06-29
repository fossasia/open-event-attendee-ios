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
            Constants.Header.contentType : Constants.Header.contentTypeValue
        ]
        
        _ = makeRequest(url, .post, headers, parameters: params, completion: { (results,message)  in
            
            
            if let _ = message {
                completion(false, Constants.ResponseMessages.ServerError)
            } else if results != nil {
                
                completion(true, Constants.ResponseMessages.successMessage)
            }
          
            
            return
            
        })
        
    }
    
    
    
}

