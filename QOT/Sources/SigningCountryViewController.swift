//
//  SigningCountryViewController.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCountryViewController: AbstractFormViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var centerContentView: UIView!
    private var selectedCountry: String?
    private lazy var countryFormView: FormView? = formView()
    var interactor: SigningCountryInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SigningCountryViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension SigningCountryViewController {

    func setupFormView() {
        guard let formView = countryFormView else { return }
        formView.delegate = self
        centerContentView.addSubview(formView)
        formView.configure(formType: .country(""))
    }

    func update(formType: FormView.FormType?) {
        if formType?.value.isEmpty == true {
            activateButton(false)
            selectedCountry = nil
            interactor?.setSelectedCountry(countryName: "")
            tableView.reloadDataWithAnimation()
        }
    }
}

// MARK: - Actions

private extension SigningCountryViewController {

    @IBAction func didTapButton() {
        interactor?.didTapNext()
    }
}

// MARK: - SigningCountryViewControllerInterface

extension SigningCountryViewController: SigningCountryViewControllerInterface {

    func tableViewReloadData() {
        tableView.reloadDataWithAnimation()
    }

    func setup() {
        setupFormView()
        setupView(title: R.string.localized.signingCountryTitle(),
                  subtitle: R.string.localized.signingCountrySubtitle(),
                  bottomButtonTitle: R.string.localized.signingCountryBottomButtonTitle())
        tableView.registerDequeueable(SigningCountryTableViewCell.self)
    }

    override func endEditing() {
        countryFormView?.resetPlaceholderLabelIfNeeded()
        super.endEditing()
    }

    func hideErrorMessage() {
        countryFormView?.hideError()
    }

    func activateButton(_ active: Bool) {
        updateBottomButton(active)
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        if let message = errorMessage {
            countryFormView?.showError(message: message)
        }
        updateBottomButton(buttonActive)
    }
}

// MARK: - FormViewDelegate

extension SigningCountryViewController: FormViewDelegate {

    func didTapReturn(formType: FormView.FormType?) {
        countryFormView?.activateTextField(false)
        interactor?.didTapNext()
    }

    func didBeginEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
        update(formType: formType)
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }

    func didUpdateTextfield(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
        if formType?.value.isEmpty == true {
            update(formType: formType)
        } else {
            interactor?.setSelectedCountry(countryName: formType?.value ?? "")
            tableView.reloadDataWithAnimation()
            if interactor?.numberOfRows() == 0 {
                activateButton(false)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SigningCountryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = interactor?.country(at: indexPath) ?? ""
        let cell: SigningCountryTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(country: country, query: interactor?.countryQuery ?? "")
        if let selectedCountry = selectedCountry,
            selectedCountry.caseInsensitiveCompare(country) == .orderedSame,
            cell.accessoryType == .none {
                countryFormView?.configure(formType: .country(interactor?.countryQuery ?? ""))
                cell.accessoryType = .checkmark
                activateButton(true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = interactor?.country(at: indexPath) ?? ""
        if selectedCountry?.caseInsensitiveCompare(country) == .orderedSame {
            activateButton(false)
            selectedCountry = nil
            interactor?.setSelectedCountry(countryName: "")
            interactor?.updateWorkerValue(for: .country(""))
            countryFormView?.configure(formType: .country(""))
            countryFormView?.resetPlaceholderLabelIfNeeded()
            let cell = tableView.cellForRow(at: indexPath) as? SigningCountryTableViewCell
            cell?.configure(country: "", query: "")
        } else {
            let formType: FormView.FormType = .country(country)
            interactor?.setSelectedCountry(countryName: country)
            interactor?.updateWorkerValue(for: formType)
            selectedCountry = country
            endEditing()
        }
        tableView.reloadDataWithAnimation()
    }
}
