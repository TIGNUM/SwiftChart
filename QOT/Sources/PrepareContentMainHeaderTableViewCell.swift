//
//  PrepareContentMainHeaderTableViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher
import Anchorage

protocol PrepareContentMainHeaderTableViewCellDelegate: class {
    func didTapVideo(videoURL: URL?, cell: UITableViewCell)
}

class PrepareContentMainHeaderTableViewCell: UITableViewCell, Dequeueable {
    
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var previewImageView: UIButton!
    @IBOutlet weak var contentLabel: UILabel!

    weak var delegate: PrepareContentMainHeaderTableViewCellDelegate?
    var videoURL: URL?
    var previewImageURL: URL?
    var content: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor.blackTwo
    }
    
    func setCell(title: String, subTitle: String, contentText: String, videoPlaceholder: URL?, videoURL: URL?, isExpanded: Bool) {
        headerLabel.text = title.uppercased()
        subHeaderLabel.text = subTitle.uppercased()
        bottomSeparator.isHidden = isExpanded
        
        previewImageURL = videoPlaceholder
        content = contentText
        
        setExpandImageState(isExpanded: isExpanded)
        updateContent(isExpanded: isExpanded)
    }
    
    func updateContent(isExpanded: Bool) {
        contentLabel.isHidden = !isExpanded
        previewImageView.isHidden = !isExpanded

        if isExpanded {

            if let url = previewImageURL {
                previewImageView.kf.setImage(with: url, for: .normal)
                previewImageView.addTarget(self, action: #selector(PrepareContentMainHeaderTableViewCell.playVideo), for: .touchDown)
            } else {
                previewImageView.isHidden = true
            }

            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.prepareAndSetTextAttributes(text: content, font: UIFont(name: "BentonSans-Book", size: 16)!)            
        }
    }
    
    func setExpandImageState(isExpanded: Bool) {
        iconImageView.image = isExpanded ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()
    }
    
    func playVideo() {
        print("playVideo()")
        delegate?.didTapVideo(videoURL: videoURL, cell: self)
    }

}
