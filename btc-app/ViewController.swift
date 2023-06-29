//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currencyModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyModel.delegate = self
        currencyModel.fetchData()
        registerCell()
    }
    
    func registerCell() {
//        collectionView.register(R.nib., forCellWithReuseIdentifier: <#T##String#>)
//        collectionView.register(R.nib.packageDetailHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
//        collectionView.register(R.nib.cancelPackageFooterView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyModel.numberOfItem()
    }
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    // MARK: - CurrencyViewModelDelegate
    func fetchContentSuccess(vc: CurrencyViewModel) {
        print("fetchContentSuccess")
    }
    
    func fetchContentFailed(vc: CurrencyViewModel) {
        print("fetchContentFailed")
    }
}

