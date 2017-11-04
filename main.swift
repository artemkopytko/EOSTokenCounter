//
//  main.swift
//  EOS Calculator
//
//  Created by Артем Копытько on 11/3/17.
//  Copyright © 2017 Artem Kopytko. All rights reserved.
//

import Foundation


func Main() {
    var distributionAmout: Double = 2000000;
    var myContribution: Double = 1;
    var totalContribution: Double = 1;
    var result: Double = 0.0;
    struct EthereumPrice: Decodable {
        let EUR: Double;
        let USD: Double;
    }
    
    var etherPriceUSD: Double = 0.0;
    var etherPriceEUR: Double = 0.0;
    
    let jsonUrlStrinng = "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,EUR"
    
    guard let url = URL(string: jsonUrlStrinng) else {
        return
    }
    
    func setParam(Parameter parameter: String, Value value:Double) -> Void {
        switch parameter {
        case "myContribution":
            myContribution = value;
        case "totalContribution":
            totalContribution = value;
        case "distributionAmout":
            distributionAmout = value*1000000;
        default:
            print("Error occured. Exiting...");
            exit(0);
        }
    }
    
    func getEthereumPrice(withRequest request: URL, withCompletion completion: @escaping(EthereumPrice?, Error?) -> Void){
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let ethereumPrice = try JSONDecoder().decode(EthereumPrice.self, from: data)
                etherPriceUSD = ethereumPrice.USD
                completion(ethereumPrice, nil)
            } catch let jsonError {
                print("Error serializing json", jsonError)
                completion(nil, jsonError)
            }
            }.resume()
    }
    
    getEthereumPrice(withRequest: url, withCompletion: { ethereumPrice, error in
        if error != nil {
            return
        } else if let ethereumPrice = ethereumPrice {
            etherPriceEUR = ethereumPrice.EUR
            etherPriceUSD = ethereumPrice.USD
        }
    })
    repeat {
        getEthereumPrice(withRequest: url, withCompletion: { ethereumPrice, error in
            if error != nil {
            } else if let ethereumPrice = ethereumPrice {
                etherPriceEUR = ethereumPrice.EUR
                etherPriceUSD = ethereumPrice.USD
            }
        })
    print("Enter your contribution(ETH): ", terminator: "");
    if let myCont = readLine() {
        setParam(Parameter: "myContribution", Value: Double(myCont)!);
    }
    print("Enter total contribution(ETH): ", terminator: "");
    if let totCont = readLine() {
        setParam(Parameter: "totalContribution",Value: Double(totCont)!);
    }
    print("Enter total EOS amout(millions): ", terminator: "");
    if let distibAmout = readLine() {
        setParam(Parameter: "distributionAmout",Value: Double(distibAmout)!);
    }
    result = Double(myContribution * ( distributionAmout / totalContribution ));
    print("You'll get \(result) EOS tokens");
    print("1 EOS costs: $\(etherPriceUSD/result)")
    print("1 EOS costs: €\(etherPriceEUR/result)")
        print("One more test? y/n")
    } while (readLine() != "n")
}

Main()

//import WebKit
// Getting total number of ETH being contributed
//let eosUrlString = "https://eos.io/"
//guard let eosUrl = URL(string: eosUrlString) else {
//    return
//}
// func getEOS_TotalContribution(withRequest request: URL, withCompletion completion: @escaping(String?, Error?) -> Void){
//URLSession.shared.dataTask(with: request) { data, response, error in
//    guard let data = data else {
//        completion(nil, error)
//        return
//    }
//    do {
//
//    } catch {
//
//    }
//    }.resume()
//}
//do {
//    let myHTMLString = try String(contentsOf: eosUrl, encoding: .utf8)
//
//    print("HTML : \(myHTMLString)")
//    let range = myHTMLString.range(of: "(?<=<div class=\"eth-received count\">)[^.]+(?=</div>)", options: .regularExpression)
//    if range != nil {
//        let found = myHTMLString.substring(with: range!)
//        print("found: \(found)") // found: google
//    }
//} catch let error {
//    print("Error: \(error)")
//}




