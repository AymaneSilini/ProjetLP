//
//  API.swift
//  ProjetDemoMMI
//

import Foundation

class APILocation {
    
    public func getLocalisation(latitude : Double, longitude : Double, completion: @escaping (StreetMap?) -> Void) {
        
        /// Ne fonctionne pas à régler, probleme URL qui n'arrive pas à obtenir les valeurs
        let val1: String = String(latitude)
        let val2: String = String(longitude)
        
        let textURL = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat="+val1+"&lon="+val2+""
        
        let url = URL(string: textURL)
                
        let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if let dataResult = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let stopsResult = try jsonDecoder.decode(StreetMap.self, from: dataResult)
                        completion(stopsResult)
                        
                    }
                    catch {
                        print("Error")
                    }
                }
                else {
                    print("No result")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        session.resume()
        
    }
    
    
}



//45,18541716   -   5,72996383 //Chavant
//45,19193413   -   5,72666532 //Jardin de ville
//45,19130205   -   5,71517336 //Gare grenoble
//45,14217067   -   5,74115298 //La casa
//45,156515564425455, 5,722696094553002
