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
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configContent(btcModel: BPIRate) {
        bgView.layer.borderColor = UIColor.red.cgColor
        bgView.layer.borderWidth = 1.0
        bgView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        bgView.layer.cornerRadius = 15.0
        btcCodeLabel.text = btcModel.code.rawValue
        btcSymbolLabel.text = btcModel.symbol
        btcRateLabel.text = btcModel.rate
        btcDescLabel.text = btcModel.description
    }
}
