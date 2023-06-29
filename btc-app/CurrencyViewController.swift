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
    private var pollingTimer: Timer!
    let fetchInterval = 60.0
    
    init() {
    }
    
    func initFetchScheduled() {
        pollingTimer = Timer.scheduledTimer(timeInterval: fetchInterval, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    }
    
    @objc func fetchData() {
        APIManger.shared.coinDesk(success: { [weak self] (currency) in
            guard let weakSelf = self else { return }
            weakSelf.currency = currency
            print("lasted update time:  \(currency.contentTimeStamp.updated)")
            weakSelf.delegate?.fetchContentSucces(vc: weakSelf)
            guard weakSelf.pollingTimer == nil else { return }
            weakSelf.initFetchScheduled()
        }, failure: { [weak self] error in
            print("\(error)")
            guard let weakSelf = self else { return }
            guard weakSelf.pollingTimer != nil else { return }
            weakSelf.resetTimer()
        })
    }
    
    func resetTimer() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
}
