//
//  CountryDetailsVC.swift
//  CountriesApp
//
//  Created by MAC on 12/28/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import UIKit

class CountryDetailsVC: UIViewController {
    
    var country: Country!

    @IBOutlet weak var capitalLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView () {
        self.navigationItem.title = country.name
        self.capitalLbl.text = country.capital
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension CountryDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Currencies: ", comment: "")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        
        cell.textLabel!.text = country.currencies[indexPath.row].name
        
        return cell
    }
    
    
}
