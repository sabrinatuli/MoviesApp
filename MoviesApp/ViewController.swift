//
//  ViewController.swift
//  MoviesApp
//
//  Created by Tamzid Hasan on 2/7/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var moviesVM : MoviesViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func callToViewModelForUIUpdate(){
        
        self.moviesVM =  MoviesViewModel()
        self.moviesVM.bindMoviesViewModelToController = {
            print("found data")
        }
    }
    
}

