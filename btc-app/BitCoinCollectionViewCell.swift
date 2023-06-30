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
        configUI()
    }
    
    func configUI() {
        bgView.layer.cornerRadius = 15.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configContent(btcModel: BPIRate) {
        btcCodeLabel.text = btcModel.code.rawValue
        btcSymbolLabel.text = convertToCurrencySymbol(symbol: btcModel.symbol)
        btcRateLabel.text = btcModel.rate
        btcDescLabel.text = btcModel.description
    }
    
    func convertToCurrencySymbol(symbol: String) -> String {
        switch symbol {
        case "&#36;":
            return "$"
        case "&pound;":
            return "₤"
        case "&euro;":
            return "€"
        default:
            return ""
        }
    }
}
