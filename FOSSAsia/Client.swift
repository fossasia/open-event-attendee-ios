//
//  Client.swift
//  FOSSAsia
//
//  Created by Apple on 28/06/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import UIKit
import Alamofire

class Client: NSObject {

    static let sharedInstance = Client()
    var session: URLSession

    private override init() {
        session = URLSession.shared
    }

    func makeRequest(_ url: String, _ httpMethod: HTTPMethod, _ headers: HTTPHeaders, parameters: [String: AnyObject], completion: @escaping (_ result: AnyObject?,_ statuscode: Int?,_ error: NSError?) -> Void) {

        func sendError(_ error: String) {
            debugPrint(error)
            completion(nil, nil,NSError(domain: "makeRequestMethod", code: 1))
        }


        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response: DataResponse<Any>) in

                print(response)
                print(response.request?.url ?? "Error: invalid URL")

                switch(response.result) {

                case .success(_):
                    if let data = response.result.value as? Dictionary<String, Any> {

                        completion(data as AnyObject?,response.response?.statusCode, nil)
                    }
                    else {
                        
                        completion(nil,nil, NSError(domain: Constants.ResponseMessages.ServerError,code: 1))
                    }
                    break

                case .failure( _):
                    sendError(Constants.ResponseMessages.ServerError)
                    break
                }

        }
    }


}
