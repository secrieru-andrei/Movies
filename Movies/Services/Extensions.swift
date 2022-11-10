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
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                guard let imageLoaded = UIImage(data: imageData) else {return}
                        self?.image = imageLoaded
            }
        }
    }
}
