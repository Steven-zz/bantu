//
//  String+DownloadImage.swift
//  Bantu
//
//  Created by Cason Kang on 07/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow

extension String {
    func getImageFromString() -> ImageSource {
        let url = URL(string: self)
        let data = try? Data(contentsOf: url!)
        if let imageData = data, let image = UIImage(data: imageData) {
            return ImageSource(image: image)
        } else {
            // return deffault image
            return ImageSource(image: UIImage(named: "broken-image")!)
        }
    }
}
