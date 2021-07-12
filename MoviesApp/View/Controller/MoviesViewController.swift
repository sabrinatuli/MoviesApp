//
//  ViewController.swift
//  MoviesApp
//
//  Created by Sabrina Tuli on 2/7/21.
//

import UIKit



class MoviesViewController: UICollectionViewController {
    
    
    private var moviesVM : MoviesViewModel!
    private var movies : [Movies] = []
    private let refreshControl = UIRefreshControl()
     

    var photosManager = PhotosManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //create refrewh control, code taken from 
        self.collectionView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.systemYellow
        refreshControl.addTarget(self, action: #selector(refreshMovieData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Collection View", attributes: nil)
        
        //update UI when Movie has data from viewmodel
        callToViewModelForUIUpdate()
        
        
    }
    @objc private func refreshMovieData(_ sender: Any) {
        
        // add new movie data
        self.movies.append(Movies(title:"X-Men", imageHref: "https://flxt.tmsimg.com/assets/p25028_p_v10_aa.jpg", rating: 7.4, releaseDate: "13 July 2000"))
        self.movies.append(Movies(title:"X-Men: Dark Phoenix", imageHref: "https://thumbor.forbes.com/thumbor/711x1125/https://blogs-images.forbes.com/scottmendelson/files/2019/02/New-X-Men-Poster-Dark-Phoenix_1200_1900_81_s-1200x1900.jpg?width=960", rating: 5.7, releaseDate: "5 June 2019"))
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()

        
        
        
    }
    

    func callToViewModelForUIUpdate(){
        
        self.moviesVM =  MoviesViewModel()
        self.moviesVM.bindMoviesViewModelToController = {
            self.movies = self.moviesVM.movData
            print(self.movies.count)
            
            //Loading UI in main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
               
            }
          
            
            
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MoviesCollectionViewCell else {
                fatalError("Unable to dequeue PersonCell.")
            }
        //load image with photomanager
         cell.configure(with: self.movies[indexPath.row], photosManager: self.photosManager)
        
        
        
        cell.moviesLabel.text = self.movies[indexPath.row].title
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let url = self.movies[indexPath.row].imageHref ?? " "
        
        //check if image exist inside cached image
        if let cachedImage = self.photosManager.imageCache.image(withIdentifier: url) {
            
            print("cache exist")
            vc.img = cachedImage
            vc.movieTitleText = self.movies[indexPath.row].title ?? " "
            vc.movieReleaseText = self.movies[indexPath.row].releaseDate ?? " "
            if let rating = self.movies[indexPath.row].rating
            {
            vc.movieRatingText = String(format: "%.1f", rating)
            }
            else
            {
                vc.movieRatingText = " "
            }
            self.navigationController?.pushViewController(vc, animated: true)
          }
        else
        {
            vc.img = UIImage(named: "no-image-icon-23485")
            vc.movieTitleText = self.movies[indexPath.row].title ?? " "
            vc.movieReleaseText = self.movies[indexPath.row].releaseDate ?? " "
            if let rating = self.movies[indexPath.row].rating
            {
            vc.movieRatingText = String(format: "%.1f", rating)
            }
            else
            {
                vc.movieRatingText = " "
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
            
    }

    
    
}

