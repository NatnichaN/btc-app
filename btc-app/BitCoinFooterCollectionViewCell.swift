//
//  BitCoinFooterCollectionViewCell.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit

class BitCoinFooterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configContent(titleText: String) {
        titleLabel.text = titleText
    }
}
