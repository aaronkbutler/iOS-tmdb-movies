//
//  Movie.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit
//http://ios-tutorial.com/how-to-save-array-of-custom-objects-to-nsuserdefaults/
//https://stackoverflow.com/questions/48069125/swift-4-decoding-orders-codingkeys-does-not-conform-to-expected-type-c
class Movie: NSObject, Decodable, NSCoding {
    
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case poster_path
//        case title
//        case release_date
//        case vote_average
//        case overview
//        case vote_count
//    }
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//
//        self.id = try values.decode(Int.self, forKey: .id)
//
//        if let poster_path = try? values.decode(String.self, forKey: .poster_path) {
//            self.poster_path = poster_path
//        } else {
//            self.poster_path = nil
//        }
//
//        self.title = try values.decode(String.self, forKey: .title)
//
//
//        if let release_date = try? values.decode(String.self, forKey: .release_date) {
//            self.release_date = release_date
//        } else {
//            self.release_date = nil
//        }
//
//        self.vote_average = try values.decode(Double.self, forKey: .vote_average)
//
//        self.overview = try values.decode(String.self, forKey: .overview)
//
//        self.vote_count = try values.decode(Int.self, forKey: .vote_count)
//
//    }
//    static func == (lhs: Movie, rhs: Movie) -> Bool {
//        if(lhs.id == rhs.id && lhs.poster_path == rhs.poster_path && lhs.title == rhs.title && lhs.release_date == rhs.release_date && lhs.vote_average == rhs.vote_average && lhs.overview == rhs.overview && lhs.vote_count == rhs.vote_count) {
//            return true
//        }
//        return false
//    }
    init(id: Int!, poster_path: String?, title: String, release_date: String?, vote_average: Double, overview: String, vote_count: Int?) {
        self.id = id
        self.poster_path = poster_path
        self.title = title
        self.release_date = release_date
        self.vote_average = vote_average
        self.overview = overview
        self.vote_count = vote_count
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let poster_path = aDecoder.decodeObject(forKey: "poster_path") as? String
        let title = aDecoder.decodeObject(forKey: "title") as? String
        let release_date = aDecoder.decodeObject(forKey: "release_date") as? String
        let vote_average = aDecoder.decodeDouble(forKey: "vote_average")
        let overview = aDecoder.decodeObject(forKey: "overview") as? String
        let vote_count = aDecoder.decodeObject(forKey: "vote_count") as! Int
        self.init(id: id, poster_path: poster_path, title: title!, release_date: release_date, vote_average: vote_average, overview: overview!, vote_count: vote_count)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.poster_path, forKey: "poster_path")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.release_date, forKey: "release_date")
        aCoder.encode(self.vote_average, forKey: "vote_average")
        aCoder.encode(self.overview, forKey: "overview")
        aCoder.encode(self.vote_count, forKey: "vote_count")
    }
    
}


