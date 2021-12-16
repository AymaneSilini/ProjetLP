//
//  localFunction.swift
//  CityHub
//
//  INSERER ICI LES FONCTIONS EN RAPPORT AVEC LA BDD

import Foundation
import FirebaseFirestore

import UIKit
import Foundation
import CommonCrypto

class APIbdd {
    
    
    
    /// Fonctions testés
    //  Create user
    public func addUser(users:[String : Any]){
        //  Exemple : let tab = ["name" : test, "age":test2] as [String : Any]
        Firestore.firestore().collection("users").addDocument(data: users)
    }
    
    public func addMessage(message:[String : Any], collection:String){
        //  Exemple : let tab = ["name" : test, "age":test2] as [String : Any]
        Firestore.firestore().collection(collection).addDocument(data: message)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    public func verifMessage(){
        
        let ref = Firestore.firestore()
        ref.collection("messages").whereField("email", isEqualTo: "bb@bb.bb").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshots \(error!)")
                return
            }
            print("Current users born before 1900: \(snapshot.documents.map { $0.data() })")
        }
    }
    */
    
    
    
    
    
    /*
    public func emailExist(mail:String)->Bool{
        
        let ref = Firestore.firestore()
        var isExist = false
        /*
        
        ref.collection("user").whereField("email", isEqualTo: mail).getDocuments() { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                print("CETTE ELEMENT EXISTE PTDR FDP DE MERDE")
            }
        }
        
        print("Le i final est : et donc voilà")*/
        
        return isExist
        
        
        
    }
    
    
    
    
    /// Fonctions non testés
    public func miseAjourUser(id:String, champ:String,val:String){
        Firestore.firestore().collection("users").document(id).updateData([
            champ: val,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    

    public func SupprUser(id:String){
        Firestore.firestore().collection("users").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    
    
    public func GetId(mail:String)->String{
        let ref = Firestore.firestore()
        let name = "error"
        ref.collection("users").whereField("emailUser", isEqualTo: mail).getDocuments{(document,error) in
            if error != nil {
                print(error)
            } else {
                print("test hahaha "/*+error*/)
                for document in (document?.documents)!{
                    print("test hahaha "+document.documentID)
                }
            }
        }
        
        print(name+"hahahahahahaha");
        return name;
    }

    public func supprUserChamp(id:String, nameChamp:String){
        Firestore.firestore().collection("users").document(id).updateData([
            nameChamp: FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
         
      */
    
}
