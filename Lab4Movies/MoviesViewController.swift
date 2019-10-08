//
//  MoviesViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//
//icons from icons8.com
import UIKit

var movieCells: [Movie]!
class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate/*, UIViewControllerPreviewingDelegate*/{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var moviesCollectionView: UICollectionView!
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var movieSearch: String!
    var results: APIResults!
    override func viewDidLoad() {
        super.viewDidLoad()
        let popularVC = PopularViewControllerViewController()
        popularCells = popularVC.grabJSON()
//        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available
//        {
//            registerForPreviewing(with: self, sourceView: view)
//
//        }
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
        
        moviesCollectionView.dataSource = self
        //results = grabJSON(movieSearch: "")
            /*APIResults(page: 1, total_results: 1, total_pages: 1, results:
            
            [
                Movie(id: 1234, poster_path: "first", title: "Great Movie", release_date: "2004", vote_average: 39.5, overview: "An excellent film!", vote_count: 1000/*, rating: "PG-13"*/)
                ,
                Movie(id: 4321, poster_path: "second", title: "Amazing Movie", release_date: "2010", vote_average: 50.2, overview: "An excellent film! Must watch!!!", vote_count: 100/*, rating: "PG"*/)
            ]
        )*/
        movieCells = []
        //grabJSON()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if spinner.superview == nil, let superView = moviesCollectionView.superview {
            superView.addSubview(spinner)
            superView.bringSubviewToFront(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }
    func grabJSON(movieSearch: String) -> [Movie] {
//        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&include_adult=false")
//        let data = try! Data(contentsOf: url!)
//       // print("data is \(data)")
//        let decoder = JSONDecoder()
//        let product = try? decoder.decode(APIResults.self, from: data)
//
        if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&include_adult=false") {
            let data = try! Data(contentsOf: url)
            let json = try! JSONDecoder().decode(APIResults.self, from: data)
            var movieArray = json.results
            DispatchQueue.main.async {
                movieCells = movieArray
                self.moviesCollectionView.reloadData()
            }
//            if(json.total_pages > 1) {
//                if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&page=\(2)&include_adult=false") {
//                    let data = try? Data(contentsOf: url)
//                    if(data != nil) {
//                        let json = try! JSONDecoder().decode(APIResults.self, from: data!)
//                        movieArray += json.results
//                        DispatchQueue.main.async {
//                            movieCells = movieArray
//                            self.moviesCollectionView.reloadData()
//                        }
//                    }
//                }
                if(json.total_pages > 2) {
                    for i in 2...json.total_pages {
                        if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=487eecc5c6b322b023ba0b08d7c89fa9&query=\(movieSearch)&page=\(i)&include_adult=false") {
                            let data = try? Data(contentsOf: url)
                            if(data != nil) {
                                let json = try! JSONDecoder().decode(APIResults.self, from: data!)
                                movieArray += json.results
                                
                                //print(movieCells)
//                                DispatchQueue.main.async {
//                                   movieCells = movieArray
//                                   self.moviesCollectionView.reloadData()
//                                }
                            }
                        }
                    }
                }
//                for movie in movieArray {
//                    if let posterPathUrl = movie.poster_path {
//                        let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathUrl)!)
//                        movieImageDictionary[movie] = UIImage(data: data!)
//                        print(movieImageDictionary[movie])
//                    }
//                }
            //}
            return movieArray
        }
        return []
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCells.count
    }
   /*
     https://www.iosapptemplates.com/blog/swift-programming/uicollectionview-swift-4-tutorial-adding-header-and-footer-to-in-swift
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if(kind == UICollectionView.elementKindSectionHeader) {
           let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            return header
        }
        fatalError()
    }*/
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCellCollectionViewCell
        /*cell.title.text = movieCells![indexPath.item].title
        if let posterPathUrl = movieCells![indexPath.item].poster_path {
            let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathUrl)!)
            cell.poster.image = UIImage(data: data!)
        }*/
        
        cell.setup(index: indexPath.row)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!spinner.isAnimating) {
            performSegue(withIdentifier: "MovieSelected", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if(segue.identifier == "MovieSelected") {
            if let movieVC = segue.destination as? SelectedMovieViewController {
                let movieCell = movieCells![(moviesCollectionView.indexPathsForSelectedItems?.first!.item)!]
                if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieCell.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
                   DispatchQueue.global().async {
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
                    
                   movieVC.movie = movieCells![(self.moviesCollectionView.indexPathsForSelectedItems?.first?.item)!]
                }
                
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if(!spinner.isAnimating) {
            movieCells = []
            moviesCollectionView.reloadData()
        }
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!spinner.isAnimating) {
            movieSearch = searchText
            //print("changed")
        }
       
        
        /*results = grabJSON(movieSearch: movieSearch)
        movieCells = results.results*/
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print(movieSearch!)
        //moviesCollectionView.isScrollEnabled = false
        //searchBar.isHidden = true
        //if(!spinner.isAnimating) {
            movieCells = []
            moviesCollectionView.reloadData()
            if(!spinner.isAnimating) {
                spinner.startAnimating()
                let finalString = movieSearch.convertedToSlug()
                if(finalString != nil) {
                    DispatchQueue.global(qos: .background).async {
                        movieCells = self.grabJSON(movieSearch: finalString!)
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                            self.moviesCollectionView.reloadData()
                            //sleep(4)
                            //self.moviesCollectionView.isScrollEnabled = true
                            //searchBar.isHidden = false
                        }
                        
                       
                    }
                }
            }
        //}
        
        view.endEditing(true)
    }
   
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = moviesCollectionView?.indexPathForItem(at:location) else { return nil }
//        guard let cell = moviesCollectionView.cellForItem(at: indexPath) else { return nil }
//
//        guard let movieVC = storyboard?.instantiateViewController(withIdentifier: "movieVC") as? SelectedMovieViewController else { return nil }
//        movieVC.movie = movieCells[indexPath.row]
//        //Set your Peek height
//        //movieVC.preferredContentSize = CGSize(width: 0.0, height: 400)
//        previewingContext.sourceRect = cell.frame
//        return movieVC
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        show(viewControllerToCommit, sender: self)
//    }
}

