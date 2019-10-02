//
//  MySprintsListTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 16/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MySprintsListTableViewCell: UITableViewCell, Dequeueable {

    private static let gradientIdentifier = "MySprintsListTableViewCell.gradient"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    let skeletonManager = SkeletonManager()
    private var editingOverlay: UIView!

    private lazy var reorderImage: UIImage? = {
        return UIImage.qot_reorderControlImage()
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView

        editingOverlay = UIView()
        self.addSubview(editingOverlay)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(statusLabel)
        skeletonManager.addOtherView(progressLabel)
        skeletonManager.addOtherView(statusIcon)
    }

    func set(title: String?, status: MySprintStatus?, description: String?, progress: String?) {
        guard let title = title, let sprintStatus = status else { return }
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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editingOverlay.isHidden = !editing

        if editing {
            changeReorderControlImage()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        editingOverlay.frame = self.bounds

        removeGradient(from: editingOverlay)
        addGradient(to: editingOverlay)
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

    private func removeGradient(from view: UIView) {
        view.layer.sublayers?.forEach {
            if let name = $0.name, name == MySprintsListTableViewCell.gradientIdentifier {
                $0.removeFromSuperlayer()
            }
        }
    }

    private func addGradient(to view: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = MySprintsListTableViewCell.gradientIdentifier
        gradient.colors = [UIColor.carbonNew.withAlphaComponent(0).cgColor, UIColor.carbonNew.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.8, y: 1.0)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
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
}
