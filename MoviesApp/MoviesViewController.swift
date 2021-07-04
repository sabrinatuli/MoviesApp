//
//  ViewController.swift
//  MoviesApp
//
//  Created by Tamzid Hasan on 2/7/21.
//

import UIKit


class MoviesViewController: UICollectionViewController {
    
    
    private var moviesVM : MoviesViewModel!
    private var movies : [Movies] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
        
        // Do any additional setup after loading the view.
    }

    func callToViewModelForUIUpdate(){
        
        self.moviesVM =  MoviesViewModel()
        self.moviesVM.bindMoviesViewModelToController = {
            self.movies = self.moviesVM.movData
            print("hello view model")
            print(self.movies.count)
            
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
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
                // we failed to get a PersonCell – bail out!
                fatalError("Unable to dequeue PersonCell.")
            }
        cell.moviesLabel.text = self.movies[indexPath.row].title
        //cell.movieImgView.image = nil

        
        return cell
    }
    
    
}

