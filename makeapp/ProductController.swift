//
//  ProductController.swift
//  makeapp
//
//  Created by Yulia on 15.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import Firebase

class ProductController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var productID: String = ""
    var imageList: [UIImage] = []
    
    @IBOutlet var reviews: UITableView!
    @IBOutlet var leaveReview: UIButton!
    @IBOutlet var pics: UICollectionView!
    @IBOutlet var addToCollection: UIButton!
    @IBOutlet var addToWishList: UIButton!
    @IBOutlet var price: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var company: UILabel!
    
    var refProduct: DatabaseReference!
    var refReviews: DatabaseReference!
    
    func setup(id: String) {
        self.imageList = []
        self.productID = id
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pics.register(UINib.init(nibName: "pic", bundle: nil), forCellWithReuseIdentifier: "picCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refProduct = Database.database().reference().child("products").child(productID);
        refProduct.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.name.text = snapshot.childSnapshot(forPath: "name").value as? String
                self.price.text = snapshot.childSnapshot(forPath: "price").value as? String
                
                let pictures = snapshot.childSnapshot(forPath: "pics").children.allObjects as! [DataSnapshot]
                
                for pic in pictures {
                    let picture = pic.value
                    let url = URL(string: picture as! String)
                    let data = try? Data(contentsOf: url!)
                    self.imageList.append(UIImage(data: data!)!)
                }
                self.pics.reloadData()
            }
        })
    }
    
    @IBAction func onAddToWishList(_ sender: Any) {
    }
    
    
    @IBAction func onAddToCollection(_ sender: Any) {
    }
    
    @IBAction func onLeaveReview(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicsCollectionViewCell
        cell.pic.image = imageList[indexPath.row]
        return cell
    }

}
