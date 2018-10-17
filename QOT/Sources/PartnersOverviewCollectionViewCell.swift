//
//  PartnersOverviewCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersOverviewCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var bottomContentView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var shareStatusView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var relationshipLabel: UILabel!
    @IBOutlet private weak var addPartnerLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    private var partner: Partners.Partner?
    private var interactor: PartnersOverviewInteractorInterface?
    private var partnerExist = true

    override func awakeFromNib() {
        super.awakeFromNib()
        shareButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        contentView.corner(radius: Layout.CornerRadius.eight.rawValue)
        bottomContentView.backgroundColor = .battleshipGrey30
        shareStatusView.applyHexagonMask()
        shareStatusView.isHidden = true
        addPartnerLabel.isHidden = true
    }

    func configure(name: String?,
                   surname: String?,
                   relationship: String?,
                   profileImage: URL?,
                   shareStatus: String?,
                   partner: Partners.Partner,
                   interactor: PartnersOverviewInteractorInterface?) {
        self.partner = partner
        self.interactor = interactor
        if let name = name, let surname = surname, let relationship = relationship {
            setupPartner(name: name,
                         lastName: surname,
                         relationship: relationship,
                         profileImage: profileImage,
                         shareStatus: shareStatus)
        } else {
            setupEmptyPartner()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupEmptyPartner()
    }
}

// MARK: - Private

private extension PartnersOverviewCollectionViewCell {

    func setupPartner(name: String, lastName: String, relationship: String, profileImage: URL?, shareStatus: String?) {
        relationshipLabel.isHidden = false
        addPartnerLabel.isHidden = true
        nameLabel.isHidden = false
        lastNameLabel.isHidden = false
        partnerExist = true
        let attributedButtonTitle = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellShareContent(),
                                                       letterSpacing: 1,
                                                       font: .H5SecondaryHeadline,
                                                       textColor: .white90,
                                                       alignment: .center)
        let attributedName = NSAttributedString(string: name.uppercased(),
                                                letterSpacing: -1.1,
                                                font: .H4Headline,
                                                lineSpacing: 2,
                                                textColor: .white,
                                                alignment: .left)
        let attributedLastName = NSAttributedString(string: lastName.uppercased(),
                                                letterSpacing: -1.1,
                                                font: .H4Headline,
                                                lineSpacing: 2,
                                                textColor: .white,
                                                alignment: .left)
        let attributedRelationship = NSAttributedString(string: relationship.uppercased(),
                                                        letterSpacing: 2,
                                                        font: .H7Tag,
                                                        textColor: .white60,
                                                        alignment: .left)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .selected)
        relationshipLabel.attributedText = attributedRelationship
        nameLabel.attributedText = attributedName
        lastNameLabel.attributedText = attributedLastName
        profileImageView.kf.setImage(with: profileImage, placeholder: R.image.placeholder_partner())
        initialsLabel.isHidden = (profileImage != nil)
        initialsLabel.attributedText = NSAttributedString(string: partner?.initials ?? "",
                                                          letterSpacing: 2,
                                                          font: .H1MainTitle,
                                                          lineSpacing: 2,
                                                          textColor: .white,
                                                          alignment: .center)
    }

    func setupEmptyPartner() {
        partnerExist = false
        nameLabel.isHidden = true
        lastNameLabel.isHidden = true
        relationshipLabel.isHidden = true
        addPartnerLabel.isHidden = false
        initialsLabel.isHidden = true
        let attributedButtonTitle = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellAddPartner(),
                                                       letterSpacing: 1,
                                                       font: .DPText,
                                                       textColor: .white90,
                                                       alignment: .center)
        let addPartnerText = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellEmptyState(),
                                                letterSpacing: 0,
                                                font: .DPText3,
                                                lineSpacing: 2,
                                                textColor: .white90,
                                                alignment: .left)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .selected)
        addPartnerLabel.attributedText = addPartnerText
        profileImageView.kf.setImage(with: partner?.imageURL, placeholder: R.image.placeholder_partner())
    }
}

// MARK: - Actions

private extension PartnersOverviewCollectionViewCell {

    @IBAction func didTapButton() {
        guard let partner = partner else { return }
        if partnerExist == true {
            interactor?.didTapShare(partner: partner)
        } else {
            interactor?.addPartner(partner: partner)
        }
    }
}
