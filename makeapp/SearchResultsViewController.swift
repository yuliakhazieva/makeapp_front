//
//  SearchResultsViewController.swift
//  makeapp
//
//  Created by Yulia on 17.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchOutput: UICollectionView!
    var productIDs: [String] = []
    var produtModels: [ProductModel] = []
    var refProducts: DatabaseReference!
    var refCompsnies: DatabaseReference!
    var companyName: String? = ""
    var productName: String? = ""
    var category: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutput.delegate = self
        searchOutput.dataSource = self
        searchOutput.register(UINib.init(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if(companyName != nil) {
            var result = self.refCompsnies.queryOrderedByKey().queryStarting(atValue: companyName).queryEnding(atValue: (companyName!+"\\uf8ff"))
            result.observe(DataEventType.value, with: { (snapshot) in
                for company in snapshot.children.allObjects as! [DataSnapshot] {
                    for category in company.children.allObjects as! [DataSnapshot] {
                        if(category.key == self.category) {
                            for product in category.children.allObjects as! [DataSnapshot] {
                                self.productIDs.append(product.key)
                            }
                        }
                    }
                }
                for item in self.productIDs {
                    var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                    product.observe(DataEventType.value, with: { (snapshot) in
                        for product in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            let picture = product.childSnapshot(forPath: "pics/0").value
                            let url = URL(string: picture as! String)
                            let data = try? Data(contentsOf: url!)
                            let product: ProductModel = ProductModel(id: item, image: UIImage(data: data!)!, name: product.childSnapshot(forPath: "name").value as! String)
                            self.produtModels.append(product)
                            
                        }
                        self.searchOutput.reloadData()
                    })
                }
                
            })
        }
        
        if(productName != nil) {
            var result = self.refProducts.queryOrderedByKey().queryEnding(atValue: (productName!+"\\uf8ff"))
            var productIDsdouble: [String] = []
            result.observe(DataEventType.value, with: { (snapshot) in
                for product in snapshot.children.allObjects as! [DataSnapshot] {
                    if(self.productIDs == []) {
                        self.productIDs.append(product.key)
                    } else {
                        productIDsdouble.append(product.key)
                    }
                }
                
                for (i,num) in self.productIDs.enumerated().reversed() {
                    if (!productIDsdouble.contains(num)) {
                        self.productIDs.remove(at: i)
                    }
                }
                
                self.produtModels = []
                for item in self.productIDs {
                    var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                    product.observe(DataEventType.value, with: { (snapshot) in
                        for product in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            let picture = product.childSnapshot(forPath: "pics/0").value
                            let url = URL(string: picture as! String)
                            let data = try? Data(contentsOf: url!)
                            let product: ProductModel = ProductModel(id: item, image: UIImage(data: data!)!, name: product.childSnapshot(forPath: "name").value as! String)
                            self.produtModels.append(product)
                            
                        }
                        self.searchOutput.reloadData()
                    })
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(company: String, product: String, category: String) {
        self.companyName = company
        self.productName = product
        self.category = category
        
        refProducts = Database.database().reference().child("products")
        refCompsnies = Database.database().reference().child("companies")
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return produtModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        cell.configure(with: produtModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductScene") as! ProductController
        vc.setup(id: produtModels[indexPath.item].id)
        navigationController?.pushViewController(vc, animated: true)
    }

}
