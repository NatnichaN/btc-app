//
//  CurrencyViewModel.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
import ProgressHUD
protocol CurrencyViewModelDelegate: AnyObject {
    func fetchContentSuccess(vc: CurrencyViewModel)
    func fetchContentFailed(vc: CurrencyViewModel)
}

enum BPIType: String, Codable {
    case usa = "USD"
    case gbp = "GBP"
    case eur = "EUR"
}

class CurrencyViewModel {
    
    var delegate: CurrencyViewModelDelegate?
    var currency: Currency?
    var bpiRateList: [BPIRate]? = []
    private var pollingTimer: Timer!
    let fetchInterval = 60.0
    
    init() {
    }
    
    func numberOfItem() -> Int {
        return bpiRateList?.count ?? 0
    }
    
    func cellForItemAt(indexPath: IndexPath) -> BPIRate? {
        return bpiRateList?[indexPath.row] ?? nil
    }
    
    func sizeForItemAt(indexPath: IndexPath, widthSize: CGFloat) -> CGSize {
        guard self.numberOfItem() > 0 else {
            return .zero
        }
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = widthSize
        let cell = R.nib.bitCoinCollectionViewCell.firstView(withOwner: nil)!
        if let model = self.cellForItemAt(indexPath: indexPath) {
            cell.configContent(btcModel: model)
        }
        let size = cell.contentView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        return size
    }
    
    func referenceSizeForHeaderInSection(section: Int, widthSize: CGFloat) -> CGSize{
        guard let charNameText = currency?.chartName, let disclaimerText = currency?.disclaimer else {
            return .zero
        }
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = widthSize
        let header = R.nib.bitCoinHeaderCollectionViewCell.firstView(withOwner: nil)!
        header.configContent(charNameText: charNameText, disclaimerText: disclaimerText)
        let size = header.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        return size
    }
    
    func referenceSizeForFooterInSection(section: Int, widthSize: CGFloat) -> CGSize{
        guard let updatedTimeText = currency?.contentTimeStamp.updated else {
            return .zero
        }
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = widthSize
        let header = R.nib.bitCoinFooterCollectionViewCell.firstView(withOwner: nil)!
        header.configContent(updatedTimeText: updatedTimeText)
        let size = header.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        return size
    }
    
    func manageBpiRateList() {
        if bpiRateList!.count > 0 {
            bpiRateList?.removeAll()
        }
        if let bpiItem = self.currency?.bpi {
            bpiRateList?.append(bpiItem.usd)
            bpiRateList?.append(bpiItem.gbp)
            bpiRateList?.append(bpiItem.eur)
        }
    }
    // MAKR: - fetch data
    func initFetchScheduled() {
        pollingTimer = Timer.scheduledTimer(timeInterval: fetchInterval, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    }
    
    @objc func fetchData() {
        ProgressHUD.show()
        APIManger.shared.coinDesk(success: { [weak self] (currency) in
            ProgressHUD.dismiss()
            guard let weakSelf = self else { return }
            weakSelf.currency = currency
            weakSelf.manageBpiRateList()
            weakSelf.delegate?.fetchContentSuccess(vc: weakSelf)
            guard weakSelf.pollingTimer == nil else { return }
//            weakSelf.initFetchScheduled()
        }, failure: { [weak self] error in
            ProgressHUD.showFailed("\(error)")
            guard let weakSelf = self else { return }
            guard weakSelf.pollingTimer != nil else { return }
            weakSelf.resetTimer()
        })
    }
    
    func resetTimer() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
}
