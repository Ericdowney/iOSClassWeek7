//
//  ViewController.swift
//  POPTest
//
//  Created by Downey, Eric on 12/18/16.
//  Copyright © 2016 ICC. All rights reserved.
//

import UIKit

struct Movie {
    var title: String?
    var year: String?
    var posterUrl: String?
    
    init?(json: [String: Any]?) {
        title = json?["Title"] as? String
        year = json?["Year"] as? String
        posterUrl = json?["Poster"] as? String
        
        if !(title != nil && year != nil && posterUrl != nil) {
            return nil
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var movieTableView: UITableView?
    
    var movies: [Movie] = [] {
        didSet {
            movieTableView?.reloadData()
        }
    }
    
    lazy var service: NetworkService & Jsonify = {
        DataService()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.requestJSON(from: "http://www.omdbapi.com/?r=json&s=Christmas", withCompletion: completeRequest)
    }

    private func completeRequest(json: [String: Any]?, _: URLResponse?, error: Error?) {
        let searchResults = json?["Search"] as? [[String: Any]]
        
        let mappedResults = searchResults?.flatMap({ jsonData in
            Movie(json: jsonData)
        })
        
        if let results = mappedResults {
            movies = results
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row].title
        cell.detailTextLabel?.text = movies[indexPath.row].year
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
    }
}

