//
//  ServiceClass.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 15/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import Foundation
import Alamofire
class Service {
    
    let url = "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/"
    func getType(append tail: String, finished: @escaping (PetsObject) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: "usertoken")! ]
        Alamofire.request(url+tail, method: .get, headers: headers).responseObject { (response: DataResponse<PetsObject>) in
            let dataObject = response.result.value
            finished(dataObject!)
        }
    }
    
    func postType(append tail: String, use parameters: Parameters, finished: @escaping (Response) -> Void) {
        Alamofire.request(url+tail, method: .post, parameters: parameters).responseObject { (response: DataResponse<Response>) in
            let dataObject = response.result.value
            finished(dataObject!)
        }
    }
    
    func putType(append tail: String, put value: Bool, finished: @escaping (PetsObject) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: "usertoken")! ]
        Alamofire.request(url+tail, method: .put, parameters: ["liked": value], encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<PetsObject>) in
            let dataObject = response.result.value
            finished(dataObject!)
        }
    }
}
