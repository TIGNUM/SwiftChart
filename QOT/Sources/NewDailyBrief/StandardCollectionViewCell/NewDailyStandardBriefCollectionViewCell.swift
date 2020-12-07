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

class NewDailyStandardBriefCollectionViewCell: UICollectionViewCell, Dequeueable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    let skeletonManager = SkeletonManager()
    var disabledHighlightedAnimation = false
    public var hideCTAButton = true
    private static let sizingCell = UINib(nibName: "NewDailyStandardBriefCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first! as? NewDailyStandardBriefCollectionViewCell

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Actions
    @IBAction func didTapArrowButton(_ sender: Any) {

    }

    // MARK: - Public
    public func configure(with viewModel: NewDailyBriefStandardModel?) {
        guard let model = viewModel else {
            skeletonManager.addTitle(title)
            skeletonManager.addSubtitle(caption)
            skeletonManager.addOtherView(body)
            skeletonManager.addOtherView(body)
            skeletonManager.addOtherView(imageView)
            arrowButton.isHidden = true
            return
        }
        caption.text = model.caption
        title.attributedText = model.attributedTitle
        ThemeText.bodyText.apply(model.body, to: body)
        imageView.kf.setImage(with: URL.init(string: model.image ?? ""))
        arrowButton.isHidden = (model.detailsMode ?? false) && hideCTAButton
        body.numberOfLines = (model.detailsMode ?? false) ? ((model.isInAnimationTransition ?? false) ? model.numberOfLinesForBody : 0) : model.numberOfLinesForBody
        titleTrailingConstraint.constant = 20
        caption.textColor = UIColor(hex: model.titleColor ?? "")
        skeletonManager.hide()
        var CTAIcon = UIImage.init(named: "diagonal arrow")

        switch viewModel?.CTAType {
        case .audio:
            CTAIcon = UIImage.init(named: "ic_audio")
        case .video:
            CTAIcon = UIImage.init(named: "ic_camera_tools")
        default:
            break
        }

        arrowButton.setImage(CTAIcon, for: .normal)
        arrowButton.imageView?.tintColor = .white
    }

    public func resetTransform() {
        transform = .identity
    }

    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }

    public static func height(for viewModel: NewDailyBriefStandardModel, forWidth width: CGFloat) -> CGFloat {
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

    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        let animationOptions: UIView.AnimationOptions = GlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard
        ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: GlobalConstants.cardHighlightedFactor, y: GlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}
