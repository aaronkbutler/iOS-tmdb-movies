//
//  SelectedMovieViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

class SelectedMovieViewController: UIViewController {
    
    var movie: Movie!
    var trailerURL: URL?
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trailerButton: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(shareMovie))
//        navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "share"), for: .normal, barMetrics: .default)
        
//        if(trailerURL != nil) {
//            let trailerButton = navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Trailer", style: .plain, target: self, action: #selector(self.shareMovie(_:))) as? UIBarButtonItem
//            navigationItem.rightBarButtonItems?.append(trailerButton)
//        }
        
        //https://stackoverflow.com/questions/26961274/how-can-i-make-a-button-have-a-rounded-border-in-swift
        favoriteButton.backgroundColor = .clear
        favoriteButton.layer.cornerRadius = 5
        favoriteButton.layer.borderColor = view.tintColor.cgColor
        favoriteButton.layer.borderWidth = 1.0
        
        released.backgroundColor = .clear
        released.layer.cornerRadius = 5
        released.layer.borderColor = UIColor.white.cgColor
        released.layer.borderWidth = 1.0
        
        score.backgroundColor = .clear
        score.layer.cornerRadius = 5
        score.layer.borderColor = UIColor.white.cgColor
        score.layer.borderWidth = 1.0
        
        
        self.title = movie.title
        //https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        
        //https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yy"
        
        if let date = dateFormatterGet.date(from: movie.release_date!) {
            self.released.text = "Released: \(dateFormatterPrint.string(from: date))"
        } else {
            self.released.text = "Released: N/A"
        }
        
        self.score.text = "Score: \(Int(movie.vote_average * 10)) / 100"
        self.overview.text = movie.overview
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.favoriteButton.isEnabled = true
                    }
                    if let json = try? JSONDecoder().decode(VideoResults.self, from: data) {
                        var movieArray = json.results
                        if(movieArray.count == 1) {
                            if(movieArray[0].site == "YouTube") {
                                DispatchQueue.main.async {
                                     self.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(movieArray[0].key ?? "")")
                                    if(self.trailerURL == nil) {
                                        self.navigationItem.rightBarButtonItems![2].isEnabled = false
                                        self.navigationItem.rightBarButtonItems![2].tintColor = UIColor.clear
                                    } else {
                                        self.navigationItem.rightBarButtonItems![2].tintColor = self.view.tintColor
                                        self.navigationItem.rightBarButtonItems![2].isEnabled = true
                                    }
                                }
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
                            
                            DispatchQueue.main.async {
                                self.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                                if(self.trailerURL == nil) {
                                    self.navigationItem.rightBarButtonItems![2].isEnabled = false
                                    self.navigationItem.rightBarButtonItems![2].tintColor = UIColor.clear
                                } else {
                                    self.navigationItem.rightBarButtonItems![2].tintColor = self.view.tintColor
                                    self.navigationItem.rightBarButtonItems![2].isEnabled = true
                                }
                            }
                        }
                        //                        self.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                    } else {
                        //print(self.trailerURL)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.favoriteButton.isEnabled = false
//                        let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
//
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                        self.present(alert, animated: true)
                    }
                }
                
            }
        }
        movie.trailer = trailerURL
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItems![2].isEnabled = false
        navigationItem.rightBarButtonItems![2].tintColor = UIColor.clear
        navigationItem.rightBarButtonItems![1].isEnabled = false
        navigationItem.rightBarButtonItems![1].tintColor = UIColor.clear
        //print(trailerURL)
       //print(trailerURL)
        if let posterPathUrl = movie.poster_path {
            if let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/original/" + posterPathUrl)!) {
                self.posterImage.image = UIImage(data: data)
                navigationItem.rightBarButtonItems![1].isEnabled = true
                navigationItem.rightBarButtonItems![1].tintColor = self.view.tintColor
            } else {
                navigationItem.rightBarButtonItems![1].isEnabled = false
                navigationItem.rightBarButtonItems![1].tintColor = UIColor.clear
//                let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                self.present(alert, animated: true)
            }

        }
        
        //https://stackoverflow.com/questions/37988431/swift-check-if-array-contains-element-with-property/37988531
        if(favorites.contains(where: {$0.id == movie.id})) {
           // print("remove")
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            //print("add")
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
        
    }
    
    @IBAction func favorite(_ sender: Any) {
        //addToFavorites(movie: movie)
       // print((favoriteButton.titleLabel!.text)!)
        //print((favoriteButton.titleLabel!.text)! == "Add to Favorites")
        if((favoriteButton.titleLabel!.text)! == "Remove from Favorites" ) {
            //print(favorites)
            var index = 0
            for n in 0..<favorites.count {
                if(favorites[n].id == movie.id) {
                    index = n
                    break
                }
            }
            favoritesImageCache.remove(at: index);
            favorites.remove(at: index)
            //print(favorites)
            favoriteButton.setTitle("Add to Favorites", for: .normal)

        } else if((favoriteButton.titleLabel!.text)! == "Add to Favorites") {
            if(movie.poster_path != nil) {
                let url = URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + movie.poster_path!)
                if let data = try? Data(contentsOf: url!) {
                    favorites.append(movie)
                    let image = UIImage(data:data)
                    favoritesImageCache.append(image!)
                    favoriteButton.setTitle("Remove from Favorites", for: .normal)
                } else {
                    let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                
            } else {
                favorites.append(movie)
                favoritesImageCache.append(UIImage())
                favoriteButton.setTitle("Remove from Favorites", for: .normal)
            }
            
            let movieCell = favorites.last!
            if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieCell.id ?? 0 )/videos?api_key=487eecc5c6b322b023ba0b08d7c89fa9&language=en-US") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        let json = try! JSONDecoder().decode(VideoResults.self, from: data)
                        var movieArray = json.results
                        if(movieArray.count == 1) {
                            if(movieArray[0].site == "YouTube") {
                                favorites.last?.trailer = URL(string: "https://www.youtube.com/watch?v=\(movieArray[0].key ?? "")")
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
                            //movieVC.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                            //}
                            favorites.last?.trailer = URL(string: "https://www.youtube.com/watch?v=\(key)")
                        }
                    } else {
                        let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                    
                }
            }

            //favorites.last.trailer
            
            //print("remove")
        }
        //https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: favorites!, requiringSecureCoding: false)
            savedFavorites.set(data, forKey: "favorites")
        } catch {}
        
        do {
            let data2 = try NSKeyedArchiver.archivedData(withRootObject: favoritesImageCache!, requiringSecureCoding: false)
            savedFavorites.set(data2, forKey: "favoritesImageCache")
        } catch {}
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
        //tabBarController?.selectedIndex = 1
    }
    
    @IBAction func shareMovie(_ sender: Any) {
        let shareString = "https://www.themoviedb.org/movie/\(movie.id!)"
        //print(shareString)
        let activity = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
//    @objc func shareMovie() {
//        //print("share")
////        var image: UIImage?
////        let urlString = "https://image.tmdb.org/t/p/original\(movie.poster_path ?? "error")"
////
////        let url = NSURL(string: urlString)! as URL
////        if let imageData: NSData = NSData(contentsOf: url) {
////            image = UIImage(data: imageData as Data)
////        }
//        //let shareImage = UIImage(contentsOfFile: "https://image.tmdb.org/t/p/original/\(String(describing: movie.poster_path))")
////        let shareString = "https://www.themoviedb.org/movie/\(movie.id!)"
////        //print(shareString)
////        let activity = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
////        present(activity, animated: false, completion: nil)
//    }
    //https://www.techotopia.com/index.php/An_iOS_9_3D_Touch_Peek_and_Pop_Tutorial
    override var previewActionItems: [UIPreviewActionItem] {
        var favorite = UIPreviewAction(title: "Add to Favorites", style: .default, handler: {previewAction, SelectedMovieViewController in self.favorite(_: Any.self)})
        if(favorites.contains(where: {$0.id == movie.id})) {
            favorite = UIPreviewAction(title: "Remove from Favorites", style: .destructive, handler: {previewAction, SelectedMovieViewController in self.favorite(_: Any.self)})
        }
        
        if(trailerURL != nil) {
             let trailer = UIPreviewAction(title: "Watch Trailer", style: .default, handler: {previewAction, SelectedMovieViewController in self.watchTrailer(_: Any.self)})
            return [trailer, favorite]
        }
       
        
        return [favorite]
    }
    
    @IBAction func watchTrailer(_ sender: Any) {
        UIApplication.shared.open(trailerURL!, options: [:], completionHandler: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AR") {
            if let ARVC = segue.destination as? ARViewController {
                ARVC.image = posterImage.image!

            }
        }
   }

}
