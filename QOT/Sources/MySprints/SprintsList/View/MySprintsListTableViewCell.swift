//
//  MySprintsListTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 16/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MySprintsListTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    let skeletonManager = SkeletonManager()

    private lazy var reorderImage: UIImage? = {
        return UIImage.qot_reorderControlImage()
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(statusLabel)
        skeletonManager.addOtherView(progressLabel)
        skeletonManager.addOtherView(statusIcon)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            changeReorderControlImage()
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

    func set(title: String?, status: MySprintStatus?, description: String?, progress: String?) {
        guard let title = title, let sprintStatus = status else { return }
        selectionStyle = .default
        let selectedView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
        skeletonManager.hide()

        ThemeText.mySprintsCellTitle.apply(title, to: titleLabel)
        ThemeText.mySprintsCellStatus.apply(description, to: statusLabel)
        ThemeText.mySprintsCellProgress.apply(progress, to: progressLabel)
        statusIcon.image = image(for: sprintStatus)

        if case MySprintStatus.active = sprintStatus {
            ThemeView.sprintsActive.apply(contentView)
        } else {
            ThemeView.clear.apply(contentView)
        }
    }
}

// MARK: - Private methods

extension MySprintsListTableViewCell {
    private func image(for status: MySprintStatus) -> UIImage? {
        switch status {
        case .active:
            return R.image.my_sprints_active()
        case .upcoming:
            return R.image.my_sprints_upcoming()
        case .paused:
            return R.image.my_sprints_pending()
        case .completed:
            return R.image.my_sprints_completed()
        }
    }

    private func changeReorderControlImage() {
        guard let reorderImage = self.reorderImage else {
            return
        }

        for view in subviews where view.description.contains("Reorder") {
            for case let subview as UIImageView in view.subviews {
                subview.image = reorderImage
                subview.frame = CGRect(center: CGPoint(x: subview.center.x, y: self.frame.size.height/2.0), size: reorderImage.size)
            }
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
