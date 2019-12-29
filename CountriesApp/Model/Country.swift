//
//	Country.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport


import Foundation
import RealmSwift
import Realm

class Country: Object {

    @objc dynamic var alpha2Code: String!
	@objc dynamic var capital: String!
    var currencies = List<Currency>()
	@objc dynamic var name: String!
    @objc dynamic var isSelected: Bool = false
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> Country	{
		let this = Country()
		if let alpha2CodeValue = dictionary["alpha2Code"] as? String{
			this.alpha2Code = alpha2CodeValue
		}
		if let capitalValue = dictionary["capital"] as? String{
			this.capital = capitalValue
		}
		if let currenciesArray = dictionary["currencies"] as? [[String:Any]]{
            let currenciesItems = List<Currency>()
			for dic in currenciesArray{
                let value = Currency.fromDictionary(dictionary: dic)
				currenciesItems.append(value)
			}
			this.currencies = currenciesItems
		}
		if let nameValue = dictionary["name"] as? String{
			this.name = nameValue
		}
        this.isSelected = false
		return this
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if alpha2Code != nil{
			dictionary["alpha2Code"] = alpha2Code
		}
		if capital != nil{
			dictionary["capital"] = capital
		}
		if currencies != nil{
			var dictionaryElements = [[String:Any]]()
			for i in 0 ..< currencies.count {
				if let currenciesElement = currencies[i] as? Currency{
					dictionaryElements.append(currenciesElement.toDictionary())
				}
			}
			dictionary["currencies"] = dictionaryElements
		}
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}
    

}
