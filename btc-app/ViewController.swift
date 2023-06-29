//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewControllerDelegate {

    var currencyVC = CurrencyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyVC.delegate = self
        currencyVC.fetchData()
    }

    // MARK: - CurrencyViewControllerDelegate
    func fetchContentSucces(vc: CurrencyViewController) {
        print("fetchContentSucces")
    }
    
    func fetchContentFailed(vc: CurrencyViewController) {
        print("fetchContentFailed")
    }
}

