//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
protocol ViewControllerDelegate: AnyObject {
    func reloadContentSucces(vc: CurrencyViewController)
    func reloadContentFailed(vc: CurrencyViewController)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerDelegate {
    
    weak var delegate: ViewControllerDelegate?
    var currencyVC = CurrencyViewController()
    private var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    var model =  ["1", "2", "3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyVC.delegate = self
//        currencyVC.fetchData()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell")!
        cell.textLabel?.text = "cell \(String(describing: self.model[indexPath.row]))"
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    // MARK: - ViewControllerDelegate
    func reloadContentSucces(vc: CurrencyViewController) {
        tableView.reloadData()
    }
    
    func reloadContentFailed(vc: CurrencyViewController) {
        print("reloadContentFailed")
    }
}

