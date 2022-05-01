//
//  FavoritesViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/3/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//

import UIKit

let savedFavorites = UserDefaults.standard
var favorites: [Movie]!
var favoritesImageCache: [UIImage]!
class FavoritesViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        //print(favoriteMovieImageDictionary)
        super.viewDidLoad()
        if(favorites.count > 0) {
            clearButton.isEnabled = true
            shareButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
            shareButton.isEnabled = false
        } //https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        favoritesTableView.dataSource = self
        favoritesTableView.rowHeight = 90
        favoritesTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        favoritesTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if(favorites.count > 0) {
            clearButton.isEnabled = true
            shareButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
            shareButton.isEnabled = false
        }
        favoritesTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoritesTableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteMovieTableViewCell
        
        
        if (!favorites.isEmpty){
            cell.setup(index: indexPath.row)
            cell.imageView?.image = favoritesImageCache[indexPath.row]
//            cell.title.text = favorites[indexPath.item].title
//
//            if let posterPathUrl = favorites[indexPath.item].poster_path {
//                let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/" + posterPathUrl)!)
//                cell.poster.image = UIImage(data: data!)
//                //print(newImage.size)
//            }
            
            
            //cell.poster.image = UIImage(named: favorites[indexPath.item].poster_path!)
        }
        return cell
        
    }
    //https://developer.apple.com/documentation/uikit/deprecated_symbols/implementing_peek_and_pop
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                //view.endEditing(true)
        if(segue.identifier == "FavoriteInfo") {
            guard let selectedTableViewCell = sender as? UITableViewCell,
                let indexPath = favoritesTableView.indexPath(for: selectedTableViewCell)
                else { preconditionFailure("Expected sender to be a valid table view cell") }
            
            guard let movieVC = segue.destination as? SelectedMovieViewController
                else { preconditionFailure("Expected a SelectedMovieVIewController") }
            
            //let movieCell = favorites[indexPath.row]
            //movieVC.trailerURL = movieVC.movie.trailer
            movieVC.movie = favorites[indexPath.row]
            //print(favorites[indexPath.row].trailer)
            movieVC.trailerURL = favorites[indexPath.row].trailer
           // print(movieVC.movie.trailer)
        }
    }
    //https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            favorites.remove(at: indexPath.item)
            favoritesImageCache.remove(at: indexPath.item)
            favoritesTableView.reloadData()
            if(favorites.count > 0) {
                clearButton.isEnabled = true
                shareButton.isEnabled = true
            } else {
                clearButton.isEnabled = false
                shareButton.isEnabled = false
            }
            //https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: favorites!, requiringSecureCoding: false)
                savedFavorites.set(data, forKey: "favorites")
                let data2 = try NSKeyedArchiver.archivedData(withRootObject: favoritesImageCache!, requiringSecureCoding: false)
                savedFavorites.set(data2, forKey: "favoritesImageCache")
            } catch {}
        }
    }
    @objc func loadList() {
        if(favorites.count == 0) {
            clearButton.isEnabled = false
            shareButton.isEnabled = false
        }
        self.favoritesTableView.reloadData()
    }

    @IBAction func shareFavoriteList(_ sender: Any) {
        var shareStrings = "My Favorite Movies:\n"
        for movie in favorites {
            shareStrings += movie.title
            if(favorites.last != movie) {
                shareStrings += "\n"
            }
            
        }
        
       // print(shareStrings)
        let activity = UIActivityViewController(activityItems: [shareStrings], applicationActivities: nil)
        present(activity, animated: false, completion: nil)
    }
    @IBAction func clearFavoriteList(_ sender: Any) {
        favorites = []
        favoritesImageCache = []
        favoritesTableView.reloadData()
        clearButton.isEnabled = false
        shareButton.isEnabled = false
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: favorites!, requiringSecureCoding: false)
            savedFavorites.set(data, forKey: "favorites")
            let data2 = try NSKeyedArchiver.archivedData(withRootObject: favoritesImageCache!, requiringSecureCoding: false)
            savedFavorites.set(data2, forKey: "favoritesImageCache")
        } catch {}
    }
}

