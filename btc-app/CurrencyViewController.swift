//
//  CurrencyViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation

protocol CurrencyViewControllerDelegate: AnyObject {
    func fetchContentSucces(vc: CurrencyViewController)
    func fetchContentFailed(vc: CurrencyViewController)
}

class CurrencyViewController {
    
    var delegate: CurrencyViewControllerDelegate?
    var currency: Currency?
    init() {}
    
    func fetchData(){
        APIManger.shared.coinDesk(success: { [weak self] (currency) in
            guard let strongSelf = self else {
                return
            }
            print("currency == \(currency)")
//            strongSelf.currency = currency
//            strongSelf.fetchContentSucces(vc: self)
        }, failure: { [weak self] error in
            print("\(error)")
        })
    }
}
