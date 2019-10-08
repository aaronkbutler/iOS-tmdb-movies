//
//  MovieCellCollectionViewCell.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

class MovieCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    func setup(index: Int) {
        title.text = movieCells[index].title
        if let posterPathURL = movieCells[index].poster_path {
            self.loadImage(posterPathURL: posterPathURL)
        } else {
            poster.image = nil
        }
//        if let posterPathUrl = movieCells[index].poster_path {
//            let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathUrl)!)
//        //poster.image = movieImageDictionary[movieCells[index]]
//            poster.image = UIImage(data: data!)
//        }
    }
    //https://www.youtube.com/watch?v=XFvs6eraBXM
    let imageCache = NSCache<AnyObject, UIImage>()
    var imageURLString: String?
    func loadImage(posterPathURL: String){
        imageURLString = posterPathURL
        DispatchQueue.global(qos: .background).async { [weak self] in
            if self != nil {
                if let imageFromCache = self!.imageCache.object(forKey: posterPathURL as AnyObject) {
                    DispatchQueue.main.async {
                        //print(posterPathURL)
                        self!.poster.image = imageFromCache
                        return
                    }
                }
            }
            if let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathURL)!) {
                if let image = UIImage(data: data) {
                    let imageToCache = image
                    DispatchQueue.main.async {
                        if self != nil {
                            self!.poster.image = imageToCache
                            self!.imageCache.setObject(imageToCache, forKey: posterPathURL as AnyObject)
                        }
                        
                        
                        
                    }
                }
            }
        }
    }
}
