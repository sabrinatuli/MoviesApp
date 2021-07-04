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
    /*
     func apiToGetEmployeeData(completion : @escaping (Employees) -> ()){
         URLSession.shared.dataTask(with: sourcesURL) { data, urlResponse, error in
             if let data = data {
                 let jsonDecoder = JSONDecoder()
                 let empData = try! jsonDecoder.decode(Employees.self, from: data)
                 print(empData)
                 completion(empData)
             }
         }.resume()
     }
     */
    var internetAvailble = false
    let sourcesURL = URL(string: "https://mocki.io/v1/91fba448-7ed6-4121-8f1a-a50de82d820f")
    
    
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

                        
                /****  fetch image from imageURL asynchronously **/
                /*
                guard let url = self.sourcesURL else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else { return }
                    let trans = try! JSONDecoder().decode([Airport].self, from: data)
                    DispatchQueue.main.async {
                        self.internetAvailble = true
                        //self.trans = trans
                       // print(trans)
                    }
                    print(" Transport API values fetched Successfully")
                    }.resume()
                */
                
            } else {
                print("No  internet connection.")
                self.internetAvailble = false
            }

            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        internetmonitor.start(queue: queue)
        
}
    
    
    
    ///////// Read from CSV file ///////////////
  
    func getAirportDatafromCSV(filename: String)->[Airport]
{
    var dataArray : [Airport] = []
    if  let path = Bundle.main.path(forResource: filename, ofType: "csv")
          {
            
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let dataEncoded = String(data: data, encoding: .utf8)
               if let rows = dataEncoded?.components(separatedBy: "\r\n")
               {
                        for row in rows {
                            let columns = row.components(separatedBy: "\t")
                            if columns != [""] {
                                //print(columns[0])
                                let airP = Airport(airportCode: columns[0], timezone: columns[1], city: columns[2], state: columns[3], airportName: columns[4])
                                
                                dataArray.append(airP)
                            }
                            
                        }
        
                
               }
            }
                 
                
            catch let fileErr {
                print("\n Error read CSV file: \n ", fileErr)
            }
           
        
            }
    if dataArray.isEmpty  {
        dataArray = [Airport(airportCode: "No Data", timezone: "No Data", city: "No Data", state: "No Data", airportName: "No Data")]
    }
    
    return dataArray
    
}
   
    ///////// Sort  by AirportName ///////////////
    func SortedAirportName(airName:[Airport])->[Airport]
    {
        //let sortedName = (airTzone as NSArray).sortedArray(using: [NSSortDescriptor(key: $0.name , ascending: true)]) as! [Airport]
        let sortedName = airName.sorted(by: { $0.airportName < $1.airportName })
       return sortedName
        
    }
    
    
///////// Sort and broup by Timezone ///////////////
    func SortedAirportTimezone(airTzone:[Airport])->[GroupedAirPort]
    {
        let sortedTzone = airTzone.sorted(by: { $0.timezone < $1.timezone })
        let groupByCategory = Dictionary(grouping: sortedTzone) { $0.timezone }
        
       // print(groupByCategory["America/Los_Angeles"]!)
        
        
        //print(groupByCategory)
        var valarr = [GroupedAirPort]()
        
         
        for k in groupByCategory.values
        {
            print(k.count)
            
            let airportDict = GroupedAirPort(sortedzone: k[0].timezone, data: k)
            valarr.append(airportDict)
            
            
        }
        
         
        return valarr
    }
 
    
}
