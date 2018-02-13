//
//  Extensions.swift
//  BigCityWeather
//
//  Created by Jason Park on 2/13/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
            
            
        }
        task.resume()
    }
    
}
