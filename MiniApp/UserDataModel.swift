//
//  LoginResponse.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 11/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import Foundation
import ObjectMapper

class Response: Mappable {
    var response: LoginResponse?
    required init?(map: Map) { }
    func mapping(map: Map) {
        response <- map["response"]
    }
    class LoginResponse: Mappable {
        var data: Data?
        var status: Status?
        required init?(map: Map) { }
        func mapping(map: Map) {
            data <- map["data"]
            status <- map["status"]
        }
    }
    class Data: Mappable {
        var token: String
        required init?(map: Map) {
            token = ""
        }
        func mapping(map: Map) {
            token <- map["token"]
        }
    }
    class Status: Mappable {
        var code: Int?
        var message: String?
        required init?(map: Map) {}
        func mapping(map: Map) {
            code <- map["code"]
            message <- map["message"]
        }
    }
}
