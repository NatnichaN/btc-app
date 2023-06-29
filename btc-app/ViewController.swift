//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currencyVC = CurrencyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyVC.delegate = self
        currencyVC.fetchData()
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerView.frame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.titleLabel.text = currencyVC.currency?.chartName
        self.detailLabel.text = currencyVC.currency?.disclaimer
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "title \(indexPath.row)"
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    // MARK: - CurrencyViewControllerDelegate
    func fetchContentSuccess(vc: CurrencyViewController) {
        print("fetchContentSuccess")
        tableView.reloadData()
    }
    
    func fetchContentFailed(vc: CurrencyViewController) {
        print("fetchContentFailed")
    }
}

