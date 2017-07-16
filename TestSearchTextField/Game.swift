//
//  Game.swift
//  TestSearchTextField
//
//  Created by Jack Ngai on 6/21/17.
//  Copyright © 2017 Jack Ngai. All rights reserved.
//

import Foundation
import ObjectMapper

class Game: Mappable {
    
    dynamic var id:Int = 0
    dynamic var name: String?
    dynamic var coverArt: NSData? = nil
    dynamic var url: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["cover.url"]
        if let url = url {
            getData(urlString: "https:" + url)
        } else {
            // set base image
        }
        
    }
    
    private func getData(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        
    }
}
