//
//  CountryListVC.swift
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 DoneIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class CountryListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CountryListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CountryListViewModel()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
    }
    
    func initView() {
        self.navigationItem.title = NSLocalizedString("Select a country", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        
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
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension CountryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        cell.textLabel!.text = viewModel.getCountry(atIndex: indexPath.row)
        
        return cell
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        return indexPath
    }
    
}

extension CountryListVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CountryDetailsVC,
            let photo = viewModel.selectedPhoto {
            //vc.imageUrl = photo.image_url
        }
    }
}

