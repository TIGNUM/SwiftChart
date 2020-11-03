//
//  NewDailyBriefCollectionViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 03/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

let maximumHeight: CGFloat = 1000.0

class NewDailyBriefCollectionViewCell: UICollectionViewCell, Dequeueable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var arrowButton: UIButton!

    private static let sizingCell = UINib(nibName: "NewDailyBriefCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first! as? NewDailyBriefCollectionViewCell

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Actions
    @IBAction func didTapArrowButton(_ sender: Any) {

    }

    // MARK: - Public
    public func configure(with viewModel: NewBaseDailyBriefModel?) {
        caption.text = viewModel?.caption
        title.text = viewModel?.title
        body.text = viewModel?.body
        imageView.kf.setImage(with: URL.init(string: viewModel?.image ?? ""))
    }

    public static func height(for viewModel: NewBaseDailyBriefModel, forWidth width: CGFloat) -> CGFloat {
        sizingCell?.prepareForReuse()
        sizingCell?.configure(with: viewModel)
        sizingCell?.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        guard let size = sizingCell?.contentView.systemLayoutSizeFitting(fittingSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow) else {
            return 0
        }

        guard size.height < maximumHeight else {
            return maximumHeight
        }

        return size.height
    }
}
