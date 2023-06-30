//
//  BitCoinCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btcCodeLabel: UILabel!
    @IBOutlet weak var btcSymbolLabel: UILabel!
    @IBOutlet weak var btcRateLabel: UILabel!
    @IBOutlet weak var btcDescLabel: UILabel!
    @IBOutlet weak var btcRateFloatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(btcModel: BPIRate?) {
        if let btcModel = btcModel {
            btcCodeLabel.text = btcModel.code.rawValue
            btcSymbolLabel.text = btcModel.symbol
            btcRateLabel.text = btcModel.rate
            btcDescLabel.text = btcModel.description
            btcRateFloatLabel.text = String(describing: btcModel.rateFloat)
        }
    }
}
