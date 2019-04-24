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
    var color: UIColor = UIColor.black
    
    @IBOutlet weak var noneFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        noneFound.isHidden = true
        let myCIColor = CIColor(color: color)
        let green = myCIColor.green
        let blue = myCIColor.blue
        let red = myCIColor.red
        searchOutput.delegate = self
        searchOutput.dataSource = self
        searchOutput.register(UINib.init(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
//        if(companyName != "") {
//            let ref = refCompsnies.queryOrderedByKey().queryEqual(toValue: companyName!)
//            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
//                for companies in snapshot.children {
//                    for category in (companies as AnyObject).children {
//                        if((category as AnyObject).key == self.category) {
//                            for product in (category as AnyObject).children.allObjects as! [DataSnapshot] {
//                                if(self.productName != nil) {
//                                    if(product.key.characters.split(separator: "Ф").map(String.init)[0].range(of:self.productName!) != nil){
//                                        self.productIDs.append(product.key)
//                                    }
//                                } else {
//                                    self.productIDs.append(product.key)
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//
//            for item in self.productIDs {
//                var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
//                product.observe(DataEventType.value, with: { (snapshot) in
//                    for product in snapshot.children.allObjects as! [DataSnapshot] {
//                        let productR = product.childSnapshot(forPath: "r").value
//                        let productG = product.childSnapshot(forPath: "g").value
//                        let productB = product.childSnapshot(forPath: "b").value
//
//                        if(self.color != UIColor.black) {
//                            if(abs(green - (productG as! CGFloat)) < 10
//                                && abs(red - (productR as! CGFloat)) < 10
//                                && abs(blue - (productB as! CGFloat)) < 10) {
//                                let picture = product.childSnapshot(forPath: "pics/0").value
//                                let url = URL(string: picture as! String)
//                                let product: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
//                                self.produtModels.append(product)
//                            }
//                        } else {
//                            let picture = product.childSnapshot(forPath: "pics/0").value
//                            let url = URL(string: picture as! String)
//                            let product: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
//                            self.produtModels.append(product)
//                        }
//                    }
//                    self.searchOutput.reloadData()
//                    if (self.produtModels.count == 0){
//                        self.noneFound.isHidden = false
//                    }
//                    if (self.produtModels.count == 0){
//                        self.noneFound.isHidden = false
//                    }
//                })
//            }
//        }
//
//        if(productName != "") {
//            var productIDsdouble: [String] = []
//            refProducts.observe(DataEventType.value, with: { (snapshot) in
//                for product in snapshot.children.allObjects as! [DataSnapshot] {
//                    if (product.key.characters.split(separator: "Ф").map(String.init)[0].range(of:self.productName!) != nil) {
//
//                        let productR = product.childSnapshot(forPath: "r").value
//                        let productG = product.childSnapshot(forPath: "g").value
//                        let productB = product.childSnapshot(forPath: "b").value
//
//                        if(self.companyName == nil) {
//                            if(self.color != UIColor.black) {
//                                if(abs(green - (productG as! CGFloat)) < 10
//                                    && abs(red - (productR as! CGFloat)) < 10
//                                    && abs(blue - (productB as! CGFloat)) < 10) {
//                                    self.productIDs.append(product.key)
//                                }
//                            } else {
//                                self.productIDs.append(product.key)
//                            }
//                        } else {
//                            if(self.color != UIColor.black) {
//                                if(abs(green - (productG as! CGFloat)) < 10
//                                    && abs(red - (productR as! CGFloat)) < 10
//                                    && abs(blue - (productB as! CGFloat)) < 10) {
//                                        productIDsdouble.append(product.key)
//                                }
//                            } else {
//                                productIDsdouble.append(product.key)
//                            }
//                        }
//                    }
//                }
//
//                for (i,num) in self.productIDs.enumerated().reversed() {
//                    if (!productIDsdouble.contains(num)) {
//                        self.productIDs.remove(at: i)
//                    }
//                }
//
//                self.produtModels = []
//                if (self.productIDs != []){
//                for item in self.productIDs {
//                    let product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
//                    product.observe(DataEventType.value, with: { (snapshot) in
//                        for product in snapshot.children.allObjects as! [DataSnapshot] {
//
//                            let productR = product.childSnapshot(forPath: "r").value
//                            let productG = product.childSnapshot(forPath: "g").value
//                            let productB = product.childSnapshot(forPath: "b").value
//                            let picture = product.childSnapshot(forPath: "pics/0").value
//                            let url = URL(string: picture as! String)
//                            let product: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
//
//                            if(self.color != UIColor.black) {
//                                if(abs(green - (productG as! CGFloat)) < 0.1
//                                    && abs(red - (productR as! CGFloat)) < 0.1
//                                    && abs(blue - (productB as! CGFloat)) < 0.1) {
//                                    self.produtModels.append(product)
//                                }
//                            } else {
//                                self.produtModels.append(product)
//                            }
//
//                        }
//                        self.searchOutput.reloadData()
//                        if (self.produtModels.count == 0){
//                            self.noneFound.isHidden = false
//                        }
//                    })
//                }
//                } else {
//                    for item in productIDsdouble {
//                        let product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
//                        product.observe(DataEventType.value, with: { (snapshot) in
//                            for product in snapshot.children.allObjects as! [DataSnapshot] {
//
//                                let productR = product.childSnapshot(forPath: "r").value
//                                let productG = product.childSnapshot(forPath: "g").value
//                                let productB = product.childSnapshot(forPath: "b").value
//                                let picture = product.childSnapshot(forPath: "pics/0").value
//                                let url = URL(string: picture as! String)
//                                let product: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
//
//                                if(self.color != UIColor.black) {
//                                    if(abs(green - (productG as! CGFloat)) < 0.1
//                                        && abs(red - (productR as! CGFloat)) < 0.1
//                                        && abs(blue - (productB as! CGFloat)) < 0.1) {
//                                        self.produtModels.append(product)
//                                    }
//                                } else {
//                                    self.produtModels.append(product)
//                                }
//
//                            }
//                            self.searchOutput.reloadData()
//                            if (self.produtModels.count == 0){
//                                self.noneFound.isHidden = false
//                            }
//                        })
//                    }
//
//                }
//                if (self.produtModels.count == 0){
//                    self.noneFound.isHidden = false
//                }
//            })
//        }
        
        if(companyName != nil) {
            refCompsnies.observe(DataEventType.value, with: { (snapshot) in
                for company in snapshot.children.allObjects as! [DataSnapshot] {
                    if (company.key.range(of:self.companyName!) != nil){
                        for category in company.children.allObjects as! [DataSnapshot] {
                            if(category.key.lowercased() == self.category?.lowercased()) {
                                for product in category.children.allObjects as! [DataSnapshot] {
                                    self.productIDs.append(product.key)
                                }
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
                            if(url == nil) {
                                continue
                            }
                            let productModel: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
                            
                            if(self.category == "lipstick"){
                                let productR = (product.childSnapshot(forPath: "r").value as! CGFloat) / 225.0
                                let productG = product.childSnapshot(forPath: "g").value as! CGFloat/225.0
                                let productB = product.childSnapshot(forPath: "b").value as! CGFloat/225.0
                                if(self.color != UIColor.black) {
                                    if(abs(green - (productG)) < 0.1
                                        && abs(red - (productR)) < 0.1
                                        && abs(blue - (productB)) < 0.1) {
                                        self.produtModels.append(productModel)
                                    }
                                } else {
                                    self.produtModels.append(productModel)
                                }
                            } else {
                                self.produtModels.append(productModel)
                            }
                        }
                        self.searchOutput.reloadData()
                    })
                }
                if(self.productIDs.count == 0) {
                    self.noneFound.isHidden = false
                    
                }
            })
        }
        
        if(productName != nil) {
            var productIDsdouble: [String] = []
            refProducts.observe(DataEventType.value, with: { (snapshot) in
                for product in snapshot.children.allObjects as! [DataSnapshot] {
                    if (product.key.characters.split(separator: "Ф").map(String.init)[0].range(of:self.productName!) != nil) {
                        if(self.companyName == nil) {
                            self.productIDs.append(product.key)
                        } else {
                            productIDsdouble.append(product.key)
                        }
                    }
                }
                
                for (i,num) in self.productIDs.enumerated().reversed() {
                    if (!productIDsdouble.contains(num)) {
                        self.productIDs.remove(at: i)
                    }
                }
                
                self.produtModels = []
                if (self.productIDs != []){
                    for item in self.productIDs {
                        var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                        product.observe(DataEventType.value, with: { (snapshot) in
                            for product in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                let picture = product.childSnapshot(forPath: "pics/0").value
                                let url = URL(string: picture as! String)
                                let productModel: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
                                
                                if(self.category == "lipstick"){
                                    let productR = (product.childSnapshot(forPath: "r").value as! CGFloat) / 225.0
                                    let productG = product.childSnapshot(forPath: "g").value as! CGFloat/225.0
                                    let productB = product.childSnapshot(forPath: "b").value as! CGFloat/225.0
                                    if(self.color != UIColor.black) {
                                        if(abs(green - (productG)) < 0.1
                                            && abs(red - (productR)) < 0.1
                                            && abs(blue - (productB)) < 0.1) {
                                            self.produtModels.append(productModel)
                                        }
                                    } else {
                                        self.produtModels.append(productModel)
                                    }
                                } else {
                                    self.produtModels.append(productModel)
                                }
                                
                            }
                            self.searchOutput.reloadData()
                        })
                    }
                } else {
                    for item in productIDsdouble {
                        var product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                        product.observe(DataEventType.value, with: { (snapshot) in
                            for product in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                let picture = product.childSnapshot(forPath: "pics/0").value
                                let url = URL(string: picture as! String)
                                let productModel: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
                                
                                if(self.category == "lipstick"){
                                    let productR = (product.childSnapshot(forPath: "r").value as! CGFloat) / 225.0
                                    let productG = product.childSnapshot(forPath: "g").value as! CGFloat/225.0
                                    let productB = product.childSnapshot(forPath: "b").value as! CGFloat/225.0
                                    if(self.color != UIColor.black) {
                                        if(abs(green - (productG)) < 0.1
                                            && abs(red - (productR)) < 0.1
                                            && abs(blue - (productB)) < 0.1) {
                                            self.produtModels.append(productModel)
                                        }
                                    } else {
                                        self.produtModels.append(productModel)
                                    }
                                } else {
                                    self.produtModels.append(productModel)
                                }
                                
                            }
                            self.searchOutput.reloadData()
                        })
                    }
                    if(productIDsdouble.count == 0) {
                        self.noneFound.isHidden = false
                    }
                }
            })
        }
        
        if(companyName == "" && productName == "") {
            refProducts.observe(DataEventType.value, with: { (snapshot) in
                for product in snapshot.children.allObjects as! [DataSnapshot] {

                    var cat = product.childSnapshot(forPath: "category").value as! String
                    if(cat == "lipstick" && self.category?.lowercased() == "lipstick"){
                    let productR = (product.childSnapshot(forPath: "r").value as! CGFloat) / 225.0
                    let productG = product.childSnapshot(forPath: "g").value as! CGFloat/225.0
                    let productB = product.childSnapshot(forPath: "b").value as! CGFloat/225.0
                    if(self.color != UIColor.black) {
                        if(abs(green - (productG)) < 0.1
                            && abs(red - (productR)) < 0.1
                            && abs(blue - (productB)) < 0.1) {
                            self.productIDs.append(product.key)
                        }
                    } else {
                        self.productIDs.append(product.key)
                    }
                    } else {
                        if (cat.lowercased() == self.category?.lowercased()) {
                            self.productIDs.append(product.key)
                        }
                    }
                }
                
                self.produtModels = []
                if (self.productIDs != []){
                    for item in self.productIDs {
                        let product = self.refProducts.queryOrderedByKey().queryEqual(toValue: item)
                        product.observe(DataEventType.value, with: { (snapshot) in
                            for product in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                let productR = product.childSnapshot(forPath: "r").value
                                let productG = product.childSnapshot(forPath: "g").value
                                let productB = product.childSnapshot(forPath: "b").value
                                let picture = product.childSnapshot(forPath: "pics/0").value
                                let url = URL(string: picture as! String)
                                if(url == nil){
                                    continue
                                }
                                let product: ProductModel = ProductModel(id: item, image: url!, name: product.childSnapshot(forPath: "name").value as! String)
                                
                                self.produtModels.append(product)
                                
                            }
                            self.searchOutput.reloadData()
                        })
                    }
                } else {
                    if (self.produtModels.count == 0){
                        self.noneFound.isHidden = false
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(company: String, product: String, category: String, color: UIColor) {
        self.companyName = company
        self.productName = product
        self.category = category
        self.color = color
        
        refProducts = Database.database().reference().child("products")
        refCompsnies = Database.database().reference().child("companies")
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(produtModels.count != 0) {
            noneFound.isHidden = true
        }
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
