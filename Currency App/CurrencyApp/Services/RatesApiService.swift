//
//  RatesApiService.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import Foundation
import Alamofire

class RatesApiService {
    
    static let BASE_URL = "https://api.ratesapi.io/api/"
    
    static func getRates(base: String, completion: @escaping (RatesApiModel) -> Void){
        AF.request(BASE_URL + "latest?base=\(base)", method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let rates = try? jsonDecoder.decode(RatesApiModel.self, from: data) {
                    completion(rates)
                } else {
                    print("Decode Failed")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func getRatesBetweenDates(from: Date, to:Date, base: String, toConvert: String, completion: @escaping (Currency) -> Void){
        
        let datesBetweenArray = Date.dates(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, to: Date())
       
        for date in datesBetweenArray {
            AF.request(BASE_URL + "\(date.description.split(separator: " ").first!)?base=\(base)&symbols=\(toConvert)", method: .get).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    if let rates = try? jsonDecoder.decode(RatesApiModel.self, from: data) {
                        let currency = Currency(name: toConvert, rate: rates.rates[toConvert]!, abbreviation: toConvert)
                        print(currency)
                        completion(currency)
                    } else {
                        print("Decode Failed")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
       
        
    }
  
}
