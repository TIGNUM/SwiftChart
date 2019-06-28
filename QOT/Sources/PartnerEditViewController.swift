//
//  PartnerEditViewController.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var imageLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var formContainerView: UIView!
    @IBOutlet private weak var firstNameFormContentView: UIView!
    @IBOutlet private weak var lastNameFormContentView: UIView!
    @IBOutlet private weak var relationshipFormContentView: UIView!
    @IBOutlet private weak var emailFormContentView: UIView!
    @IBOutlet private weak var deleteButton: UIButton!
    private lazy var firstNameFormView = formView()
    private lazy var lastNameFormView = formView()
    private lazy var relationshipFormView = formView()
    private lazy var emailFormView = formView()
    private var partnerFirstName: String?
    private var partnerLastName: String?
    private var partnerRelationship: String?
    private var partnerEmail: String?
    private var partner: Partners.Partner?
    private var tempImage: UIImage?
    private var layoutConstraintMultiplier = CGFloat(-1)
    private let keyboardListener = KeyboardListener()
    var interactor: PartnerEditInteractorInterface?

    private var formViewHeight: CGFloat {
        return firstNameFormContentView.frame.height
    }

    // MARK: - Init

    init(configure: Configurator<PartnerEditViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardListener.startObserving()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardListener.stopObserving()
    }
}

// MARK: - Private

private extension PartnerEditViewController {

    func formView() -> FormView? {
        return R.nib.formView.instantiate(withOwner: nil).first as? FormView
    }

    func setupFormViews(_ partner: Partners.Partner?) {
        guard
            let formFirstName = firstNameFormView,
            let formLastName = lastNameFormView,
            let formRelationship = relationshipFormView,
            let formEmail = emailFormView else { return }
        formFirstName.delegate = self
        formLastName.delegate = self
        formRelationship.delegate = self
        formEmail.delegate = self
        firstNameFormContentView.addSubview(formFirstName)
        lastNameFormContentView.addSubview(formLastName)
        relationshipFormContentView.addSubview(formRelationship)
        emailFormContentView.addSubview(formEmail)
        firstNameFormContentView.backgroundColor = .clear
        lastNameFormContentView.backgroundColor = .clear
        relationshipFormContentView.backgroundColor = .clear
        emailFormContentView.backgroundColor = .clear
        formFirstName.configure(formType: .firstName(partner?.name ?? ""))
        formLastName.configure(formType: .lastName(partner?.surname ?? ""))
        formRelationship.configure(formType: .relationship(partner?.relationship ?? ""))
        formEmail.configure(formType: .email(partner?.email ?? ""))
    }

    func setupImageView() {
        profileImageView.kf.setImage(with: partner?.imageURL)
        imageContainerView.backgroundColor = .black60
        imageContainerView.withGradientBackground()
        updateImageContainerView(tempImage)
    }

    func setupNavigationItems() {
        let leftButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        leftButton.tintColor = .white30
        navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
        rightButton.tintColor = .white30
        navigationItem.rightBarButtonItem = rightButton
    }

    func editImageTitle() -> String {
        let imageExist = partner?.imageURL != nil || tempImage != nil
        return imageExist == true ?  R.string.localized.meSectorMyWhyPartnersChangePhoto() : R.string.localized.meSectorMyWhyPartnersAddPhoto()
    }
}

// MARK: - Actions

private extension PartnerEditViewController {

    @IBAction func didTapImageButton() {
        interactor?.showImagePicker()
        endEditing()
    }

    @IBAction func didTapDeleteButton() {
        interactor?.didTapDelete(partner: partner)
        endEditing()
    }

    @objc func didTapCancel() {
        interactor?.didTapCancel()
        endEditing()
    }

    @objc func didTapSave() {
        endEditing()
        updatePartner()
        interactor?.didTapSave(partner: partner, image: tempImage)
    }

    @objc func endEditing() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.view.endEditing(true)
        })
    }

    func updatePartner() {
        partner?.name = partnerFirstName
        partner?.surname = partnerLastName
        partner?.relationship = partnerRelationship
        partner?.email = partnerEmail
    }

    func updateImageContainerView(_ tempImage: UIImage?) {
        if tempImage != nil {
            profileImageView.image = tempImage
        }
        imageLabel.attributedText = NSMutableAttributedString(string: editImageTitle(),
                                                              letterSpacing: 0.8,
                                                              font: .apercuLight(ofSize: 16),
                                                              textColor: .white90,
                                                              alignment: .center)
    }

    func updateFormViewConstraints() {
        let keyboardHeight = keyboardListener.state.height
        topLayoutConstraint.constant = keyboardHeight == 0 ? 0 : (formViewHeight * layoutConstraintMultiplier)
        bottomLayoutConstraint.constant = keyboardHeight == 0 ? 0 : -(formViewHeight * layoutConstraintMultiplier)
        UIView.animate(withDuration: 0.75) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.updateConstraints()
        }
    }

    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - PartnerEditViewControllerInterface

extension PartnerEditViewController: PartnerEditViewControllerInterface {

    func reload(partner: Partners.Partner) {
        self.partner = partner
    }

    func setupView(partner: Partners.Partner, isNewPartner: Bool) {
        self.partner = partner
        partnerFirstName = partner.name
        partnerLastName = partner.surname
        partnerRelationship = partner.relationship
        partnerEmail = partner.email
        deleteButton.isHidden = (isNewPartner == true)
        setupNavigationItems()
        setupImageView()
        setupFormViews(partner)
        addGestureRecognizer()
        keyboardListener.onStateChange { [weak self] _ in
            self?.updateFormViewConstraints()
        }
    }

    func dismiss() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImagePickerControllerDelegate

extension PartnerEditViewController: ImagePickerControllerAdapterProtocol {

}

extension PartnerEditViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        updateImageContainerView(tempImage)
        refreshBottomNavigationItems()
    }

    func cancelSelection() {
        // Do nothing.
        refreshBottomNavigationItems()
    }
}

// MARK: - FormViewDelegate

extension PartnerEditViewController: FormViewDelegate {

    func didUpdateTextfield(formType: FormView.FormType?) {}

    func didTapReturn(formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .firstName: lastNameFormView?.activateTextField(true)
        case .lastName: relationshipFormView?.activateTextField(true)
        case .relationship: emailFormView?.activateTextField(true)
        case .email: emailFormView?.activateTextField(false)
        default: return
        }
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .firstName: partnerFirstName = formType.value
        case .lastName: partnerLastName = formType.value
        case .relationship: partnerRelationship = formType.value
        case .email: partnerEmail = formType.value
        default: return
        }
    }

    func didBeginEditingTextField(formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .firstName: layoutConstraintMultiplier = -1
        case .lastName: layoutConstraintMultiplier = -2
        case .relationship: layoutConstraintMultiplier = -3
        case .email: layoutConstraintMultiplier = -4
        default: return
        }
        updateFormViewConstraints()
    }
}
