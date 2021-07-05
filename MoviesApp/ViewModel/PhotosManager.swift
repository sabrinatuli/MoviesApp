//
//  PhotosManager.swift
//  MoviesApp
//
//  Taken from Tod Kramer https://www.tekramer.com/downloading-caching-and-decoding-images-asynchronously-with-alamofire-part-1-swift-4
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UInt64 {

    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }

}

class PhotosManager {
    
    var images = [UIImage]()

    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )

    //MARK: - Image Downloading

    func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> Request {
        return Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            completion(image)
            self.cache(image, for: url)
        }
    }

    //MARK: - Image Caching

    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }

    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }

}
