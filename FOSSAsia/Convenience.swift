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

        let headerSignup = [
            Constants.Header.contentType: Constants.Header.contentTypeValueSignup
        ]

        _ = makeRequest(url, .post, headerSignup, parameters: params, completion: { (results, status, message) in



            if let _ = message {
                completion(false, Constants.ResponseMessages.ServerError)
            } else if results != nil {


                completion(true, Constants.ResponseMessages.successMessageSignup)

            }


            return

        })

    }



    func loginUser(_ params: [String: AnyObject], _ completion: @escaping(_ success: Bool, _ results: [String: AnyObject]?, _ error: String) -> Void) {

        let url = Constants.Url.loginUrl

        let headerLogin = [
            Constants.Header.contentType: Constants.Header.contentTypeValueLogin
        ]

        _ = makeRequest(url, .post, headerLogin, parameters: params, completion: { (results, status, message) in


            if results != nil && status == 200 {
                completion(true, results as? [String: AnyObject], Constants.ResponseMessages.successMessageLogin)
            } else {
                completion(false, nil, Constants.ResponseMessages.InvalidParams)
            }


            return

        })

    }


}
