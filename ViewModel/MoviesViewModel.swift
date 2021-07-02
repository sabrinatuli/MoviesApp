//
//  AirportManager.swift
//  AirportApp
//
//  Created by Sabrina Tuli on 30/6/21.
//

import Foundation

class MoviesViewModel: NSObject {
    
//private(set) modifier example taken from StackOverflow https://stackoverflow.com/questions/37264824/how-does-public-privateset-access-modifiers-work
    
    private(set) var movData : Movies! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    var bindMoviesViewModelToController : (() -> ()) = {}
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
