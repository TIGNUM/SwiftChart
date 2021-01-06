//
//  BaseMyLibraryTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 01/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseMyLibraryTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var updateInfoLavel: UILabel!

    @IBOutlet weak var bottomVirticalSpace: NSLayoutConstraint!
    @IBOutlet weak var updateInfoLabelHeight: NSLayoutConstraint!

    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addSubtitle(updateInfoLavel)
        skeletonManager.addOtherView(icon)
        selectionStyle = .none
    }

    func configure() {
        skeletonManager.hide(.otherView)
        let selectedView = UIView()
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
        selectionStyle = .default
        ThemeTint.lightGrey.apply(icon)
    }

    override func layoutSubviews() {
        guard updateInfoLavel != nil else {
            super.layoutSubviews()
            return
        }
        let defaultLabelHeight: CGFloat = 14
        let expectedSize = updateInfoLavel.sizeThatFits(updateInfoLavel.frame.size)
        var expectedHeight: CGFloat = defaultLabelHeight
        if expectedSize.height > defaultLabelHeight {
            expectedHeight = expectedSize.height
        }
        if updateInfoLabelHeight.constant != expectedHeight {
            updateInfoLabelHeight.constant = expectedHeight
            setNeedsUpdateConstraints()
        }
        super.layoutSubviews()
    }
}

extension BaseMyLibraryTableViewCell {
    func setTitle(_ title: String?, read: Bool) {
        skeletonManager.hide(.title)
        guard let titleText = title else { return }
        ThemeText.myLibraryItemsItemName.apply(titleText.lowercased().capitalizingFirstLetter(), to: contentTitle)
    }

    func setInfoText(_ text: String?) {
        skeletonManager.hide(.subtitle)
        guard let info = text else { return }
        ThemeText.myLibraryItemsItemDescription.apply(info, to: infoText)
    }

    func setCreationInfoText(_ text: String?) {
        skeletonManager.hide(.subtitle)
        ThemeText.myLibraryItemsItemDescription.apply(text, to: updateInfoLavel)
        let defaultSpacing: CGFloat = 0
        let gapWhenCreatorInfoIsShowing: CGFloat = 24
        let verticalSpacing: CGFloat = text?.isEmpty == false ? gapWhenCreatorInfoIsShowing : defaultSpacing
        bottomVirticalSpace.constant = verticalSpacing
        setNeedsUpdateConstraints()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            setEditingAccesory(forState: false)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isEditing {
            setEditingAccesory(forState: selected)
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if isEditing {
            setEditingAccesory(forState: highlighted)
        }
    }

    private func setEditingAccesory(forState selected: Bool) {
        let image = selected ? R.image.ic_radio_selected_white() : R.image.ic_radio_unselected_white()
        for subViewA in self.subviews {
            if subViewA.classForCoder.description() == "UITableViewCellEditControl" {
                if let subViewB = subViewA.subviews.last {
                    if subViewB.isKind(of: UIImageView.classForCoder()) {
                        if let imageView = subViewB as? UIImageView {
                            imageView.contentMode = .scaleAspectFit
                            imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
