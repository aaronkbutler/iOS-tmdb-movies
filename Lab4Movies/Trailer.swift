//
//  Trailer.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/6/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import Foundation

struct Trailer: Decodable {
    let key: String?
    let name: String?
    let site: String?
    let type: String?
    
//    init(key: String?, site: String?, type: String?) {
//        self.key = key
//        self.site = site
//        self.type = type
//    }
//    required convenience init?(coder aDecoder: NSCoder) {
//        let key = aDecoder.decodeObject(forKey: "key") as? String
//
//        let site = aDecoder.decodeObject(forKey: "site") as? String
//
//        let type = aDecoder.decodeObject(forKey: "type") as? String
//        self.init(key: key, site: site, type: type)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.key, forKey: "key")
//        aCoder.encode(self.site, forKey: "site")
//        aCoder.encode(self.type, forKey: "type")
//    }
    
    
}
