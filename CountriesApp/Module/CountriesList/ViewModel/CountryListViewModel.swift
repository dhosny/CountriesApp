//
//  CountryListViewModel.swift
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import Foundation

class CountryListViewModel {

    let countryGateway: CountryGateway
    
    private var countriesList: [Country] = [Country]()
    
    private var selectedCountriesList: [Country] = [Country]()
    
    private var filteredCountriesList: [Country] = [Country]()
    
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
            self.displayMode = .selectedCountries
            self.state = .loaded
        }
    }
    
    func initSelectedCountries (){
        //add current country of eg if not detected
        countryGateway.selectCountryBy(code: "EG")
        //load Selected Countries
        self.selectedCountriesList = self.countryGateway.getSelectedCountries()
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
                //add to selected countries
               self.selectCountry(atIndex: indexPath.row)
                
            } else {
                alertMessage = NSLocalizedString("Sorry: You can't add more than 5 countries", comment: "")
            }
            
            //self.displayMode = .selectedCountries
        case .selectedCountries:
           self.selectedCountry = displayedCountriesList[indexPath.row]
            
        }
        
    }
}
