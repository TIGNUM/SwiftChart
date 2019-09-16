//
//  MyPeakPerformanceCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 13.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet weak var stackView: UIStackView!
    weak var appDelegate: DailyBriefViewControllerDelegate?

    func configure(with data: MyPeakPerformanceCellViewModel?) {
        stackView.removeSubViews()
        formHeaderView(with: data?.title)
        for message in data?.sections ?? [] {
            formSectionView(with: message.sections)
            for row in message.rows {
                formRowView(with: row)
            }
            formDividerView()
        }
        formFooterView()
    }

    private func formHeaderView(with data: MyPeakPerformanceCellViewModel.MypeakPerformanceTitle?) {
        guard let view = MyPeakPerformanceTitleCell.instantiateFromNib() else {
            return
        }
        view.configure(bucketTitle: data?.title)
        stackView.addArrangedSubview(view)
    }

    private func formSectionView(with data: MyPeakPerformanceCellViewModel.MyPeakPerformanceSectionRow) {
        guard let view = MyPeakPerformanceSectionCell.instantiateFromNib() else {
            return
        }
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }

    private func formRowView(with data: MyPeakPerformanceCellViewModel.MyPeakPerformanceRow) {
        guard let view = MyPeakPerformanceRowCell.instantiateFromNib() else {
            return
        }
        view.delegate = appDelegate
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }

    private func formFooterView() {
        guard let view = MyPeakPerformanceFooter.instantiateFromNib() else {
            return
        }
        stackView.addArrangedSubview(view)
    }

    private func formDividerView() {
        guard let view = MyPeakPerformanceDividerView.instantiateFromNib() else {
            return
        }
        stackView.addArrangedSubview(view)
    }
}
