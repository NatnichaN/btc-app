//
//  BitCoinFooterCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinFooterCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet weak var converterTitleLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var inputValueTextfield: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputUnitLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    var currencyData: Currency?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    func configUI() {
        bgView.layer.cornerRadius = 15.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        converterTitleLabel.text = "Converter"
        outputUnitLabel.text = "USA"
        confirmButton.setTitle("Convert", for: .normal)
    }
    
    func configContent(currencyModel: Currency) {
        currencyData = currencyModel
        updatedTimeLabel.text = "Latest updated on: \(String(describing: currencyData?.contentTimeStamp.updated))"
        convertCurrencyToBtc(currencyUnit: .eur, input: 30246.7848)
    }
    
    func updateOutputValue(outputText: String, currencyUnit: BPIType) {
        outputLabel.text = outputText
        outputUnitLabel.text = currencyUnit.rawValue
    }
    
    func convertCurrencyToBtc(currencyUnit: BPIType, input: CGFloat) {
        var rateFloat: CGFloat
        switch currencyUnit {
        case .usa:
            rateFloat = currencyData?.bpi.usd.rateFloat ?? 1.0
        case .gbp:
            rateFloat = currencyData?.bpi.usd.rateFloat ?? 1.0
        case .eur:
            rateFloat = currencyData?.bpi.usd.rateFloat ?? 1.0
        }
        let btc = input / rateFloat
        updateOutputValue(outputText: String(format: "%.4f", btc), currencyUnit: currencyUnit)
    }
}
