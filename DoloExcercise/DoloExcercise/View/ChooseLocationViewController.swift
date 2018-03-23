//
//  ChooseLocationViewController.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class ChooseLocationViewController: UIViewController {

    var viewModel: LocationSelectorViewModel!
    let activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noMatchLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpActivityIndicator()
        configureSearchField()
        configureTableView()
        configureView()
    }

    func configureView() {
        view.backgroundColor = .greyBackground
        
        headerView.backgroundColor = .offWhite
        
        noMatchLabel.isHidden = true
    }
    
    func configureTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        viewModel.tableDelegate = self
        tableLoadStage(.notLoaded)
        
        tableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.identifier)
    }
    
    func configureSearchField() {
        searchField.delegate = viewModel
        searchField.backgroundColor = .greySearchBar
        searchField.textColor = .black
        searchField.layer.cornerRadius = 5
        clearButton.isHidden = true
    }
    
    func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        resetTable()
        searchField.resignFirstResponder()
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        resetTable()
    }
    
    func resetTable() {
        clearButton.isHidden = true
        searchField.text = ""
        viewModel.isSearch = false
        noMatchLabel.isHidden = true
        tableView.reloadData()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}

extension ChooseLocationViewController: TableLoadProtocol {
    func tableLoadStage(_ stage: LoadStage) {
        switch stage {
        case .notLoaded:
            activityIndicator.startAnimating()
            tableView.isHidden = true
        case .loaded:
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.noMatchLabel.isHidden = true
            }
        case .reload:
            clearButton.isHidden = viewModel.isSearch ? false : true
            noMatchLabel.isHidden = true
            tableView.reloadData()
        case .emptyLoad:
            clearButton.isHidden = false
            noMatchLabel.isHidden = false
            tableView.reloadData()
        }
    }

    
    func dismissTable(newTitle: String, iconImage: UIImage) {
        if let presenter = presentingViewController as? NewPostViewController {
            presenter.locationLabel.text = newTitle
            presenter.optionalLabel.text = "Change Location"
            presenter.optionalLabelLeftConstraint.constant = 218
            presenter.iconButton.setImage(iconImage, for: .normal)
            presenter.iconButton.tintColor = .grey3
        }
        dismiss(animated: true, completion: nil)
    }
}
