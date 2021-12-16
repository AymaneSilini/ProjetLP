//
//  User.swift
//  CityHub
//


import Foundation

public class User {
    private var email: String
    private var firstName : String
    private var lastName : String
    private var password : String
    private var pseudo : String
    private var channel : String
    private var changedChannel : Bool
    private var administrator : Bool
    private var dateCreation : Date
    
    init(){
        email = ""
        firstName = ""
        lastName = ""
        password = ""
        pseudo = ""
        channel = "Général"
        changedChannel = false
        administrator = false
        dateCreation = Date()
        
    }
    
    // get methods
    public func getEmail() -> String {
        return email
    }
    public func getFirstName() -> String {
        return firstName
    }
    public func getLastName() -> String {
        return lastName
    }
    public func getPassword() -> String {
        return password
    }
    public func getPseudo() -> String {
        return pseudo
    }
    public func getChannel() -> String {
        return channel
    }
    public func getChangedChannel() -> Bool {
        return changedChannel
    }
    public func getAdministrator() -> Bool {
        return administrator
    }
    public func getDateCreation() -> Date {
        return dateCreation
    }
    
    
    //  set methods
    public func setEmail(email : String) {
        self.email = email
    }
    public func setFirstName(firstName : String) {
        self.firstName = firstName
    }
    public func setLastName(lastName : String) {
        self.lastName = lastName
    }
    public func setPassword(password : String) {
        self.password = password
    }
    public func setPseudo(pseudo : String) {
        self.pseudo = pseudo
    }
    public func setChannel(channel : String) {
        self.channel = channel
    }
    public func setChangedChannel(changedChannel : Bool) {
        self.changedChannel = changedChannel
    }
    public func setAdministrator(administrator : Bool) {
        self.administrator = administrator
    }
    public func setDateCreation(dateCreation : Date) {
        self.dateCreation = dateCreation
    }
    
}

class UserContext {

    static let shared = UserContext()

    var user: User?

 

    func clearUser() {

        user = User()

    }

}
