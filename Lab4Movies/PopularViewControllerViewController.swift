//
//  PopularViewControllerViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/6/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

var popularCells: [Movie]!
var popularImageCache: [UIImage] = []
class PopularViewControllerViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var popularMoviesCollectionView: UICollectionView!
    var results: APIResults!
    //https://medium.com/anantha-krishnan-k-g/pull-to-refresh-how-to-implement-f915743703f8
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        //print("Started")
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if spinner.superview == nil, let superView = popularMoviesCollectionView.superview {
            superView.addSubview(spinner)
            superView.bringSubviewToFront(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popularMoviesCollectionView.addSubview(self.refreshControl)
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available
        {
            registerForPreviewing(with: self, sourceView: view)
            
        }
       grabJSON()

        //https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver
        if let myData = savedFavorites.object(forKey: "favorites") {
            do {
                favorites = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(myData as! Data) as? [Movie]
            } catch {
                favorites = []
            }
        } else {
            favorites = []
        }
        
        if let myData2 = savedFavorites.object(forKey: "favoritesImageCache") {
            do {
                favoritesImageCache = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(myData2 as! Data) as? [UIImage])!
            } catch {
                favoritesImageCache = []
            }
        } else {
            favoritesImageCache = []
        }
        popularMoviesCollectionView.dataSource = self
//        popularCells = []
//        spinner.startAnimating()
//        DispatchQueue.global(qos: .userInitiated).async {
//            popularCells = self.grabJSON()
//            DispatchQueue.main.async {
//                self.spinner.stopAnimating()
//                self.popularMoviesCollectionView.reloadData()
//            }
//        }
       

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as! PopularMovieCellCollectionViewCell
        cell.setup(index: indexPath.row)
        cell.poster.image = popularImageCache[indexPath.row]
        //https://www.vadimbulavin.com/tableviewcell-display-animation/
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0.03 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PopularMovieSelected", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        view.endEditing(true)
//        if(segue.identifier == "PopularMovieSelected") {
//            if let movieVC = segue.destination as? SelectedMovieViewController {
//                //print(popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!])
////                let movieCell = popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first!.item)!]
////                if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieCell.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
////                    let data = try! Data(contentsOf: url)
////                    let json = try! JSONDecoder().decode(VideoResults.self, from: data)
////                    var movieArray = json.results
////                    if(movieArray.count == 1) {
////                        if(movieArray[0].site == "YouTube") {
////                            movieCell.trailer = URL(string: "https://www.youtube.com/watch?v=\(movieArray[0].key ?? "")")
////                        }
////                    } else if(movieArray.count > 1) {
////                        var key = ""
////                        var firstFound = ""
////                        for trailer in movieArray {
////                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && firstFound == "") {
////                                firstFound = trailer.key!
////                            }
////                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && trailer.name?.range(of: "Teaser") == nil) {
////                                key = trailer.key!
////                                break
////                            }
////                        }
////                        if(key == "") {
////                            key = firstFound
////                        }
////                        //DispatchQueue.main.async {
////                        movieVC.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
////                        //movieCell.trailer = URL(string: "https://www.youtube.com/watch?v=\(key)")
////                        //}
////                    }
////                }
//                movieVC.movie = popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!]
//                //movieVC.movie = favorites[indexPath.row]
//                //print(favorites[indexPath.row].trailer)
//                movieVC.trailerURL = popularCells![(popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!].trailer
//            }
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if(segue.identifier == "PopularMovieSelected") {
            if let movieVC = segue.destination as? SelectedMovieViewController {
                movieVC.movie = popularCells![(self.popularMoviesCollectionView.indexPathsForSelectedItems?.first?.item)!]
                
            }
        }
    }
    
    func grabJSON() {
        //        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&include_adult=false")
        //        let data = try! Data(contentsOf: url!)
        //       // print("data is \(data)")
        //        let decoder = JSONDecoder()
        //        let product = try? decoder.decode(APIResults.self, from: data)
        //
        var popularArray: [Movie] = []
        //https://www.hackingwithswift.com/example-code/system/how-to-detect-which-country-a-user-is-in
        if let url = URL(string:
            "https://api.themoviedb.org/3/movie/now_playing?api_key=487eecc5c6b322b023ba0b08d7c89fa9&page=1&region=\(Locale.current.regionCode!)") {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSONDecoder().decode(APIResults.self, from: data)
                popularArray = json.results
                cacheImages(popularArray: popularArray)
            } else {
                DispatchQueue.main.async {
                    self.refreshControl.isHidden = true
                    let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                    self.present(alert, animated: true)
                }
            }
            
            //return popularArray
        }
        //DispatchQueue.global(qos: .background).async {
