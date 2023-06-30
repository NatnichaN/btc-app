//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewModelDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        collectionView.register(R.nib.bitCoinCollectionViewCell)
        collectionView.register(R.nib.bitCoinHeaderCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(R.nib.bitCoinFooterCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyModel.numberOfItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return currencyModel.sizeForItemAt(indexPath: indexPath, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return currencyModel.referenceSizeForHeaderInSection(section: section, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return currencyModel.referenceSizeForFooterInSection(section: section, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.bitCoinCollectionViewCell, for: indexPath)!
        if let model = currencyModel.cellForItemAt(indexPath: indexPath) {
            cell.configContent(btcModel: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let charNameText = currencyModel.currency?.chartName, let disclaimerText = currencyModel.currency?.disclaimer {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.bitCoinHeaderCell, for: indexPath)!
                header.configContent(charNameText: charNameText, disclaimerText: disclaimerText)
                return header
            } else {
                return UICollectionReusableView()
            }
        } else {
            if let updatedTimeText = currencyModel.currency?.contentTimeStamp.updated {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.bitCoinFooterCell, for: indexPath)!
                footer.configContent(updatedTimeText: updatedTimeText)
                return footer
            } else {
                // Shouldn't happen
                return UICollectionReusableView()
            }
        }
    }
    // MARK: - CurrencyViewModelDelegate
    func fetchContentSuccess(vc: CurrencyViewModel) {
        print("fetchContentSuccess")
        collectionView.reloadData()
    }
    
    func fetchContentFailed(vc: CurrencyViewModel) {
        print("fetchContentFailed")
    }
}

