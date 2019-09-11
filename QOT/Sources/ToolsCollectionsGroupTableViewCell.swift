//
//  ToolsCollectionsGroupTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 22.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsGroupTableViewCell: BaseToolsTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var mediaIconImageView: UIImageView!
    @IBOutlet private weak var counterView: UIView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var counterImageView: UIImageView!
    private var mediaURL: URL?
    private var title: String?
    private var remoteID: Int = 0
    private var categoryTitle = ""
    private var type = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        counterView.corner(radius: 20)
        counterLabel.corner(radius: counterLabel.bounds.size.width/2)
    }

    func configure(categoryTitle: String,
                   title: String,
                   timeToWatch: String,
                   mediaURL: URL?,
                   duration: Double,
                   remoteID: Int,
                   numberOfItems: Int,
                   type: String) {
        self.categoryTitle = categoryTitle
        self.mediaURL = mediaURL
        self.title = title
        self.remoteID = remoteID
        self.type = type
        ThemeText.qotTools.apply(title.uppercased(), to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply( "\(numberOfItems)" + " items", to: detailLabel)
        mediaIconImageView.image = R.image.ic_group_grey()
        counterLabel.attributedText = NSAttributedString(string: "\(numberOfItems)",
                                                       letterSpacing: 0.4,
                                                       font: .apercuMedium(ofSize: 12),
                                                       textColor: .carbon,
                                                       alignment: .center)
    }
}

class BaseToolsTableViewCell: UITableViewCell {

    private let topLineTag = 0985674
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeTopLine()
    }

    func addTopLine(for row: Int) {
        if row == 0 { return }
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        line.tag = topLineTag
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ThemeView.toolSeparator.apply(line)
        addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1))
        addConstraint(NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 24))
    }

    func removeTopLine() {
        if let line = viewWithTag(topLineTag) {
            line.removeFromSuperview()
        }
    }
}
