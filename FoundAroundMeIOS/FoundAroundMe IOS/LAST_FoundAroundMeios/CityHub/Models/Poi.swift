//
//  Poi.swift
//  CityHub
//
//  Created by Aymane Silini on 09/12/2021.
//

import Foundation
import MapKit
import UIKit
struct Location {
    //ecole
    static let IUT = Poi(title: "IUT1 Grenoble", coordinate: CLLocationCoordinate2D(latitude: 45.19256454674277, longitude: 5.718099101658471), info: "IUT du Quai Claude Bernard",type: .ecole)
    
    //transport
    static let AgenceTAG = Poi(title: "Agence TAG", coordinate: CLLocationCoordinate2D(latitude: 45.189774680633626, longitude: 5.717440969828485), info: "Adresse : 49 Av. Alsace Lorraine\n"+"38000 Grenoble\n"+"Site web : tag.fr\n"+"Numéro : 04 38 70 38 70",type: .transport)
    static let GareGrenoble = Poi(title: "Gare de Grenoble", coordinate: CLLocationCoordinate2D(latitude: 45.19126536707446, longitude: 5.713803180430677), info: "Ici c'est la gare, il y a des TER, des TGV et des bus",type: .transport)
    
    //cinema
    static let CinemaLeClub = Poi(title: "Cinema Le Club", coordinate: CLLocationCoordinate2D(latitude: 45.187443031003085, longitude: 5.72244525330854), info: "Adresse : Rue du Phalanstère 9 B\n"+"38000 Grenoble\n"+"Horaires : 9h-23h\n"+"Site Web : cinemaleclub.com ",type: .cinema)
    static let CinemaLeMelias = Poi(title: "Cinema le Melias", coordinate: CLLocationCoordinate2D(latitude: 45.183202511600086, longitude: 5.72451145050677), info: "Adresse : 28 All. Henri Frenay\n"+"38000 Grenoble\n"+"Horaires : 9h-23h\n"+"Site Web : cinemalemelies.org\n"+"Numéro : 04 76 47 99 31",type: .cinema)
    static let Cinema6Rex = Poi(title: "6 Rex", coordinate: CLLocationCoordinate2D(latitude: 9.446970, longitude: -84.140092), info: "Adresse : 13 Rue Saint-Jacques\n"+"38000 Grenoble\n"+"Horaires : 9h-23h\n"+"Numéro : 04 76 44 06 82",type: .cinema)
    static let CinemaPatheGrenoble = Poi(title: "Cinema Pathe Grenoble", coordinate: CLLocationCoordinate2D(latitude: 45.18642236899143, longitude: 5.7321342606518835), info: "Point culminant",type: .cinema)
    
    //restauration
    static let mcdoJJ = Poi(title: "McDonald's Jean Jaures", coordinate: CLLocationCoordinate2D(latitude: 45.18313177984532, longitude: 5.717741136429285), info: "Adresse : 99 Cr Jean Jaurès\n"+"38000 Grenoble\n"+"Horaires : 10h-2h\n"+"Numéro : 04 80 42 03 10", type: .restauration)
    static let mcdoGare = Poi(title: "McDonald's Gare ", coordinate: CLLocationCoordinate2D(latitude: 45.19116354700353, longitude: 5.714737151245464), info: "Adresse : 1 Pl. de la Gare\n"+"38000 Grenoble\n"+"Horaires : 10h–23h\n"+"Numéro : 04 76 94 90 69", type: .restauration)
    static let burgerKing = Poi(title: "Burger King ", coordinate: CLLocationCoordinate2D(latitude: 45.18970345524476, longitude: 5.724462837271327), info: "Adresse : 2 Pl. Victor Hugo\n"+"38000 Grenoble\n"+"Horaires : 11h–23h\n"+"Numéro : 04 80 61 00 70", type: .restauration)
    
}

class Poi: NSObject, MKAnnotation {
    enum PoiType : String {
        case cinema = "Cinema"
        case restauration = "Restauration"
        case transport = "Transport"
        case ecole = "Ecole"
    }
    
    let poiType : PoiType
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, type: PoiType) {
        poiType = type
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    

}
