//
//  Stop.swift
//  ProjetDemoMMI
//  Created by Julie Saby on 27/01/2020.

import Foundation

public class StreetMap: Decodable {
    var address: Adress?
    
}

public class Adress : Decodable {
    var village: String?
    var city: String?
    var town: String?
}
