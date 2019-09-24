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
    weak var dailyBriefViewControllerDelegate: DailyBriefViewControllerDelegate?

    func configure(with data: MyPeakPerformanceCellViewModel?) {
        stackView.removeSubViews()
        addFormHeaderView(with: data?.title)
        for message in data?.sections ?? [] {
            addFormSectionView(with: message.sections)
            for row in message.rows {
                addFormRowView(with: row)
            }
            addFormDividerView()
        }
        addFormFooterView()
    }

    private func addFormHeaderView(with data: MyPeakPerformanceCellViewModel.MypeakPerformanceTitle?) {
        guard let view = MyPeakPerformanceTitleCell.instantiateFromNib() else {
            return
        }
        view.configure(bucketTitle: data?.title)
        stackView.addArrangedSubview(view)
    }

    private func addFormSectionView(with data: MyPeakPerformanceCellViewModel.MyPeakPerformanceSectionRow) {
        guard let view = MyPeakPerformanceSectionCell.instantiateFromNib() else {
            return
        }
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }

    private func addFormRowView(with data: MyPeakPerformanceCellViewModel.MyPeakPerformanceRow) {
        guard let view = MyPeakPerformanceRowCell.instantiateFromNib() else {
            return
        }
        view.delegate = dailyBriefViewControllerDelegate
        view.configure(with: data)
        stackView.addArrangedSubview(view)
    }

    private func addFormFooterView() {
        guard let view = MyPeakPerformanceFooter.instantiateFromNib() else {
            return
        }
        stackView.addArrangedSubview(view)
    }

    private func addFormDividerView() {
        guard let view = MyPeakPerformanceDividerView.instantiateFromNib() else {
            return
        }
        stackView.addArrangedSubview(view)
    }
}