//            for movie in popularArray {
//                //sleep(UInt32(0.1))
//                //DispatchQueue.global(qos: .background).async {
//                if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
//                    //print(url)
//                    let data = try! Data(contentsOf: url)
//                    let json = try! JSONDecoder().decode(VideoResults.self, from: data)
//                    var movieArray = json.results
//                    if(movieArray.count == 1) {
//                        if(movieArray[0].site == "YouTube") {
//                            movie.trailer = URL(string: "https://www.youtube.com/watch?v=\(movieArray[0].key ?? "")")
//                        }
//                    } else if(movieArray.count > 1) {
//                        var key = ""
//                        var firstFound = ""
//                        for trailer in movieArray {
//                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && firstFound == "") {
//                                firstFound = trailer.key!
//                            }
//                            if(trailer.site == "YouTube" && trailer.type == "Trailer" && trailer.name?.range(of: "Teaser") == nil) {
//                                key = trailer.key!
//                                break
//                            }
//                        }
//                        if(key == "") {
//                            key = firstFound
//                        }
//                        //DispatchQueue.main.async {
//                            movie.trailer = URL(string: "https://www.youtube.com/watch?v=\(key)")
//                        //}
//                        //movieCell.trailer = URL(string: "https://www.youtube.com/watch?v=\(key)")
//                        //}
//                    }
//                }
//          }
       // }
        popularCells = popularArray
    }
    func cacheImages(popularArray: [Movie]) {
        for movie in popularArray {
            if(movie.poster_path != nil) {
                let url = URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + movie.poster_path!)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data:data!)
                popularImageCache.append(image!)
            } else {
                popularImageCache.append(UIImage())
            }
        }
        //print(theImageCache.count)
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        //https://stackoverflow.com/questions/38511133/implement-3d-touch-on-multiple-collection-views-or-table-views-in-the-same-view
        let tableViewPoint = popularMoviesCollectionView.convert(location, from: view)
        //let location2 = CGPoint(x: location.x, y: location.y - 100)
        guard let indexPath = popularMoviesCollectionView?.indexPathForItem(at: tableViewPoint) else { return nil }
        guard let cell = popularMoviesCollectionView.cellForItem(at: indexPath) else { return nil }
        
        guard let movieVC = storyboard?.instantiateViewController(withIdentifier: "movieVC") as? SelectedMovieViewController else { return nil }
        movieVC.movie = popularCells[indexPath.row]
        //Set your Peek height
        //movieVC.preferredContentSize = CGSize(width: 0.0, height: 400)
        let viewPoint = self.view.convert(cell.frame.origin, from: self.popularMoviesCollectionView)
        previewingContext.sourceRect = CGRect(origin: viewPoint, size: cell.frame.size)
        //previewingContext.sourceRect = cell.frame
        //prepare(for: UIStoryboardSegue(identifier: "MovieSelected", source: self, destination: movieVC), sender: self)
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieVC.movie.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
            //DispatchQueue.global().async {
            //print("test")
            if let data = try? Data(contentsOf: url) {
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
            } else {
                let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            //}
            
            //movieVC.movie = movieCells![(self.moviesCollectionView.indexPathsForSelectedItems?.first?.item)!]
            
        }
        return movieVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        popularCells = []
        popularMoviesCollectionView.reloadData()
        DispatchQueue.global(qos: .userInitiated).async {
            self.grabJSON()
            DispatchQueue.main.async {
                self.popularMoviesCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

}
