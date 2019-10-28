//
//  PermissionCalendarView.swift
//  QOT
//
//  Created by karmic on 19.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PermissionCalendarView: UIView {

    // MARK: - Properties
    @IBOutlet weak var headerContainerView: UIView!
    var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var weekDayLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var listLabel01: UILabel!
    @IBOutlet private weak var listLabel02: UILabel!
    @IBOutlet private weak var listLabel03: UILabel!
    @IBOutlet private weak var listLabel04: UILabel!

    // MARK: - Load View
    static func instantiateFromNib() -> PermissionCalendarView {
        guard let view = R.nib.permissionCalendarView.instantiate(withOwner: self)
            .first as? PermissionCalendarView else { fatalError("Cannot load PermissionCalendarView") }
        view.baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        view.baseHeaderView?.addTo(superview: view.headerContainerView)
        view.configure()

        return view
    }

    // MARK: Configuration
    func configure() {
        baseHeaderView?.configure(title: AppTextService.get(AppTextKey.calendar_permission_view_title_header),
                                  subtitle: AppTextService.get(AppTextKey.calendar_permission_view_subtitle_header),
                                  darkMode: true)
        weekDayLabel.text = AppTextService.get(AppTextKey.calendar_permission_view_body_weekday)
        aboutLabel.text = AppTextService.get(AppTextKey.calendar_permission_view_body_title)
        listLabel01.text = AppTextService.get(AppTextKey.calendar_permission_view_body_list_first)
        listLabel02.text = AppTextService.get(AppTextKey.calendar_permission_view_body_list_second)
        listLabel03.text = AppTextService.get(AppTextKey.calendar_permission_view_body_list_third)
        listLabel04.text = AppTextService.get(AppTextKey.calendar_permission_view_body_list_fourth)
    }
}
