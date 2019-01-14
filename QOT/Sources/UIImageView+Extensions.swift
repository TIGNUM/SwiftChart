//
//  UIImageView+Extensions.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 07.01.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImage(from url: URL?, placeholder: UIImage?) {
        image = placeholder
        guard let imageURL = url else {
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageURL) else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
