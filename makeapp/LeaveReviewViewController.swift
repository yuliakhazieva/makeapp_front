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
    var currentRating: Int = 0;
    var numOfReviews: Int = 0;
    
    @IBAction func onSave(_ sender: Any) {
        refReviews = Database.database().reference().child("reviews")
        let selecedRating = ratingPicker.selectedRow(inComponent: 0) + 1
        let data = ["text": reviewText.text, "author": Auth.auth().currentUser?.uid, "rating": String(selecedRating)] as [String : Any]
        refReviews?.child(productId).childByAutoId().setValue(data)
        var newRating = (currentRating * numOfReviews + selecedRating) / (numOfReviews + 1)
        refProducts?.child(productId).updateChildValues(["rating": newRating, "numReviews": numOfReviews + 1])
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
        refProducts?.child(productId).observe(DataEventType.value, with: { (snapshot) in
            self.currentRating = snapshot.childSnapshot(forPath: "rating").value as! Int
            self.numOfReviews = snapshot.childSnapshot(forPath: "numReviews").value as! Int
        })
    }
    
}
