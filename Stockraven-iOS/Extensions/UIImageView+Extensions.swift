//
//  UIImageView+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response ,error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
