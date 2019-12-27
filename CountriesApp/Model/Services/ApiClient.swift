//
//  APIClient.swift
//  Tadawy
//
//  Created by MAC on 1/21/19.
//  Copyright © 2019 CodexGlobal. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    func getApiRequest(apiURL: String, withParameter parameter: String,  completion: @escaping (_ responce : [[String:Any]], _ statue: Bool, _ message: String) -> ()) {
        
        let urlString = NSString(format: "%@%@?%@",Config.sharedInstance.baseUrl!,apiURL,parameter)
        
        print(urlString)
        
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let method: HTTPMethod = .get
        Alamofire.request(escapedAddress!, method: method, parameters: nil,encoding: JSONEncoding.default).responseJSON {
            response in
            let statusCode = response.response?.statusCode
            if statusCode == 401 {
                completion([["":""]], false, NSLocalizedString("Unathorized Access", comment: ""))
                
            }else{
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        let responce = JSON as! NSArray
                        print(responce)
                        completion(responce as! [[String : Any]], true, NSLocalizedString("Done", comment: ""))
                    }
                    
                    break
                case.failure(let error):
                    print(error)
                     completion([["":""]], false, NSLocalizedString("Problem in server side please wait and try again later.", comment: "") )
                    
                    break
                }
            }
        }
    }
    
}
