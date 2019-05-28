//
//  ViewController.swift
//  SajRates
//
//  Created by muhammad salihu on 5/23/19.
//  Copyright © 2019 muhammad salihu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    
    
    //MARK: - VARIABLES
    struct Currencies: Decodable {
        var rates: [String:Double]
    }
    var myCurrency:[String] = []
    var myValues:[Double] = []
    
    
    //MARK: - UI Objects
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var output: UILabel!
    var activeCurrency: Double = 1
    
    
    
    //MARK: - CREATING PICKER VIEW
    //***************************************************************
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    
    

    //MARK: BUTTON PRESSED
    @IBAction func buttonPressed(_ sender: Any) {
        if textField.text != ""
        {
           var currencyValue = Int(activeCurrency)
            output.text = String(Int(textField.text!)! * currencyValue )
        }
        textField.resignFirstResponder()
    }
    
    //VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - NETWORKING
        //***************************************************************
        let jsonUrlString = "https://api.exchangeratesapi.io/latest?base=GBP"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resoponse, error) in
            guard let data = data else {return}
            
            
            
            
            //MARK: - JSON Parsing
            //***************************************************************
            do {
                let currency = try JSONDecoder().decode(Currencies.self, from: data)
                
                for (key,value) in currency.rates
                {
                    self.myCurrency.append(key)
                    self.myValues.append(value)
                }
            } catch let error {
                print (error)
            }
            self.pickerView.reloadAllComponents()
            }.resume()
    }
    
    
}

