//
//  NewDailyBriefGetStartedCollectionViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 04/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class NewDailyBriefGetStartedCollectionViewCell: UICollectionViewCell, Dequeueable {
    @IBOutlet weak var upperContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    let skeletonManager = SkeletonManager()
    @IBOutlet weak var completedIcon: UIImageView!

    private static let sizingCell = UINib(nibName: "NewDailyBriefGetStartedCollectionViewCell", bundle: nil).instantiate(withOwner: nil,
                                                                                                                         options: nil).first!
                                    as? NewDailyBriefGetStartedCollectionViewCell

    // MARK: - Actions
    @IBAction func didTapArrowButton(_ sender: Any) {

    }

    // MARK: - Public
    public func configure(with viewModel: NewDailyBriefGetStartedModel?) {
        guard let model = viewModel else {
            skeletonManager.addOtherView(upperContentView)
            skeletonManager.addOtherView(completedIcon)
            skeletonManager.addTitle(title)
            arrowButton.isHidden = true
            log("[DaiBriLOG: NewDailyBriefGetStartedCollectionViewCell] configure -> viewModel == nil; return ", level: .error)
            return
        }
        skeletonManager.hide()
        upperContentView.layer.borderWidth = 0.5
        upperContentView.layer.borderColor =  model.isCompleted == true ? UIColor.darkGrey.cgColor : UIColor.lightGray.cgColor
        arrowButton.isHidden = false
        title.text = model.title
        imageView.image = UIImage.init(named: model.image ?? String.empty)
        contentView.layer.opacity = model.isCompleted == true ? 0.6 : 1
        completedIcon.isHidden = model.isCompleted == false
    }

    public static func height(for viewModel: NewDailyBriefGetStartedModel, forWidth width: CGFloat) -> CGFloat {
        sizingCell?.prepareForReuse()
        sizingCell?.configure(with: viewModel)
        sizingCell?.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        guard let size = sizingCell?.contentView.systemLayoutSizeFitting(fittingSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow) else {
            return .zero
        }

        guard size.height < maximumHeight else {
            return maximumHeight
        }

        return size.height
    }
}
