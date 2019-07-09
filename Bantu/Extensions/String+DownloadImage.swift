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
    func getImageFromString(onComplete: @escaping (UIImage) -> Void) {
        let url = URL(string: self)!

        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                onComplete(UIImage(named: "broken-image")!)
                return
            }

            onComplete(UIImage(data: data)!)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
