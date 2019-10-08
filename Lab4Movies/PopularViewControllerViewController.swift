//
//  PopularViewControllerViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/6/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

var popularCells: [Movie]!
class PopularViewControllerViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var popularMoviesCollectionView: UICollectionView!
    var results: APIResults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularMoviesCollectionView.dataSource = self
        popularCells = grabJSON()
        popularMoviesCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as! PopularMovieCellCollectionViewCell
        cell.setup(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PopularMovieSelected", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if(segue.identifier == "PopularMovieSelected") {
            if let movieVC = segue.destination as? SelectedMovieViewController {
                //print(popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!])
                let movieCell = popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first!.item)!]
                if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieCell.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
                    let data = try! Data(contentsOf: url)
                    let json = try! JSONDecoder().decode(VideoResults.self, from: data)
                    var movieArray = json.results
                    if(movieArray.count == 1) {
                        if(movieArray[0].site == "YouTube") {
                            movieVC.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(movieArray[0].key ?? "")")
                        }
                    } else if(movieArray.count > 1) {
                        var key = ""
                        var firstFound = ""
                        for trailer in movieArray {
                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && firstFound == "") {
                                firstFound = trailer.key!
                            }
                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && trailer.name?.range(of: "Teaser") == nil) {
                                key = trailer.key!
                                break
                            }
                        }
                        if(key == "") {
                            key = firstFound
                        }
                        //DispatchQueue.main.async {
                        movieVC.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                        //}
                    }
                }
                movieVC.movie = popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!]
            }
        }
    }
    
    func grabJSON() -> [Movie] {
        //        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&include_adult=false")
        //        let data = try! Data(contentsOf: url!)
        //       // print("data is \(data)")
        //        let decoder = JSONDecoder()
        //        let product = try? decoder.decode(APIResults.self, from: data)
        //
        if let url = URL(string:
            "https://api.themoviedb.org/3/movie/now_playing?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US&page=1") {
            let data = try! Data(contentsOf: url)
            let json = try! JSONDecoder().decode(APIResults.self, from: data)
            let popularArray = json.results
            return popularArray
        }
        return []
    }


}
