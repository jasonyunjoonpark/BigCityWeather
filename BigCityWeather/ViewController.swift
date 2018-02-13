//
//  ViewController.swift
//  BigCityWeather
//
//  Created by Jason Park on 2/12/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var degree: Int!
    var condition: String!
    var imageUrl: String!
    var city: String!
    
    var exists: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let urlString = "https://api.apixu.com/v1/current.json?key=7b02390705714c3c881215427180902&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                
                if let location = json["location"] as? [String : AnyObject] {
                    if let name = location["name"] as? String {
                        self.city = name
                    }
                }
                
                if let current = json["current"] as? [String : AnyObject] {
                    if let temp = current["temp_c"] as? Int {
                        self.degree = temp
                    }
                    if let condition = current["condition"] as? [String : AnyObject] {
                        if let text = condition["text"] as? String {
                            self.condition = text
                        }
                        if let icon = condition["icon"] as? String {
                            self.imageUrl = icon
                        }
                    }
                }
                
                if let error = json["error"] as? [String : AnyObject] {
                    self.exists = false
                }
                
                DispatchQueue.main.async {
                    if self.exists {
                        self.degreeLabel.text = self.degree.description
                        self.cityLabel.text = self.city
                        self.conditionLabel.text = self.condition
                    } else {
                        self.degreeLabel.isHidden = true
                        self.conditionLabel.isHidden = true
                        self.cityLabel.text = "No matching city found"
                        self.exists = true
                    }
                }
    
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

