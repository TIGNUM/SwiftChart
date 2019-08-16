//
//  WhatsHotLatestCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotLatestCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var whatsHotImage: UIImageView!
    @IBOutlet private weak var whatsHotTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateAndDurationLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newLabel.isHidden = true
        backgroundColor = .carbon
    }


    func configure(with: WhatsHotLatestCellViewModel?) {
        whatsHotTitle.text = with?.title.uppercased()
        whatsHotImage.kf.setImage(with: with?.image, placeholder: R.image.preloading())
        authorLabel.text = with?.author
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: with?.publisheDate ?? Date()) + " | "  + "\((with?.timeToRead ?? Int(0.0) ) / 60)" + " min read"
        if with?.isNew == true { newLabel.isHidden = false }
    }

    func configure(with: WhatsHotLatestCellViewModel) {
        whatsHotTitle.text = with.title.uppercased()
        whatsHotImage.kf.setImage(with: with.image, placeholder: R.image.preloading())
        authorLabel.text = with.author
        //Code which Anais wrote
        //dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: publisheDate ?? Date(timeInterval: -3600, since: Date())) + " | "  + "\((timeToRead ?? 0) / 60)" + " min read"
        dateAndDurationLabel.text = DateFormatter.whatsHotBucket.string(from: with.publisheDate ) + " | "  + "\((with.timeToRead ) / 60)" + " min read"
        if with.isNew == true { newLabel.isHidden = false }
    }
}
