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
    
    private var countriesList: [Country] = [Country](){
        didSet {
            self.reloadTableViewClosure?()
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
        return countriesList.count
    }
    
    var selectedPhoto: Country?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
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
            self.state = .loaded
        }
    }
    
    func getCountry(atIndex : Int) -> String{
        return self.countriesList[atIndex].name
    }
    
    
}

extension CountryListViewModel {
    func userPressed( at indexPath: IndexPath ){
//        let photo = self.photos[indexPath.row]
//        if photo.for_sale {
//            self.isAllowSegue = true
//            self.selectedPhoto = photo
//        }else {
//            self.isAllowSegue = false
//            self.selectedPhoto = nil
//            self.alertMessage = "This item is not for sale"
//        }
        
    }
}
