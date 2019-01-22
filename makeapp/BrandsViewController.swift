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

class BrandsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refBrands: DatabaseReference!
    
    @IBOutlet weak var table: UITableView!
    var brandlist = [String]()
    var ref = DatabaseReference()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return brandlist.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //the artist object
        let brand: String
        
        //getting the artist of selected position
        brand = brandlist[indexPath.row]
        
        //adding values to labels
        cell.nameButton.setTitle(brand, for: []) 
        
        //returning cell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                //reloading the tableview
                self.table.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

