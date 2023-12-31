//
//  CurrencyViewModel.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
import ProgressHUD
protocol CurrencyViewModelDelegate: AnyObject {
    func fetchContentSuccess(vm: CurrencyViewModel)
    func fetchContentFailed(vm: CurrencyViewModel)
    func updateCurrencyOutput(vm: CurrencyViewModel)
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
    var bpiCodeList: [BPIType]? = []
    private var pollingTimer: Timer!
    let fetchInterval = 60.0
    var currentCurrencyUnit: BPIType? = .usa
    var btcCurrencyOutput: CGFloat = 0.0
    var btcCurrencyOutputText: String = "0.0"
    
    init() {
    }
    // MARK: - Cell
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
        guard let currencyModel = currency else {
            return .zero
        }
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = widthSize
        let header = R.nib.bitCoinFooterCollectionViewCell.firstView(withOwner: nil)!
        header.configContent(currencyModel: currencyModel)
        let size = header.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        return size
    }
    
    func manageBpiRateList() {
        bpiRateList?.removeAll()
        bpiCodeList?.removeAll()
        if let bpiItem = self.currency?.bpi {
            bpiRateList?.append(bpiItem.usd)
            bpiRateList?.append(bpiItem.gbp)
            bpiRateList?.append(bpiItem.eur)
            bpiCodeList?.append(bpiItem.usd.code)
            bpiCodeList?.append(bpiItem.gbp.code)
            bpiCodeList?.append(bpiItem.eur.code)
        }
    }
    // MARK: - Converter
    func numberOfItemInPicker() -> Int {
        return bpiCodeList?.count ?? 0
    }
    
    func convertCurrencyToBtc(inputValue: CGFloat) {
        var rateFloat: CGFloat
        switch currentCurrencyUnit {
        case .usa:
            rateFloat = currency?.bpi.usd.rateFloat ?? 1.0
        case .gbp:
            rateFloat = currency?.bpi.gbp.rateFloat ?? 1.0
        case .eur:
            rateFloat = currency?.bpi.eur.rateFloat ?? 1.0
        case .none:
            rateFloat = 1.0
        }
        let btc = inputValue / rateFloat
        btcCurrencyOutput = btc
        btcCurrencyOutputText = String(format: "%.4f", btc)
        delegate?.updateCurrencyOutput(vm: self)
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
            weakSelf.delegate?.fetchContentSuccess(vm: weakSelf)
            guard weakSelf.pollingTimer == nil else { return }
            weakSelf.initFetchScheduled()
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
