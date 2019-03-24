//
//  MyPageViewController.swift
//  makeapp
//
//  Created by Yulia on 17.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var wishlist: UICollectionView!
    @IBOutlet weak var myBag: UICollectionView!
    var refProduct: DatabaseReference!
    var refWishlist: DatabaseReference!
    var refMyBag: DatabaseReference!
    var wishlistProductList: [ProductModel] = []
    var myBagProductList: [ProductModel] = []
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlist.register(UINib.init(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        myBag.register(UINib.init(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        refProduct = Database.database().reference().child("products")
        refProduct.observe(DataEventType.value, with: { (productsnapshot) in
            
            self.refWishlist = Database.database().reference().child("wishlists").child((Auth.auth().currentUser?.uid)!);
            self.refWishlist.observe(DataEventType.value, with: { (wishlistsnapshot) in
                self.wishlistProductList.removeAll()
                for product in wishlistsnapshot.children.allObjects as! [DataSnapshot] {
                    var productData = productsnapshot.childSnapshot(forPath: product.key)
                    let picture = productData.childSnapshot(forPath: "pics/0").value
                    let url = URL(string: picture as! String)
                    var productModel = ProductModel(id: product.key, image: url!, name:productData.childSnapshot(forPath: "name").value as! String )
                    
                    self.wishlistProductList.append(productModel)
                }
                self.wishlist.reloadData()
                self.myBag.reloadData()
            })
            
            self.refMyBag = Database.database().reference().child("collections").child((Auth.auth().currentUser?.uid)!);
            self.refMyBag.observe(DataEventType.value, with: { (collectionsnapshot) in
                self.myBagProductList.removeAll()
                for product in collectionsnapshot.children.allObjects as! [DataSnapshot] {
                    var productData = productsnapshot.childSnapshot(forPath: product.key)
                    let picture = productData.childSnapshot(forPath: "pics/0").value
                    let url = URL(string: picture as! String)
                    var productModel = ProductModel(id: product.key, image: url!, name:productData.childSnapshot(forPath: "name").value as! String )
                    
                    self.myBagProductList.append(productModel)
                }
                self.wishlist.reloadData()
                self.myBag.reloadData()
            })
            self.wishlist.reloadData()
            self.myBag.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.wishlist {
            return wishlistProductList.count
        }
        else {
            return myBagProductList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.wishlist {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            cell.configure(with: wishlistProductList[indexPath.item])
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
            cell.configure(with: myBagProductList[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.wishlist {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductScene") as! ProductController
            vc.setup(id: wishlistProductList[indexPath.item].id)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductScene") as! ProductController
            vc.setup(id: myBagProductList[indexPath.item].id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
