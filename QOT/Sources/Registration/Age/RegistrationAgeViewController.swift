//
//  RegistrationAgeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ageInputField: QotPlaceholderTextField!
    @IBOutlet private weak var ageRestrictionLabel: UILabel!
    private let lowerAgeBound = 18
    private let preselectedRow = 12
    private let ageRange = 100

    var interactor: RegistrationAgeInteractorInterface?

    lazy private var years: [String] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        let lowerBound = lowerAgeBound
        let upperBound = lowerAgeBound + ageRange

        var array = [String]()
        for year in lowerBound...upperBound {
            array.append("\(currentYear - year)")
        }
        return array
    }()

    lazy private var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .carbonNew
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    private lazy var createAccountButton: UIBarButtonItem = {
        let button = RoundedButton.barButton(title: interactor?.createButtonTitle ?? "",
                                             target: self,
                                             action: #selector(didTapCreateAccountButton))
        return button
    }()

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func didTapBackButton() {
        interactor?.didTapBack()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        createAccountButton.isEnabled = !(ageInputField.text?.isEmpty ?? true)
        return [createAccountButton]
    }
}

// MARK: - Private

private extension RegistrationAgeViewController {
}

// MARK: - Actions

private extension RegistrationAgeViewController {

    @objc func didTapCreateAccountButton() {
        guard let year = ageInputField.text else { return }
        interactor?.didTapNext(with: year)
    }
}

// MARK: - RegistrationAgeViewControllerInterface

extension RegistrationAgeViewController: RegistrationAgeViewControllerInterface {

    func setupView() {
        titleLabel.text = interactor?.title
        descriptionLabel.text = interactor?.descriptionText
        ageRestrictionLabel.text = interactor?.ageRestrictionText
        ageInputField.textField.inputView = yearPicker
        ageInputField.textField.tintColor = .clear
        ageInputField.delegate = self
    }
}

// MARK: - UIPickerViewDataSource

extension RegistrationAgeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
}

// MARK: - UIPickerViewDelegate

extension RegistrationAgeViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: years[row],
                                  attributes: [.font: UIFont.sfProtextRegular(ofSize: 24), .foregroundColor: UIColor.sand])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageInputField.text = years[row]
    }
}

extension RegistrationAgeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Handle invalid text (e.g. on paste)
        if let text = textField.text, Int(text) == nil {
            textField.text = nil
        }

        refreshBottomNavigationItems()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Initial load
        if let isEmpty = textField.text?.isEmpty, isEmpty == true {
            yearPicker.selectRow(preselectedRow, inComponent: 0, animated: false)
            textField.text = years[preselectedRow]
        }
    }
}
