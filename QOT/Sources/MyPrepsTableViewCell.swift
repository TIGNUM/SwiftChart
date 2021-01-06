//
//  MyPrepsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var subtitleView: UIView!

    var skeletonManager = SkeletonManager()
    var hasData = false
    var hasEvent = false

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        skeletonManager.addOtherView(calendarIcon)
        ThemeView.level3.apply(self)
        setSelectedColor(.clear, alphaComponent: 1)
        hasData = false
        selectionStyle = .none
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

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: Configure
    func configure(title: String?, subtitle: String?) {
        guard let titleText = title else { return }
        hasData = true
        selectionStyle = .gray
        skeletonManager.hide()
        ThemeText.myQOTPrepCellTitle.apply(titleText, to: titleLabel)
        ThemeText.datestamp.apply(subtitle, to: subtitleLabel)
    }
}

// MARK: - Private methods
extension MyPrepsTableViewCell {
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
