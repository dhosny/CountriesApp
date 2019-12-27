//
//  LocalCountriesManager.swift
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import Foundation
import RealmSwift

class LocalCountriesManager{
    
    static var shared = LocalCountriesManager()
    
    private init() {
        
    }
    
    func getCountries() -> [Country] {
        // Get the default Realm
        let realm = try! Realm()
        let country = realm.objects(Country.self)
        return Array(country)
    }
    
    func saveCountries(countries: [Country]) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(countries)
        }
    }
    func addCountry (country: Country){
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(Object())
        }
    }
    
}
