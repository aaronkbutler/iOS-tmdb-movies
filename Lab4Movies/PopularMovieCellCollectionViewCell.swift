//
//  PopularMovieCellCollectionViewCell.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/6/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

class PopularMovieCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(index: Int) {
        title.text = popularCells[index].title
//        if let posterPathURL = popularCells[index].poster_path {
//            DispatchQueue.global().async { [weak self] in
//                if let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathURL)!) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self!.poster.image = image
//                        }
//                    }
//                }
//            }
//        }
    }
}
