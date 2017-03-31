//
//  CatalogSearch.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 21.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class CatalogSearch: UITableViewController {
    
    var items: [
        (lvl1: Catalog.Category, lvl2: Catalog.Category, lvl3: Catalog.Category, ind:Int, item: Catalog.Item)] = []
    var filteredItems: [
        (lvl1: Catalog.Category, lvl2: Catalog.Category, lvl3: Catalog.Category, ind: Int, item: Catalog.Item)] = []

    var selectedIndex: IndexPath?

    
    
    func fillItems () {
        for cat1 in (catalog?.categories)! {
            for cat2 in cat1.subCategory {
                for cat3 in cat2.subCategory {
                    var i = 0
                    for item in cat3.items {
                        items.append((cat1, cat2, cat3, i, item))
                        i += 1
                    }
                }
            }
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        fillItems ()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barTintColor = AppModule.defaultColor
        searchController.searchBar.isOpaque = true
        searchController.searchBar.isTranslucent = false

        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        //searchController.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        } else {
            return items.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: Catalog.Item
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredItems[indexPath.row].item
        } else {
            item = items[indexPath.row].item
        }
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.vendor
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        performSegue(withIdentifier: "searchItem", sender: nil)
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = items.filter { i in
            return i.item.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? Category, segue.identifier == "searchItem" {
            if searchController.isActive && searchController.searchBar.text != "" {
                vc.searchItem = filteredItems[(selectedIndex?.row)!]
            } else {
                vc.searchItem = items[(selectedIndex?.row)!]
            }
        }
    }

}

extension CatalogSearch: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CatalogSearch: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
        
    }
}

extension CatalogSearch: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        performSegue(withIdentifier: "cancelSearch", sender: nil)
        
    }
}
