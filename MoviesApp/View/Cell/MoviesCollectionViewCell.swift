//
//  MoviesCollectionViewCell.swift
//  MoviesApp
//
//  Created by Sabrina Tuli on 4/7/21.
//

import UIKit
import  Alamofire

class MoviesCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var movieImgView: UIImageView!
    
    @IBOutlet weak var moviesLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    weak var photosManager: PhotosManager!
    var movie : Movies?
    var request: Request?
    
    //configure cell with loaded image
    func configure(with movie: Movies, photosManager: PhotosManager) {
        self.photosManager = photosManager
        self.movie = movie
        if let urlvalue = self.movie?.imageHref
        {
            loadImage(with: urlvalue)
        }
        else
        {
            
            loadingIndicator.stopAnimating()
            self.movieImgView.image = UIImage(named: "no-image-icon-23485")
            
        }
        
    }

    //check if image available in cache or download
    func loadImage(with url: String) {
        if let image = photosManager?.cachedImage(for: url) {
            populate(with: image)
            return
        }
        downloadImage(with: url)
    }

    func downloadImage(with url: String) {
        request = photosManager?.retrieveImage(for: url) { image in
            self.populate(with: image)
        }
    }

    func populate(with image: UIImage) {
        loadingIndicator.stopAnimating()
        self.movieImgView.image = image
        
        
    }
}


