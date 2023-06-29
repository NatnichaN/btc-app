//
//  CurrencyViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
import Alamofire

protocol CurrencyViewControllerDelegate: AnyObject {
    func fetchContentSucces(vc: CurrencyViewController)
    func fetchContentFailed(vc: CurrencyViewController)
}

class CurrencyViewController {
    
    var delegate: ViewControllerDelegate?
    var currency: Currency?
    init() {}

//    func currency() -> Currency {
//        return currency ?? nil
//    }
    
    func fetchData(){
    }
    
    func fetchContentSucces(vc: CurrencyViewController) {
        delegate?.reloadContentSucces(vc: vc)
    }
    
    func fetchContentFailed(vc: CurrencyViewController) {
        delegate?.reloadContentFailed(vc: vc)
    }
}
