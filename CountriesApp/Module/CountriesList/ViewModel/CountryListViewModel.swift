//
//  CountryListViewModel.swift
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import Foundation
import CoreLocation

class CountryListViewModel {

    let countryGateway: CountryGateway
    
    private var countriesList: [Country] = [Country]()
    
    private var selectedCountriesList: [Country] = [Country]()
    
    private var filteredCountriesList: [Country] = [Country]()
    
    private var isLocationServicesEnabled: Bool = true
    
    var displayMode: DisplayMode = .selectedCountries {
        didSet {
            self.reloadTableViewClosure?()
            self.updateViewUI?()
        }
    }
    
    private var displayedCountriesList: [Country]{
        switch displayMode {
        case .allCountries:
            return countriesList
        case .selectedCountries:
            return selectedCountriesList
        case .filteredCountries:
            return filteredCountriesList
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return displayedCountriesList.count
    }
    
    var selectedCountry: Country?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var updateViewUI: (()->())?
    
    init( countryGateway: CountryGateway = CountryGateway()) {
        self.countryGateway = countryGateway
    }
    
    func initFetch() {
        state = .loading
        countryGateway.getCountries(){ [weak self] (country, msg, states) in
            guard let self = self else {
                return
            }
            
            guard states == 1 else {
                self.state = .error
                self.alertMessage = msg
                return
            }
            
            self.countriesList = country
            self.initSelectedCountries()
            //self.displayMode = .selectedCountries
           
        }
    }
    
    func initSelectedCountries() {
        if !isLocationServicesEnabled {
            setDefultCountry()
        }
    }
    
    func setDefultCountry(code: String = "EG") {
        if self.countriesList.count == 0 {
            self.state = .loaded
            return
        }
        countryGateway.selectCountryBy(code: code)
        //load Selected Countries
        self.selectedCountriesList = self.countryGateway.getSelectedCountries()
        self.state = .loaded
        self.displayMode = .selectedCountries
    }
    
    func setLocationService( states: Bool){
        isLocationServicesEnabled = states
    }
    
    func getCountry(atIndex : Int) -> Country{
        return self.displayedCountriesList[atIndex]
    }
    
    func unselectCountry(atIndex : Int) {
        countryGateway.unselectCountryBy(code: self.displayedCountriesList[atIndex].alpha2Code)
        self.selectedCountriesList = countryGateway.getSelectedCountries()
        self.displayMode = .selectedCountries
    }
    
    func selectCountry(atIndex : Int) {
        countryGateway.selectCountryBy(code: self.displayedCountriesList[atIndex].alpha2Code)
        self.selectedCountriesList = countryGateway.getSelectedCountries()
        self.displayMode = .selectedCountries
    }
    
    func canDelete () -> Bool {
        return (self.displayMode == .selectedCountries)
    }
    
}

extension CountryListViewModel {
    
    func userPressedAddBtn(){
        self.displayMode = .allCountries
    }
    
    func userPressedCancelAddBtn() {
        self.displayMode = .selectedCountries
    }
    
    func userSearchedForCountry( searchTxt: String) {
        if searchTxt == "" {
            self.displayMode = .allCountries
            
        } else {
            self.filteredCountriesList = countryGateway.getFilteredCountries(str: searchTxt)
            self.displayMode = .filteredCountries
            
        }
        
    }
    
    func userPressed( at indexPath: IndexPath ){

        switch self.displayMode {
        case .allCountries, .filteredCountries:
            self.selectedCountry = nil
            if (self.selectedCountriesList.count < 5){
                if (!displayedCountriesList[indexPath.row].isSelected){
                    //add to selected countries
                    self.selectCountry(atIndex: indexPath.row)
                } else {
                    alertMessage = NSLocalizedString("Sorry: This country is already added", comment: "")
                }
                
            } else {
                alertMessage = NSLocalizedString("Sorry: You can't add more than 5 countries", comment: "")
            }
            
            //self.displayMode = .selectedCountries
        case .selectedCountries:
           self.selectedCountry = displayedCountriesList[indexPath.row]
            
        }
        
    }
}
