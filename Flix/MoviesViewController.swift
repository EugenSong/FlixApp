//
//  ViewController.swift
//  Flix
//
//  Created by Eugene Song on 9/13/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
   
    
    // variables created here are called Properties (available for lifetime of screen)
    var movies = [[String: Any]]() // how to declare an array of dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                 
                 // "as!" keyword casts
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 
                 // need to reload data to tell tableview to keep update once loads
                 self.tableView.reloadData()
                 print(dataDictionary)
             }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // recycle cells and cast MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        
        let synopsis = movie["overview"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af.setImage(withURL: posterURL!)
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        return cell
    }


}

