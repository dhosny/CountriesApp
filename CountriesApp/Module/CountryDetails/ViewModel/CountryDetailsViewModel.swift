//
//  CountryDetailsViewModel.swift
//  CountriesApp
//
//  Created by MAC on 12/29/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import Foundation

class CountryDetailsViewModel {

    var selectedCountry: Country!
    
    var numberOfCells: Int {
        return selectedCountry.currencies.count
    }
    
    init(country: Country) {
        self.selectedCountry = country
    }
    
    func getCurrency(atIndex: Int) -> String{
        
        if let name = selectedCountry.currencies[atIndex].name {
            return name
        }
        return ""
    }
}
