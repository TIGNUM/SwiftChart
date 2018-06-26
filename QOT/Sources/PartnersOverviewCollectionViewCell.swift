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
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var relationshipLabel: UILabel!
    @IBOutlet private weak var addPartnerLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    private var partner: Partner?
    private var interactor: PartnersOverviewInteractorInterface?
    private var partnerExist = true

    override func awakeFromNib() {
        super.awakeFromNib()
        shareButton.corner(radius: 20)
        contentView.corner(radius: 8)
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
                   partner: Partner,
                   interactor: PartnersOverviewInteractorInterface?) {
        self.partner = partner
        self.interactor = interactor
        if let name = name, let surname = surname, let relationship = relationship {
            setupPartner(name: name + " " + surname,
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

    func setupPartner(name: String, relationship: String, profileImage: URL?, shareStatus: String?) {
        relationshipLabel.isHidden = false
        addPartnerLabel.isHidden = true
        nameLabel.isHidden = false
        partnerExist = true
        let attributedButtonTitle = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellShareContent(),
                                                       letterSpacing: 1,
                                                       font: .bentonBookFont(ofSize: 16),
                                                       textColor: .white90,
                                                       alignment: .center)
        let attributedName = NSAttributedString(string: name,
                                                letterSpacing: -1.1,
                                                font: .simpleFont(ofSize: 20),
                                                lineSpacing: 2,
                                                textColor: .white,
                                                alignment: .left)
        let attributedRelationship = NSAttributedString(string: relationship,
                                                        letterSpacing: 2,
                                                        font: .bentonRegularFont(ofSize: 11),
                                                        textColor: .white60,
                                                        alignment: .left)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .selected)
        relationshipLabel.attributedText = attributedRelationship
        nameLabel.attributedText = attributedName
        if let imageURL = profileImage {
            profileImageView.kf.setImage(with: imageURL)
            initialsLabel.isHidden = true
        } else {
            initialsLabel.isHidden = false
            initialsLabel.attributedText = NSAttributedString(string: partner?.initials ?? "",
                                                              letterSpacing: 2,
                                                              font: .simpleFont(ofSize: 36),
                                                              lineSpacing: 2,
                                                              textColor: .white,
                                                              alignment: .center)
        }
    }

    func setupEmptyPartner() {
        partnerExist = false
        nameLabel.isHidden = true
        relationshipLabel.isHidden = true
        addPartnerLabel.isHidden = false
        initialsLabel.isHidden = true
        let attributedButtonTitle = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellAddPartner(),
                                                       letterSpacing: 1,
                                                       font: .bentonBookFont(ofSize: 16),
                                                       textColor: .white90,
                                                       alignment: .center)
        let addPartnerText = NSAttributedString(string: R.string.localized.meSectorMyWhyPartnersCellEmptyState(),
                                                letterSpacing: 0,
                                                font: .bentonBookFont(ofSize: 14),
                                                lineSpacing: 2,
                                                textColor: .white90,
                                                alignment: .left)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        shareButton.setAttributedTitle(attributedButtonTitle, for: .selected)
        addPartnerLabel.attributedText = addPartnerText
        profileImageView.image = R.image.placeholder_user()
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
