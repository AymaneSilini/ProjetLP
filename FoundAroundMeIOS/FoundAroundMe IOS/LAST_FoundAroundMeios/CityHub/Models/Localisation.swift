//
//  User.swift
//  CityHub
//

import Foundation

public class Localisation {
    private var country: String
    private var city : String
    private var locality : String
    init(){
        country = ""
        city = ""
        locality = ""
        
    }
    
    // get methods
    public func getCountry() -> String {
        return country
    }
    public func getCity() -> String {
        return city
    }
    public func getLocality() -> String {
        return locality
    }
    
    
    //  set methods
    public func setCountry(country : String) {
        self.country = country
    }
    public func setCity(city : String) {
        self.city = city
    }
    public func setLocality(locality : String) {
        self.locality = locality
    }
    
}

class LocalisationContext {

    static let shared = LocalisationContext()

    var localisation: Localisation?

 

    func clearUser() {

        localisation = Localisation()

    }
}
