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
//        //https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-bar-button-to-a-navigation-bar
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
        
        self.title = movie.title
        //https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        if let posterPathUrl = movie.poster_path {
            let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/original/" + posterPathUrl)!)
            self.posterImage.image = UIImage(data: data!)
        }
        //https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: movie.release_date!) {
            self.released.text = "Released: \(dateFormatterPrint.string(from: date))"
        } else {
            print("There was an error decoding the string")
        }
        
        self.score.text = "Score: \(Int(movie.vote_average * 10)) / 100"
        self.overview.text = movie.overview
        // Do any additional setup after loading the view.
    }
   /* override func viewDidAppear(_ animated: Bool) {
        if(tabBarController?.selectedIndex == 1) {
            favoriteButton.isHidden = true
        } else {
            favoriteButton.isHidden = false
        }
        
    }*/
    override func viewWillAppear(_ animated: Bool) {
        //https://stackoverflow.com/questions/37988431/swift-check-if-array-contains-element-with-property/37988531
        
        if(trailerURL == nil) {
            navigationItem.rightBarButtonItems![1].isEnabled = false
            navigationItem.rightBarButtonItems![1].tintColor = UIColor.clear
        } else {
            navigationItem.rightBarButtonItems![1].tintColor = view.tintColor
            navigationItem.rightBarButtonItems![1].isEnabled = true
        }
        if(favorites.contains(where: {$0.id == movie.id && $0.poster_path == movie.poster_path && $0.title == movie.title && $0.release_date == movie.release_date && $0.vote_average == movie.vote_average && $0.overview == movie.overview && $0.vote_count == movie.vote_count})) {
           // print("remove")
            favoriteButton.setTitle(" Remove from Favorites ", for: .normal)
        } else {
            //print("add")
            favoriteButton.setTitle(" Add to Favorites ", for: .normal)
        }
        
    }
    
    @IBAction func favorite(_ sender: Any) {
        //addToFavorites(movie: movie)
       // print((favoriteButton.titleLabel!.text)!)
        //print((favoriteButton.titleLabel!.text)! == "Add to Favorites")
        if((favoriteButton.titleLabel!.text)! == " Remove from Favorites " ) {
            //print(favorites)
            favorites.remove(at: favorites.firstIndex(of: movie)!)
            //print(favorites)
            favoriteButton.setTitle(" Add to Favorites ", for: .normal)

        } else if((favoriteButton.titleLabel!.text)! == " Add to Favorites ") {
            favorites.append(movie)
            favoriteButton.setTitle(" Remove from Favorites ", for: .normal)
            //print("remove")
        }
        //https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: favorites!, requiringSecureCoding: false)
            savedFavorites.set(data, forKey: "favorites")
        } catch {}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        //tabBarController?.selectedIndex = 1
    }
    //https://stackoverflow.com/questions/31955140/sharing-image-using-uiactivityviewcontroller
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
        let favorite = UIPreviewAction(title: "Remove from Favorites", style: .destructive, handler: {previewAction, SelectedMovieViewController in self.favorite(_: Any.self)})
        
        if(trailerURL != nil) {
             let trailer = UIPreviewAction(title: "Watch Trailer", style: .default, handler: {previewAction, SelectedMovieViewController in self.watchTrailer(_: Any.self)})
            return [trailer, favorite]
        }
       
        
        return [favorite]
    }
    
    @IBAction func watchTrailer(_ sender: Any) {
        UIApplication.shared.open(trailerURL!, options: [:], completionHandler: nil)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        view.endEditing(true)
//        if(segue.identifier == "Favorited") {
//            if let favoritesVC = segue.destination as? FavoritesViewController {
//                favoritesVC.favoritesTableView.reloadData()
//
//            }
//        }
//    }

}
