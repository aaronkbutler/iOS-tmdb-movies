//
//  TableInterfaceController.swift
//  MovieSearchWatchApp Extension
//
//  Created by Aaron Butler on 10/28/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import WatchKit
import Foundation


class TableInterfaceController: WKInterfaceController {
    var popularCells: [Movie]!
    var popularImageCache: [UIImage] = []
    @IBOutlet weak var favoritesTable: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //setTitle("Now Playing")
        if let url = URL(string:
            "https://api.themoviedb.org/3/movie/now_playing?api_key=487eecc5c6b322b023ba0b08d7c89fa9&page=1&region=US") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSONDecoder().decode(APIResults.self, from: data)
                    self.popularCells = json.results
                    self.favoritesTable.setNumberOfRows(self.popularCells.count, withRowType: "WatchCell")
                    self.cacheImages(popularArray: self.popularCells)
                    for index in 0..<self.favoritesTable.numberOfRows {
                        guard let controller = self.favoritesTable.rowController(at: index) as? RowController else { continue }
                        controller.labelTitle.setText(self.popularCells![index].title)
                        print("test")
                    }
                    
                }
                }.resume()
        }
       // grabJSON()
        
        
        
        
        // Configure interface objects here.
    }
//    override func didAppear() {
//
//
//    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let movie = popularCells[rowIndex]
        presentController(withName: "Movie", context: movie)
    }
    func grabJSON() {
        //        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&include_adult=false")
        //        let data = try! Data(contentsOf: url!)
        //       // print("data is \(data)")
        //        let decoder = JSONDecoder()
        //        let product = try? decoder.decode(APIResults.self, from: data)
        //
        //var popularArray: [Movie] = []
        //https://www.hackingwithswift.com/example-code/system/how-to-detect-which-country-a-user-is-in
//        if let url = URL(string:
//            "https://api.themoviedb.org/3/movie/now_playing?api_key=487eecc5c6b322b023ba0b08d7c89fa9&page=1&region=US") {
//            if let data = try? Data(contentsOf: url) {
//                let json = try! JSONDecoder().decode(APIResults.self, from: data)
//                popularArray = json.results
//                cacheImages(popularArray: popularArray)
//                }
//        }
//        popularCells = popularArray
        
        
        
        //popularCells = popularArray
        //print(self.popularCells!)
       
        
        
    }
    
    func cacheImages(popularArray: [Movie]) {
        for (i, movie) in popularArray.enumerated() {
            if(movie.poster_path != nil) {
                let url = URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + movie.poster_path!)
                URLSession.shared.dataTask(with: url!) { data, response, error in
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data:data!)
                    self.popularImageCache.append(image!)
                    let controller = self.favoritesTable.rowController(at: i) as? RowController
                    controller!.image.setImage(self.popularImageCache[i])
                    
                }.resume()
            } else {
                popularImageCache.append(UIImage())
            }
        }
    }

}
