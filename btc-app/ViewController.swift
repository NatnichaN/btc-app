//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewModelDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    private var picker: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var converterTitleLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var currencyUnitTextfield: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputUnitLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var currencyModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyModel.delegate = self
        currencyModel.fetchData()
        registerCell()
        configUI()
        configContent()
    }
    
    func registerCell() {
        collectionView.register(R.nib.bitCoinCollectionViewCell)
        collectionView.register(R.nib.bitCoinHeaderCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(R.nib.bitCoinFooterCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
    
    func configUI() {
        bgView.layer.cornerRadius = 15.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        let toolbar = UIToolbar()
        toolbar.tintColor = view.tintColor
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton(sender:)))
        let flexer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexer, doneButton], animated: false)
        toolbar.sizeToFit()

        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self

        currencyUnitTextfield.inputView = picker
        currencyUnitTextfield.inputAccessoryView = toolbar
    }
    
    func configContent() {
        converterTitleLabel.text = "Converter"
        outputUnitLabel.text = "BTC"
        confirmButton.setTitle("Done", for: .normal)
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyModel.numberOfItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return currencyModel.sizeForItemAt(indexPath: indexPath, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return currencyModel.referenceSizeForHeaderInSection(section: section, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return currencyModel.referenceSizeForFooterInSection(section: section, widthSize: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.bitCoinCollectionViewCell, for: indexPath)!
        if let model = currencyModel.cellForItemAt(indexPath: indexPath) {
            cell.configContent(btcModel: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let charNameText = currencyModel.currency?.chartName, let disclaimerText = currencyModel.currency?.disclaimer {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.bitCoinHeaderCell, for: indexPath)!
                header.configContent(charNameText: charNameText, disclaimerText: disclaimerText)
                return header
            } else {
                return UICollectionReusableView()
            }
        } else {
            if let currencyModel = currencyModel.currency {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.bitCoinFooterCell, for: indexPath)!
                footer.configContent(currencyModel: currencyModel)
                return footer
            } else {
                // Shouldn't happen
                return UICollectionReusableView()
            }
        }
    }
    // MARK: - CurrencyViewModelDelegate
    func fetchContentSuccess(vm: CurrencyViewModel) {
        print("fetchContentSuccess")
        collectionView.reloadData()
    }
    
    func fetchContentFailed(vm: CurrencyViewModel) {
        print("fetchContentFailed")
    }
    
    func updateCurrencyOutput(vm: CurrencyViewModel) {
        outputLabel.text = vm.btcCurrencyOutputText
    }
    // MARK: - PickerCollectionReusableViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    private func dismissPicker() {
        view.endEditing(true)
    }

    @objc func didTapCancelButton(sender: AnyObject) {
        dismissPicker()
    }

    @objc func didTapDoneButton(sender: AnyObject) {
        dismissPicker()
        let selectedIndex = picker.selectedRow(inComponent: 0)
//        inputUnitLabel.text = currencyModel.bpiCodeList?[selectedIndex].rawValue
        currencyModel.currentCurrencyUnit = currencyModel.bpiCodeList?[selectedIndex]
    }
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyCodeText = currencyModel.bpiCodeList?[row].rawValue
        return currencyCodeText
    }
}

