//
//  FavoriteMovieTableViewCell.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    func setup(index: Int) {
        title.text = favorites[index].title
        if let posterPathURL = favorites[index].poster_path {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathURL)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self!.poster.image = image
                        }
                    }
                }
            }
        }
    }
}
