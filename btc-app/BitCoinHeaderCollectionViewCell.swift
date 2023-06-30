//
//  BitCoinHeaderCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configContent(titleText: String, detailText: String) {
        titleLabel.text = titleText
        detailLabel.text = detailText
    }
}
