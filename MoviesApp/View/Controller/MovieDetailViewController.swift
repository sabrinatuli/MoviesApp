//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Sabrina Tuli on 4/7/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    var img : UIImage!
    var movieTitleText: String = " "
    var movieRatingText: String = " "
    var movieReleaseText: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieImageView.image = img
        movieLabel.text = movieTitleText
        ratingLabel.text = movieRatingText
        releaseDateLabel.text = movieReleaseText

        // Do any additional setup after loading the view.
    }
    


}
