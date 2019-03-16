//
//  SuperMagicCollapse.swift
//  makeapp
//
//  Created by Yulia on 06.02.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseDatabase
import Firebase

class SuperMagicCollapse: UITableViewController {
    
    var storedOffsets = [Int: CGFloat]()
    var brandName = String()
    var categoryList = [String]()
    var productList = [[ProductModel]]()
    var productIDs = [[String]]()
    var refCategories: DatabaseReference!
    var refProducts: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        refCategories = Database.database().reference().child("companies").child(brandName);
        refCategories.observe(DataEventType.value, with: { (snapshot) in
            
            self.categoryList.removeAll()
            
            for category in snapshot.children.allObjects as! [DataSnapshot] {
                let cat = category.key
                if cat != "sitemap" {
                    self.categoryList.append(cat)
                    self.productList.append(contentsOf: [[]])
                    self.productIDs.append(contentsOf: [[]])
                }
                
                for product in category.children.allObjects as! [DataSnapshot] {
                    self.productIDs[self.categoryList.count - 1].append(product.key)
                }
            }
            
            self.refProducts = Database.database().reference().child("products");
            for (index, cat) in self.productIDs.enumerated() {
                for item in cat {
                    var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                    product.observe(DataEventType.value, with: { (snapshot) in
                        for product in snapshot.children.allObjects as! [DataSnapshot] {
                        
                            let picture = product.childSnapshot(forPath: "pics/0").value
                            let url = URL(string: picture as! String)
                            let data = try? Data(contentsOf: url!)
                            let product: ProductModel = ProductModel(id: item, image: UIImage(data: data!)!, name: product.childSnapshot(forPath: "name").value as! String)
                            self.productList[index].append(product)
                        
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        }
        )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? collapcibleCell else { return }
        
        tableViewCell.categoryLabel.text = categoryList[indexPath.row]
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? collapcibleCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}
    
extension SuperMagicCollapse: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductScene") as! ProductController
        vc.setup(id: productList[collectionView.tag][indexPath.item].id)
        navigationController?.pushViewController(vc, animated: true)
       // self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
       
        if(indexPath.row < productList.count){
            if(indexPath.item < productList[indexPath.row].count){
                cell.configure(with: productList[collectionView.tag][indexPath.item])
            }
        }

        return cell
    }
}
