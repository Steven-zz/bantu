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
//        DispatchQueue.main.async {
//            let data = try? Data(contentsOf: url!)
//            if let imageData = data, let image = UIImage(data: imageData) {
//                onComplete(image)
//            } else {
//                // return deffault image
//                onComplete(UIImage(named: "broken-image")!)
//            }
//        }
        print("Download start")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
//            DispatchQueue.main.async() {
//                self.imageView.image = UIImage(data: data)
//            }
            onComplete(UIImage(data: data)!)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
