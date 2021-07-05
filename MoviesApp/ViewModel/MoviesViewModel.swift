//
//  AirportManager.swift
//  AirportApp
//
//  Created by Sabrina Tuli on 30/6/21.
//

import Foundation
import Network

class MoviesViewModel: NSObject {
 
/****References**/
//private(set) modifier example taken from StackOverflow https://stackoverflow.com/questions/37264824/how-does-public-privateset-access-modifiers-work
//JSON serialiazation https://developer.apple.com/swift/blog/?id=37
    
    private(set) var movData : [Movies]! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    var internetAvailble = false
    
    
    override init() {
        super.init()
        apiTogetMoviesData()
        
    }
    
    /****  Fetch Json Data for Movies**/
    func apiTogetMoviesData() {
        
        
        /****  Network Checking **/
        let internetmonitor = NWPathMonitor()
        internetmonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet Connection available!")
                
                /****  fetch local json data **/
                // At first I fetched data from saved JSON file from dropbox, later realized it might be required to fetch data from server if data changes during refresh
                
                /*
                
                do {
                    if let bundlePath = Bundle.main.path(forResource: "movies",
                                                             ofType: "json"),
                            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
                    {
                        print("enter")
                        print(jsonData)
                        do {
                            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                            
                            
                            
                            if let movieData = jsonResult!["movies"] as? [[String:Any]]
                            {
                                var dataArray : [Movies] = []
                                            for category in movieData {
                                                let mov = Movies(title:category["title"] as? String, imageHref: category["imageHref"] as? String, rating: category["rating"] as? Double, releaseDate: category["releaseDate"] as? String)
                                                
                                                dataArray.append(mov)
                                            }
                                self.movData = dataArray
                                        }
                           // print(self.movData!)
                                //let decodedData = try JSONDecoder().decode(Movies.self,
                                  //                                         from: movieData)
                                
                                
                                //print("Title: ", decodedData.title)
                                
                            } catch let fileErr{
                                print("decode error",fileErr)
                            }
                    }
                    
                } catch {
                    print("enter error")
                        print(error)
                    }

                 */
                
                /****  fetch JSON data from server **/
               // let sourcesURL = URL(string: "https://www.dropbox.com/s/q1ins5dsldsojzt/movies.json?dl=1")
                /* Dropbox JSON API data needed to be fixed, some image URL without https, issue with security pupose, can't fetch image, that is why created new API*/
                
                let sourcesURL = URL(string: "https://mocki.io/v1/393ab11e-d0ed-4c22-8244-cfaabc186bed")
                self.movData = []
                guard let url = sourcesURL else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else { return }
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    
                    
                    
                    if let movieData = jsonResult!["movies"] as? [[String:Any]]
                    {
                        var dataArray : [Movies] = []
                                    for category in movieData {
                                        let mov = Movies(title:category["title"] as? String, imageHref: category["imageHref"] as? String, rating: category["rating"] as? Double, releaseDate: category["releaseDate"] as? String)
                                        
                                        dataArray.append(mov)
                                    }
                        self.movData = dataArray
                        print(self.movData!)
                                }
                    print(" Movie API values fetched Successfully")
                    }.resume()
                
                
            } else {
                print("No  internet connection.")
                self.internetAvailble = false
            }

            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        internetmonitor.start(queue: queue)
        
}
    
    
    
   
    
}
