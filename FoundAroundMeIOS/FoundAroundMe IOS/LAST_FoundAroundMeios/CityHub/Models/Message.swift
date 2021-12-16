//
//  Message.swift
//  CityHub
//

import Foundation
import Firebase

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct MessageHub {
    var email:String
    var pseudo:String
    var content:String
    var timeStamp:Date
    
    var dictionnary:[String:Any]{
        return [
            "email": email,
            "pseudo": pseudo,
            "content": content,
            "timeStamp": timeStamp
        
        ]
    }
    
}

extension MessageHub : DocumentSerializable{
    init?(dictionary: [String : Any]){
        guard let email = dictionary["email"] as? String,
              let pseudo = dictionary["pseudo"] as? String,
              let content = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? Date else { return nil}
        
        self.init(email: email, pseudo: pseudo, content: content, timeStamp: timeStamp)
    }
}
