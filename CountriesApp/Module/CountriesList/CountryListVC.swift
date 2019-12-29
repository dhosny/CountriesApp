//
//  CountryListVC.swift
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class CountryListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var viewModel: CountryListViewModel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CountryListViewModel()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
        //get current location
        getCurrentLocation()
        
    }
    
    func initView() {
        self.navigationItem.title = NSLocalizedString("Country List", comment: "")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configSearchBar()
    }
    
    func setAddNavigationBarRightBtn() {
        let addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        addButton.setTitle(NSLocalizedString("+", comment: ""), for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.addTarget(self, action: #selector(addCountryBtnPressed), for: .touchUpInside)
        let addBar = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItems = [addBar]
    }
    
    func setCancelNavigationBarRightBtn() {
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAddCountryBtnPressed), for: .touchUpInside)
        let cancelBar = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItems = [cancelBar]
    }
    
    func configSearchBar (){
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
    }
    
    func initVM() {
        
        // binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                case .loading:
                    SVProgressHUD.show()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                case .loaded:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.updateViewUI = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.displayMode {
                case .allCountries, .filteredCountries:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.navigationItem.title = NSLocalizedString("Selected A Country", comment: "")
                        self.setCancelNavigationBarRightBtn()
                        self.tableView.setContentOffset( CGPoint(x: 0, y: 0) , animated: true)
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        self.tableView.tableHeaderView = self.searchController.searchBar
                        self.searchController.searchBar.isHidden = false
                    })
                case .selectedCountries:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.navigationItem.title = NSLocalizedString("Country List", comment: "")
                        self.setAddNavigationBarRightBtn()
                        self.tableView.tableHeaderView = nil
                        self.searchController.searchBar.isHidden = true
                        self.tableView.setContentOffset( CGPoint(x: 0, y: 60.0) , animated: true)
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        
                    })
                }
                
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        if let presentedVC = presentedViewController {
            presentedVC.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//MARK: -- Table View
extension CountryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        configCell(cell: &cell, country: viewModel.getCountry(atIndex: indexPath.row))
        
        return cell
    }
    
    func configCell(cell: inout UITableViewCell, country: Country){
        cell.textLabel!.text = country.name
        
        if ( self.viewModel.displayMode != .selectedCountries){
            cell.accessoryType = country.isSelected ? .checkmark : .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canDelete()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.unselectCountry(atIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.viewModel.userPressed(at: indexPath)
        if self.viewModel.selectedCountry != nil {
            return indexPath
        }else{
            return nil
        }
        
    }
    
}

//MARK: -- UI Event Handler
extension CountryListVC {
    
    @objc func addCountryBtnPressed (sender: Any){
        self.searchController.searchBar.text = ""
        viewModel.userPressedAddBtn()
    }
    
    @objc func cancelAddCountryBtnPressed (sender: Any){
        viewModel.userPressedCancelAddBtn()
    }
    
}

//MARK: -- Segue
extension CountryListVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CountryDetailsVC,
            let country = viewModel.selectedCountry {
             vc.country = country
        }
    }
}

//MARK: -- Search Delegate
extension CountryListVC: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        self.viewModel.userSearchedForCountry(searchTxt: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchController.searchBar.text
        self.viewModel.userSearchedForCountry(searchTxt: searchString!)
    }
}

//MARK: -- Location
extension CountryListVC: CLLocationManagerDelegate {

    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                self.viewModel.setLocationService(states: false)
                break
                
            case .restricted, .denied:
                // Disable location features
                self.viewModel.setLocationService(states: false)
                let alert = UIAlertController(title: NSLocalizedString("Allow Location Access", comment: ""), message: NSLocalizedString("the App needs access to your location. Turn on Location Services in your device settings.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                print("Full Access")
                self.viewModel.setLocationService(states: true)
                locationManager.startUpdatingLocation()
                break
            }
        } else {
            self.viewModel.setLocationService(states: false)
            print("Location services are not enabled")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.lookUpCurrentLocation(location: locValue)
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
        self.viewModel.setDefultCountry()
    }
    
    func lookUpCurrentLocation(location : CLLocationCoordinate2D) {
        // Use the last reported location.
        
        let lastLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation,
                                        completionHandler: { (placemarks, error) in
                                            
                                            if error == nil {
                                                let pm = placemarks![0]
                                                self.viewModel.setDefultCountry(code: pm.isoCountryCode!)
                                            } else {
                                                self.viewModel.setDefultCountry()
                                            }
        })
    }
}


