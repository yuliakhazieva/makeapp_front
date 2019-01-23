//
//  BrandsViewController.swift
//  makeapp
//
//  Created by Yulia on 22.01.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//
import Foundation
import UIKit
import FirebaseCore
import FirebaseDatabase
import Firebase

class BrandsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    var refBrands: DatabaseReference!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    var brandlist = [String]()
    var ref = DatabaseReference()
    var filteredData: [String]! = []
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //the artist object
        let brand: String
        
        //getting the artist of selected position
        brand = filteredData[indexPath.row]
        
        //adding values to labels
        cell.nameButton.setTitle(brand, for: []) 
        
        //returning cell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        refBrands = Database.database().reference().child("companies");
        refBrands.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.brandlist.removeAll()
                
                //iterating through all the values
                for brands in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let brandName = brands.key
                    
                    //creating artist object with model and fetched values
                    let brand = brandName
                    
                    //appending it to list
                    self.brandlist.append(brand)
                }
                self.filteredData = self.brandlist
                //reloading the tableview
                self.table.reloadData()
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? brandlist : brandlist.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        table.reloadData()
    }
}

