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
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
        let countries = LocalCountriesManager.shared.getCountries()
        //check number of stored countries
        if (countries.count == 0){
            //load from api
            self.getAllCountries(){ (countries, msg, status) in
                if status == 1 {
                //save countries in realm
                    LocalCountriesManager.shared.saveCountries(countries: countries)
                }
                completion(countries, msg, status)
            }
        }
        
    }

}
