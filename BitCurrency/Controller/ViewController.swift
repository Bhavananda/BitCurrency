//
//  ViewController.swift
//  BitCurrency
//
//  Created by Bhavananda das on 11/09/2023.
//  
//

import UIKit

class ViewController: UIViewController  {
    
    var coinManager = CoinManager()
    
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
    }
}
    
    // MARK: - CoinManagerDelegate
    
    extension ViewController: CoinManagerDelegate {
    
    func updateRate(currency: String, rate: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = rate
            self.currencyLabel.text = currency
        }
    }
      func didFailWithError(error: Error) {
            print(error)
    }
    }
    
    // MARK: - UIPickerViewDelegate
    
    extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    }
    
    



