//
//  NegativeToPositiveTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

final class NegativeToPositiveTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    private var negativeToPositiveView: NegativeToPositiveView?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        negativeToPositiveView = NegativeToPositiveView.instantiateMindsetView(superview: self, showSkeleton: true, darkMode: false)
    }


     // MARK: - Cell configuration

    func configure(title: String,
                   lowTitle: String,
                   lowItems: [String],
                   highTitle: String,
                   highItems: [String]) {
        negativeToPositiveView?.configure(title: title,
                                         lowTitle: lowTitle,
                                         lowItems: lowItems,
                                         highTitle: highTitle,
                                         highItems: highItems)
    }
}
