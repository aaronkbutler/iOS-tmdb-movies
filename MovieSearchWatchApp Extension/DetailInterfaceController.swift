//
//  DetailInterfaceController.swift
//  MovieSearchWatchApp Extension
//
//  Created by Aaron Butler on 10/28/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var imagePoster: WKInterfaceImage!

    var movie: Movie!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let movie = context as? Movie {
            self.movie = movie
            titleLabel.setText(movie.title + "\n                             \(Int(movie.vote_average * 10))/100")
            descriptionLabel.setText(movie.overview)
            let url = URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + movie.poster_path!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data:data!)
            imagePoster.setImage(image)
        }
       
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
