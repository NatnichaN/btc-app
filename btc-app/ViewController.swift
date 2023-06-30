//
//  ViewController.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import UIKit
class ViewController: UIViewController, CurrencyViewModelDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private var picker: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var converterTitleLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var currencyUnitTextfield: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputUnitLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var converterView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var currencyModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyModel.delegate = self
        currencyModel.fetchData()
        registerCell()
        registNotiEvent()
        configUI()
        configContent()
    }
    
    func registerCell() {
        collectionView.register(R.nib.bitCoinCollectionViewCell)
        collectionView.register(R.nib.bitCoinHeaderCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(R.nib.bitCoinFooterCollectionViewCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
    
    func registNotiEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configUI() {
        converterView.isHidden = true
        converterView.layer.cornerRadius = 15.0
        converterView.layer.borderWidth = 1.0
        converterView.layer.borderColor = UIColor.lightGray.cgColor
        // Toolbar for inputTextfield
        let toolbarInput = UIToolbar()
        toolbarInput.tintColor = view.tintColor
        let confirmButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneInputTextField(sender:)))
        let cancelInputButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCanceInput(sender:)))
        let flexer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarInput.setItems([cancelInputButton, flexer, confirmButton], animated: false)
        toolbarInput.sizeToFit()
        
        inputTextfield.inputAccessoryView = toolbarInput
        // Toolbar for currencyUnitTextfield
        let toolbarPicker = UIToolbar()
        toolbarPicker.tintColor = view.tintColor
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton(sender:)))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton(sender:)))
        toolbarPicker.setItems([cancelButton, flexer, doneButton], animated: false)
        toolbarPicker.sizeToFit()

        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        currencyUnitTextfield.inputView = picker
        currencyUnitTextfield.inputAccessoryView = toolbarPicker
    }
    
    func configContent() {
        converterTitleLabel.text = "Converter"
        outputUnitLabel.text = "BTC"
        outputLabel.text = "0.0"
        confirmButton.setTitle("Convert", for: .normal)
        inputTextfield.placeholder = "Input amount for convert"
        currencyUnitTextfield.text = "USD"
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
        picker.selectRow(0, inComponent: 0, animated: true)
        guard converterView.isHidden else { return }
        converterView.isHidden = false
    }
    
    func fetchContentFailed(vm: CurrencyViewModel) {
        print("fetchContentFailed")
    }
    
    func updateCurrencyOutput(vm: CurrencyViewModel) {
        outputLabel.text = vm.btcCurrencyOutputText
    }
    //MARK: - Action
    @IBAction func didTapConvertButton(_ sender: UIButton) {
        guard inputTextfield.text != nil else { return }
        inputTextfield.endEditing(true)
        let inputValue = CGFloat((inputTextfield.text! as NSString).doubleValue)
        currencyModel.convertCurrencyToBtc(inputValue: inputValue)
    }
    
    // MARK:- Notification event
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
       let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraint.constant = keyboardHeight
        let endValue = info[UIResponder.keyboardFrameEndUserInfoKey]
        let durationValue = info[UIResponder.keyboardAnimationDurationUserInfoKey]
        let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey]
        // Transform the keyboard's frame into our view's coordinate system
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        // Find out how much the keyboard overlaps our scroll view
        let keyboardOverlap = collectionView.frame.maxY - endRect.origin.y

        collectionView.contentInset.bottom = keyboardOverlap
        collectionView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
        
        let duration = (durationValue as AnyObject).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
       let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        bottomConstraint.constant = 25
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension ViewController {
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
            // Get required info out of the notification
        if let scrollView = collectionView, let userInfo = notification.userInfo,
           let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
           let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
           let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
                
                // Transform the keyboard's frame into our view's coordinate system
                let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
                
                // Find out how much the keyboard overlaps our scroll view
                let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
                
                // Set the scroll view's content inset & scroll indicator to avoid the keyboard
                scrollView.contentInset.bottom = keyboardOverlap
                scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
                
                let duration = (durationValue as AnyObject).doubleValue
                let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
                UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
}
// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // reset to orignal amount
        textField.text = "0.0"
        return false
    }
    
    @objc func didTapCanceInput(sender: AnyObject) {
        inputTextfield.endEditing(true)
    }

    @objc func didTapDoneInputTextField(sender: AnyObject) {
        inputTextfield.endEditing(true)
        let inputValue = CGFloat((inputTextfield.text! as NSString).doubleValue)
        currencyModel.convertCurrencyToBtc(inputValue: inputValue)
    }
}
// MARK: - PickerCollectionReusableViewDelegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyModel.numberOfItemInPicker()
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
        currencyUnitTextfield.text = currencyModel.bpiCodeList?[selectedIndex].rawValue
        currencyModel.currentCurrencyUnit = currencyModel.bpiCodeList?[selectedIndex]
    }
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyCodeText = currencyModel.bpiCodeList?[row].rawValue
        return currencyCodeText
    }
}
