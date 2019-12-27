//
//	Currency.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import RealmSwift
import Realm

class Currency: Object {

    @objc dynamic var country: Country!
	@objc dynamic var code: String!
	@objc dynamic var name: String!
	@objc dynamic var symbol: String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> Currency	{
		let this = Currency()
		if let countryData = dictionary["country"] as? [String:Any]{
            this.country = Country.fromDictionary(dictionary: countryData)
		}
		if let codeValue = dictionary["code"] as? String{
			this.code = codeValue
		}
		if let nameValue = dictionary["name"] as? String{
			this.name = nameValue
		}
		if let symbolValue = dictionary["symbol"] as? String{
			this.symbol = symbolValue
		}
		return this
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if country != nil{
			dictionary["country"] = country.toDictionary()
		}
		if code != nil{
			dictionary["code"] = code
		}
		if name != nil{
			dictionary["name"] = name
		}
		if symbol != nil{
			dictionary["symbol"] = symbol
		}
		return dictionary
	}


}
