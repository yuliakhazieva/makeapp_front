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


class ProductController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    var productID: String = ""
    var imageList: [UIImage] = []
    var reviewList: [Review] = []
    
    @IBOutlet var reviews: UITableView!
    @IBOutlet var pics: UICollectionView!
    @IBOutlet var addToCollection: UIButton!
    @IBOutlet var addToWishList: UIButton!
    @IBOutlet var price: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var company: UILabel!
    
    var refProduct: DatabaseReference!
    var refReviews: DatabaseReference!
    var refUsers: DatabaseReference!
    var refWishList: DatabaseReference!
    var refMyBag: DatabaseReference!
    
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
            self.imageList.removeAll()
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
                self.rating.text = snapshot.childSnapshot(forPath: "rating").value as? String
            }
        })
        
        refReviews = Database.database().reference().child("reviews").child(productID);
        refReviews.observe(DataEventType.value, with: { (snapshot) in
            self.reviewList.removeAll()
            if snapshot.childrenCount > 0 {
                for review in snapshot.children.allObjects as! [DataSnapshot] {
                
                    let authorID = review.childSnapshot(forPath: "author").value as? String
                    let rating = review.childSnapshot(forPath: "rating").value as? String
                    let reviewText = review.childSnapshot(forPath: "text").value as? String
                
                self.refUsers = Database.database().reference().child("users").child(authorID!);
                    self.refUsers.observe(DataEventType.value, with: { (snapshot) in
                        let authorName = snapshot.childSnapshot(forPath: "username").value
                        self.reviewList.append(Review(author: authorName as! String, rating: rating!, reviewText: reviewText!))
                    self.reviews.reloadData()
                    })
                }
            }
        })
        
        company.text = productID.split(separator: "Ф").map(String.init)[1].split(separator: " ").map(String.init)[0]
        
    }
    
    @IBAction func onAddToWishList(_ sender: Any) {
        Database.database().reference().child("wishlists").child((Auth.auth().currentUser?.uid)!).updateChildValues([productID:"0"])
        let alert = UIAlertController(title: "", message: "Добавлен в вишлист", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onAddToCollection(_ sender: Any) {
        Database.database().reference().child("collections").child((Auth.auth().currentUser?.uid)!).updateChildValues([productID:"0"])
        let alert = UIAlertController(title: "", message: "Добавлен в мою косметичку", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onLeaveReview(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "leaveReview") as! LeaveReviewViewController
        vc.setUp(productId: productID)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicsCollectionViewCell
        cell.pic.image = imageList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ReviewTableViewCell else { return }
        
        tableViewCell.author.text = reviewList[indexPath.item].author
        tableViewCell.textOfReview.text = reviewList[indexPath.item].reviewText
        tableViewCell.rating.text = String(reviewList[indexPath.item].rating)
    }
}
