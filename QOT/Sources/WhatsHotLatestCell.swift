//
//  WhatsHotLatestCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotLatestCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var whatsHotImage: UIImageView!
    @IBOutlet private weak var whatsHotTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateAndDurationLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newLabel.isHidden = true
    }

    func configure(title: String?, image: URL?, author: String?, publisheDate: Date?, timeToRead: Int?, isNew: Bool, remoteID: Int?) {
        whatsHotTitle.text = title?.uppercased()
        whatsHotImage.kf.setImage(with: image, placeholder: R.image.preloading())
        authorLabel.text = author
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: publisheDate ?? Date(timeInterval: -3600, since: Date())) + " | "  + "\((timeToRead ?? 0) / 60)" + " min read"
        if isNew == true { newLabel.isHidden = false }
    }
}
