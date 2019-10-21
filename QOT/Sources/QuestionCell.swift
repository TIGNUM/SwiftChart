//
//  QuestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionCell: BaseDailyBriefCell {

    private var baseView: QOTBaseHeaderView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        baseView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with viewModel: QuestionCellViewModel?) {
        guard let model = viewModel else { return }
        baseView?.configure(title: model.title, subtitle: model.text)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseView?.titleLabel)
        ThemeText.quotation.apply(model.text, to: baseView?.subtitleTextView)
    }
}
