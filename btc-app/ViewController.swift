//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
//protocol ViewControllerDelegate: AnyObject {
//    func reloadContentSucces(vc: CurrencyViewController)
//    func reloadContentFailed(vc: CurrencyViewController)
//}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CurrencyViewControllerDelegate {

    var currencyVC = CurrencyViewController()
    private var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    var model =  ["1", "2", "3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self, action: #selector(self.didPullToRefresh(control:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        currencyVC.delegate = self
        currencyVC.fetchData()
    }
    
    @objc func didPullToRefresh(control: UIRefreshControl) {
        currencyVC.fetchData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "title \(String(describing: self.model[indexPath.row]))"
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    // MARK: - CurrencyViewControllerDelegate
    func fetchContentSucces(vc: CurrencyViewController) {
        tableView.reloadData()
    }
    
    func fetchContentFailed(vc: CurrencyViewController) {
        print("reloadContentFailed")
    }
}

