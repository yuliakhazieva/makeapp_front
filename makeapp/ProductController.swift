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
import FirebaseAuth


class ProductController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rivgosh: UILabel!
    @IBOutlet weak var ildebote: UILabel!
    @IBOutlet weak var goldenApple: UILabel!
    
    var productID: String = ""
    var imageList: [UIImage] = []
    var reviewList: [Review] = []
    
    @IBOutlet weak var category: UILabel!
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
                var currency: String ;
                if((snapshot.childSnapshot(forPath: "price").value as! NSString).floatValue < 200.0) {
                    currency = "$"
                } else {
                    currency = "₽"
                }
                self.price.text = (snapshot.childSnapshot(forPath: "price").value as? String)! + currency
                
                
                let pictures = snapshot.childSnapshot(forPath: "pics").children.allObjects as! [DataSnapshot]
                
                for pic in pictures {
                    let picture = pic.value
                    let url = URL(string: picture as! String)
                    let data = try? Data(contentsOf: url!)
                    self.imageList.append(UIImage(data: data!)!)
                }
                
                if(type(of: snapshot.childSnapshot(forPath: "elize").value!) != NSNull.self) {
                    self.rivgosh.text = "Цена в ЭЛИЗЕ " + (snapshot.childSnapshot(forPath: "elize").value as? String)!
                } else {
                    self.rivgosh.text = "Цена в ЭЛИЗЕ N/A"
                }
                self.goldenApple.text = "Цена в Золотое Яблоко " + (snapshot.childSnapshot(forPath: "goldenapple").value as? String)!
                self.ildebote.text = "Цена в Иль Де Боте " + (snapshot.childSnapshot(forPath: "ildebote").value as? String)!
                
               // self.category.text = snapshot.childSnapshot(forPath: "category").value as? String
                self.pics.reloadData()
                if(String(describing:snapshot.childSnapshot(forPath: "rating").value) == "Optional(?)"){
                    self.rating.text = "0" + "/10"
                } else {
                    self.rating.text = String(snapshot.childSnapshot(forPath: "rating").value as! Double) + "/10"
                }
            }
        })
        
        refReviews = Database.database().reference().child("reviews").child(productID);
        var flag: Bool = false;
        refReviews.observe(DataEventType.value, with: { (snapshot) in
            self.reviewList.removeAll()
            if snapshot.childrenCount > 0 {
                if(!flag){
                    flag = true;
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
            }
        })
        
        company.text = ""
        var comp = productID.split(separator: "Ф").map(String.init)[1].split(separator: " ").map(String.init)
        for index in 0..<comp.endIndex - 1 {
            company.text = company.text! + comp[index] + " "
        }
        
    }
    
    @IBAction func onAddToWishList(_ sender: Any) {
        Database.database().reference().child("wishlists").child((Auth.auth().currentUser?.uid)!).updateChildValues([productID:"0"])
        let alert = UIAlertController(title: "", message: "Добавлен в вишлист", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onAddToCollection(_ sender: Any) {
        Database.database().reference().child("collections").child((Auth.auth().currentUser?.uid)!).updateChildValues([productID:"0"])
        let alert = UIAlertController(title: "", message: "Добавлен в мою косметичку", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
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
