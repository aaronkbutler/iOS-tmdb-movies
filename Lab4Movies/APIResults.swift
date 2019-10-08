//
//  APIResults.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/4/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
    
//    enum CodingKeys: String, CodingKey {
//        case page
//        case total_results
//        case total_pages
//        case results
//    }
//    init(page: Int, total_results: Int, total_pages: Int, results: [Movie]) {
//        self.page = page
//        self.total_results = total_results
//        self.total_pages = total_pages
//        self.results = results
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        self.page = try values.decode(Int.self, forKey: .page)
//        
//        self.total_results = try values.decode(Int.self, forKey: .total_results)
//        
//        self.total_pages = try values.decode(Int.self, forKey: .total_pages)
//        
//        self.results = try values.decode([Movie].self, forKey: .results)
//    }
}
