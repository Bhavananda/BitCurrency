//
//  CoinManager.swift
//  BitCurrency
//
//  Created by Bhavananda das on 11/09/2023.
//

import Foundation

protocol CoinManagerDelegate {
    func updateRate(currency: String, rate: String )
    func didFailWithError(error: Error)
}



struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4EF0523F-6F4E-4C5D-B393-EFE5E294927B"
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLsession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.updateRate(currency: currency, rate: priceString)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastprice = decodedData.rate
            
            return lastprice
            
        }   catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
}

