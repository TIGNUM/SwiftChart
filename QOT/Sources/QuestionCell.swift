//
//  QuestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionCell: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        baseHeaderView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with viewModel: QuestionCellViewModel?) {
        guard let model = viewModel else { return }
        baseHeaderView?.configure(title: model.title, subtitle: model.text)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.quotation.apply(model.text, to: baseHeaderView?.subtitleTextView)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 45.0
    }
}
