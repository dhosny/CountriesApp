//
//  UserGateway.swift
//  TadawyUser
//
//  Created by MAC on 1/31/19.
//  Copyright © 2019 CodexGlobal. All rights reserved.
//


import Alamofire

class CountryGateway {
    
    let apiClient: APIClient
    let localStorage: LocalCountriesManagerProtocol
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
        localStorage = RealmLocalCountriesManager()
    }
    
    private func getAllCountries(completion: @escaping (_ responce : [Country],_ message : String,_ status : Int) -> ()) {
        let apiURL = "/all"
        let parameter = "fields=name;capital;alpha2Code;currencies"
        apiClient.getApiRequest(apiURL: apiURL, withParameter: parameter){
            (responce, status, msg) in
            if status{
                print(responce);
                var list = [Country]()
                for item in responce{
                    let country = Country.fromDictionary(dictionary: item)
                    list.append(country)
                }
                
                completion(list, msg, 1)
                
            }else{
                completion([], msg , 0)
                
            }
        }
    }
    
    func getCountries (completion: @escaping (_ responce : [Country],_ message : String,_ status : Int) -> ()){
        let countries = localStorage.getAllCountries()
        //check number of stored countries
        if (countries.count == 0){
            //load from api
            self.getAllCountries(){ (countries, msg, status) in
                if status == 1 {
                    //save countries in realm
                    self.localStorage.saveCountries(countries: countries)
                }
                completion(countries, msg, status)
            }
        }else{
            completion(countries, NSLocalizedString("Done", comment: ""), 1)
        }
        
    }
    
    func getSelectedCountries () -> [Country]{
        let countries = localStorage.getSelectedCountries()
        return countries
    }
    
    func getFilteredCountries (str: String) -> [Country]{
        let countries = localStorage.getFilteredCountriesBy(name: str)
        return countries
    }
    
    func selectCountryBy(code: String){
        localStorage.selectCountryBy(code: code)
    }
    
    func unselectCountryBy(code: String){
        localStorage.unSelectCountryBy(code: code)
    }

}
