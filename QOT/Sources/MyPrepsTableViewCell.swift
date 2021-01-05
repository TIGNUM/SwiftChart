//
//  MyPrepsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsTableViewCell: UITableViewCell, Dequeueable {

    private static let gradientIdentifier = "MyPrepsTableViewCell.gradient"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var subtitleView: UIView!

    private var editingOverlay: UIView!
    var skeletonManager = SkeletonManager()
    var hasData = false
    var hasEvent = false

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        editingOverlay = UIView()
        self.addSubview(editingOverlay)
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
        editingOverlay.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        editingOverlay.frame = self.bounds

        removeGradient(from: editingOverlay)
        addGradient(to: editingOverlay)
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
    private func removeGradient(from view: UIView) {
        view.layer.sublayers?.forEach {
            if let name = $0.name, name == MyPrepsTableViewCell.gradientIdentifier {
                $0.removeFromSuperlayer()
            }
        }
    }

    private func addGradient(to view: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = MyPrepsTableViewCell.gradientIdentifier
        gradient.colors = [UIColor.carbonNew.withAlphaComponent(0).cgColor, UIColor.carbonNew.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.8, y: 1.0)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}
