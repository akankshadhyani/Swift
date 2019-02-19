//
//  RetrievePetsModel.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 12/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import Foundation
import ObjectMapper

class PetsObject: Mappable {
    var response: PetsResponse?
    init() {}
   required init?(map: Map) { }
    func mapping(map: Map) {
        response <- map["response"] }
}
class PetsResponse: Mappable {
    var data: Data?
    var status: Status?
    required init?(map: Map) { }
        func mapping(map: Map) {
            data <- map["data"]
            status <- map["status"]
    }
}
 class Data: Mappable {
    var pets: [PetDetails]?
    required init?(map: Map) { }
    func mapping(map: Map) {
            pets <- map["pets"] }
}
class Status: Mappable {
    var code: Int?
    var message: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
class PetDetails: Mappable {
    var pid: String?
    var image: String?
    var name: String?
    var liked: Bool?
    var desc: String?
    required init?(map: Map) {  }
    func mapping(map: Map) {
        pid <- map["_id"]
        image <- map["image"]
        name <- map["name"]
        liked <- map["liked"]
        desc <- map["description"]
    }
}
