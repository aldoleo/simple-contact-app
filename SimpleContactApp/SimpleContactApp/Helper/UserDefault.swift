//
//  UserDefault.swift
//  SimpleContactApp
//
//  Created by Aldo Leonardo on 09/05/20.
//  Copyright © 2020 Aldo Leonardo. All rights reserved.
//

import Foundation

public func saveUserDefault( _ id: String, _ photoString: String) {
    var newEntry : [String: String]
    if let database = UserDefaults.standard.dictionary(forKey: "photoUserDefault") as? [String:String] {
        newEntry = database
    } else {
        newEntry = [:]
    }
    newEntry[id] = photoString
    
    UserDefaults.standard.set(newEntry, forKey: "photoUserDefault")
}

public func updateUserDefault( _ id: String, _ photoString: String) {
    let defaults = UserDefaults.standard
    var result = defaults.dictionary(forKey: "Database") as? [String:String]
    result?[id] = photoString
    defaults.set(result, forKey: "Database")
}
