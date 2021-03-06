//
//  SearchViewController.swift
//  makeapp
//
//  Created by Yulia on 17.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit
import FlexColorPicker

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ColorPickerDelegate {
    
    var color:UIColor = UIColor.black
    
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        color = selectedColor
    }
    
    func colorPicker(_ colorPicker: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
        color = confirmedColor
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    
    @IBAction func onPickColor(_ sender: Any) {
        let colorPickerController = DefaultColorPickerViewController()
        colorPickerController.delegate = self as ColorPickerDelegate
        navigationController?.pushViewController(colorPickerController, animated: true)
    }
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var producer: UITextField!
    
    let categories = ["Eyeshadow", "Lipstick", "Lipgloss",
                      "Lip liner", "Highlighter", "Bronzer", "Foundation", "Concealer",
                      "Mascara", "Eyeliner", "Blush","Primer", "Powder", "Contouring",
                      "Eye pencil", "Pigment", "Glitter", "BB creme", "CC creme", "Brow"]
    
    @IBAction func onSearchClick(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "searchResult") as! SearchResultsViewController
        vc.setup(company: producer.text!, product: productName.text!, category: categories[categoryPicker.selectedRow(inComponent: 0)], color: color)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
