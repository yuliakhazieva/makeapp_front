//
//  LeaveReviewViewController.swift
//  makeapp
//
//  Created by Yulia on 17.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LeaveReviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let ratings = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    var refReviews: DatabaseReference?
    var refProducts: DatabaseReference?
    var productId: String = ""
    var currentRating: String = "";
    var numOfReviews: Int = 0;
    var fin = false
    
    @IBAction func onSave(_ sender: Any) {
        refProducts = Database.database().reference().child("products")
        refProducts?.child(productId).observe(DataEventType.value, with: { (snapshot) in
            self.currentRating = String(describing:snapshot.childSnapshot(forPath: "rating").value)
            if(self.currentRating.contains("?")) {
                self.currentRating = "0"
            } else {
                self.currentRating = String(snapshot.childSnapshot(forPath: "rating").value as! Double)
            }
            self.numOfReviews = Int((snapshot.childSnapshot(forPath:"numReviews").value as! NSString).intValue)
            if(!self.fin) {
                let selecedRating = self.ratingPicker.selectedRow(inComponent: 0) + 1
                var newRating = (Double(self.currentRating)! * Double(self.numOfReviews) + Double(selecedRating)) / Double(self.numOfReviews + 1)
                self.refProducts?.child(self.productId).updateChildValues(["rating": newRating, "numReviews": String(self.numOfReviews + 1)])
                self.refReviews = Database.database().reference().child("reviews")
                let data = ["text": self.reviewText.text, "author": Auth.auth().currentUser?.uid, "rating": String(selecedRating)] as [String : Any]
                self.refReviews?.child(self.productId).childByAutoId().setValue(data)
                
                self.fin = true
            }
        })
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingPicker.delegate = self
        ratingPicker.dataSource = self
        self.reviewText.layer.borderWidth = 5.0
        self.reviewText.layer.borderColor = UIColor.purple.cgColor;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(ratings[row])
    }
    
    func setUp(productId: String) {
        self.productId = productId
        
    }
    
}
