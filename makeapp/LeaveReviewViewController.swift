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
    var productId: String = ""
    
    @IBAction func onSave(_ sender: Any) {
        refReviews = Database.database().reference().child("reviews")
        let data = ["text": reviewText.text, "author": Auth.auth().currentUser?.uid, "rating": String(ratingPicker.selectedRow(inComponent: 0))] as [String : Any]
        refReviews?.child(productId).childByAutoId().setValue(data)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingPicker.delegate = self
        ratingPicker.dataSource = self
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
