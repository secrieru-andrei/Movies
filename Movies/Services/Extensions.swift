//
//  Extensions.swift
//  Movies
//
//  Created by Secrieru Andrei on 11.11.2022.
//

//
//  Extensions.swift
//  CarApp-MVVM
//
//  Created by Secrieru Andrei on 11.11.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(url: String) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w300" + url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }.resume()
    }
}


