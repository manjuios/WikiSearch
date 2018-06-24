//
//  ViewController.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultTable: UITableView!
    var viewModel = ViewModel()
    private var isApiFailed: Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        viewModel.pages.bind { [unowned self] (pages) in
            guard pages != nil else {
                DispatchQueue.main.async {
                    if self.isApiFailed {
                        self.isApiFailed = false
                        self.navigationItem.title = "NO RESULT 😒"
                    }
                    self.resultTable.reloadData()
                }
                return
            }
            DispatchQueue.main.async {
                self.isApiFailed = false
                self.resultTable.reloadData()
            }
        }
        
        viewModel.apiFailed.bind { [unowned self] (status) in
            guard let status = status else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "SEARCH"
                }
                return
            }
            if status == "YES" {
                DispatchQueue.main.async {
                    self.navigationItem.title = "NO RESULT 😒"
                }
            }
        }
    }
    
    fileprivate func setupNavigationUI() {
        navigationItem.title = "SEARCH"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gernerateRandomColor(),NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20.0)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let page = viewModel.getPages(indexPath.row) {
           
            if let term = page.terms {
                if let desc = term.description {
                    var message: String = "Description"
                    var i = 0
                    for des in desc {
                        if i == 0 {
                            message = des
                        } else {
                            message.append(" \(des)")
                        }
                        i += 1
                    }

                   message = message.count == 0 ? "Description" : message
                    
                    let height = message.heightOfString(tableView.frame.size.width - 76)
                    return (height + 40 + 24 ) <= 100 ? 100 : (height + 40 + 24)
                }
            }
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let title = viewModel.getTitle(indexPath.row) {
            let imagePath = "https://en.wikipedia.org/wiki/\(title)"
            if let image = imagePath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                if let url = URL(string: image) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let customCell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
        if let pages = viewModel.getPages(indexPath.row) {
            customCell.configureCell(pages)
        }
        cell = customCell
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText =  searchBar.text, searchText.count != 0{
            viewModel.fetchSearch(text: searchText)
            setupNavigationUI()
            self.navigationItem.title = searchText.uppercased()
        } else {
            print("PLease enter search text.")
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

