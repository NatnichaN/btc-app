//
//  BitCoinFooterCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinFooterCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configContent(currencyModel: Currency) {
        updatedTimeLabel.text = "Latest updated on: \(String(describing: currencyModel.contentTimeStamp.updated))"
    }
}
