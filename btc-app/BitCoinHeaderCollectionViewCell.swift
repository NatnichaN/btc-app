//
//  BitCoinHeaderCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var charNameLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configContent(charNameText: String, disclaimerText: String) {
        charNameLabel.text = charNameText
        disclaimerLabel.text = disclaimerText
    }
}
