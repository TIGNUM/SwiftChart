//
//  PrepareContentMainHeaderTableViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

protocol PrepareContentMainHeaderTableViewCellDelegate: class {

    func didTapVideo(videoURL: URL?, cell: UITableViewCell)
}

final class PrepareContentMainHeaderTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var previewImageButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    weak var delegate: PrepareContentMainHeaderTableViewCellDelegate?
    var videoURL: URL?
    var previewImageURL: URL?
    var content: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        previewImageButton.layer.borderColor = UIColor.black30.cgColor
        previewImageButton.layer.borderWidth = 0.5
        previewImageButton.backgroundColor = .black30
        bottomSeparator.backgroundColor = .black30
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        previewImageButton.contentMode = .scaleAspectFill
    }
    
    func setCell(title: String, subTitle: String, contentText: String, videoPlaceholder: URL?, videoURL: URL?, isExpanded: Bool) {
        previewImageURL = videoPlaceholder
        self.videoURL = videoURL
        content = contentText
        iconImageView.isHidden = contentText.isEmpty && videoURL == nil
        setupLabels(title, subTitle)
        setExpandImageState(isExpanded: isExpanded)
        updateContent(isExpanded: isExpanded)
    }
    
    func updateContent(isExpanded: Bool) {
        if isExpanded == true {
            if let previewImageURL = previewImageURL, videoURL != nil {
                previewImageButton.kf.setBackgroundImage(with: previewImageURL,
                                                         for: .normal,
                                                         placeholder: R.image.preloading())
            } else {
                previewImageButton.isHidden = true
            }

            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.setAttrText(text: content, font: Font.DPText)
        }
    }
    
    func setExpandImageState(isExpanded: Bool) {
        iconImageView.image = isExpanded ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()
    }
}

// MARK: - Private

private extension PrepareContentMainHeaderTableViewCell {

    func setupLabels(_ title: String, _ subTitle: String) {
        headerLabel.addCharactersSpacing(spacing: 2, text: title, uppercased: true)
        headerLabel.font = Font.H1MainTitle
        headerLabel.textColor = .darkIndigo
        subHeaderLabel.addCharactersSpacing(spacing: 2, text: subTitle, uppercased: true)
        subHeaderLabel.font = Font.H7Title
        subHeaderLabel.textColor = .black30
    }
}

// MARK: - Actions

extension PrepareContentMainHeaderTableViewCell {

    @IBAction private func playVideo(_ sender: UIButton) {
        delegate?.didTapVideo(videoURL: videoURL, cell: self)
    }
}
