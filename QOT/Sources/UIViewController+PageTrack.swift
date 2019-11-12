//
//  UIViewController+PageTrack.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 29.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Actions
extension UIViewController {
    @objc func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }

    func trackUserEvent(_ name: QDMUserEventTracking.Name,
                        value: Int? = nil,
                        stringValue: String? = nil,
                        valueType: QDMUserEventTracking.ValueType? = nil,
                        action: QDMUserEventTracking.Action) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = value
        userEventTrack.stringValue = stringValue
        userEventTrack.valueType = valueType
        userEventTrack.action = action
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }
}

// MARK: - Keys
extension UIViewController {
    var pageKey: String {
        switch self {
        case is DTViewController: return decisionTreePageKey
        case is MyLibraryUserStorageViewController: return userStoragePageKey
        case is MyLibraryNotesViewController: return myLibraryNoteKey
        case is ShifterResultViewController: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_minsdset_shifter_result)
        case is MyQotProfileViewController: return AppTextService.get(AppTextKey.my_qot_my_profile)
        case is MyQotAccountSettingsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings)
        case is ProfileSettingsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_edit)
        case is MyQotAppSettingsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings)
        case is MyQotAboutUsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_about_us)
        case is MyQotSupportViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_support)
        case is MyQotSensorsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources)
        case is MyQotSiriShortcutsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts)
        case is MyQotSupportDetailsViewController: return myQOTSupportDetailsViewControllerPageKey
        case is MyVisionViewController: return AppTextService.get(AppTextKey.my_qot_my_tbv)
        case is MyVisionEditDetailsViewController: return AppTextService.get(AppTextKey.my_qot_my_tbv_edit)
        case is MyToBeVisionRateViewController: return AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_questionnaire)
        case is MyToBeVisionTrackerViewController: return myToBeVisionTrackerViewControllerPageKey
        case is CoachViewController: return AppTextService.get(AppTextKey.coach)
        case is SearchViewController: return AppTextService.get(AppTextKey.coach_search)
        case is ToolsViewController: return AppTextService.get(AppTextKey.coach_tools)
        case is ToolsCollectionsViewController: return AppTextService.get(AppTextKey.coach_tools_tools_list_details)
        case is ToolsItemsViewController: return AppTextService.get(AppTextKey.coach_tools_tools_list)
        case is KnowingViewController: return AppTextService.get(AppTextKey.know)
        case is SolveResultsViewController: return solveResultsPageKey
        case is MyQotMainViewController: return AppTextService.get(AppTextKey.my_qot)
        case is MyPrepsViewController: return AppTextService.get(AppTextKey.my_qot_my_plans)
        case is AudioFullScreenViewController: return AppTextService.get(AppTextKey.generic_content_audio)
        case is PrepareResultsViewController: return prepareResultsPageKey
        case is PreparationWithMissingEventViewController: return AppTextService.get(AppTextKey.generic_event_removed)
        case is MyLibraryCategoryListViewController: return AppTextService.get(AppTextKey.my_qot_my_library)
        case is DailyCheckinQuestionsViewController: return AppTextService.get(AppTextKey.daily_brief_daily_check_in_questionnaire)
        case is MySprintsListViewController: return AppTextService.get(AppTextKey.my_qot_my_sprint)
        case is MySprintDetailsViewController: return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details)
        case is SigningInfoViewController: return AppTextService.get(AppTextKey.onboarding_launch_screen)
        case is CreateAccountInfoViewController: return AppTextService.get(AppTextKey.onboarding_sign_up_create_account)
        case is RegistrationEmailViewController: return AppTextService.get(AppTextKey.onboarding_sign_up_email_verification)
        case is RegistrationCodeViewController: return AppTextService.get(AppTextKey.onboarding_sign_up_code_verification)
        case is RegistrationNamesViewController: return AppTextService.get(AppTextKey.onboarding_sign_up_enter_name)
        case is RegistrationAgeViewController: return AppTextService.get(AppTextKey.onboarding_sign_up_age_verification)
        case is TrackSelectionViewController: return AppTextService.get(AppTextKey.onboarding_guided_track)
        case is StrategyListViewController: return AppTextService.get(AppTextKey.know_strategy_list)
        case is ArticleViewController: return AppTextService.get(AppTextKey.know_strategy_list_details)
        case is SyncedCalendarsViewController: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_synced_calendar)
        case is MyDataScreenViewController: return AppTextService.get(AppTextKey.my_qot_my_data)
        case is MyDataSelectionViewController: return AppTextService.get(AppTextKey.my_qot_my_data_ir_add_parameters)
        case is MyDataExplanationViewController: return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation)
        case is AskPermissionViewController: return askPermissionPageKey
        case is ChoiceViewController: return AppTextService.get(AppTextKey.coach_prepare_result_long_add_strategies)
        case is MediaPlayerViewController: return AppTextService.get(AppTextKey.generic_content_video)
        case is PDFReaderViewController: return AppTextService.get(AppTextKey.generic_content_pdf)
        case is DailyBriefViewController: return AppTextService.get(AppTextKey.daily_brief)
        case is MyToBeVisionDataNullStateViewController: return AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data)
        case is WalkthroughSearchViewController: return AppTextService.get(AppTextKey.onboarding_walkthrough_search)
        case is WalkthroughCoachViewController: return AppTextService.get(AppTextKey.onboarding_walkthrough_coach)
        case is WalkthroughSwipeViewController: return AppTextService.get(AppTextKey.onboarding_walkthrough_my_qot)
        case is QuestionnaireViewController: return AppTextService.get(AppTextKey.daily_brief_customize_sleep_amount)
        case is OnboardingLoginViewController: return AppTextService.get(AppTextKey.onboarding_log_in)
        case is PaymentReminderViewController: return subscriptionReminderPageKey
        default: preconditionFailure()
        }
    }
}

// MARK: - MyQotSupportDetailsViewController
private extension UIViewController {
    var myQOTSupportDetailsViewControllerPageKey: String {
        switch (self as? MyQotSupportDetailsViewController)?.interactor?.category {
        case .FAQ?: return AppTextService.get(AppTextKey.my_qot_my_profile_support_faq)
        case .UsingQOT?: return AppTextService.get(AppTextKey.my_qot_my_profile_support_using_qot)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyDataExplanationViewController
private extension UIViewController {
    var myToBeVisionTrackerViewControllerPageKey: String {
        switch (self as? MyToBeVisionTrackerViewController)?.interactor?.controllerType {
        case .tracker?: return AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_result)
        case .data?: return AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data)
        default: preconditionFailure()
        }
    }
}

// MARK: - DecisionTree IDs
private extension UIViewController {
    var decisionTreePageKey: String {
        switch self {
        case is DTMindsetViewController: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_minsdset_shifter_questionnaire)
        case is DTPrepareViewController: return preparePageKey
        case is DTRecoveryViewController: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_questionnaire)
        case is DTShortTBVViewController: return shortTBVPageKey
        case is DTSolveViewController: return AppTextService.get(AppTextKey.coach_solve_questionnaire)
        case is DTSprintViewController: return AppTextService.get(AppTextKey.coach_sprints_questionnaire)
        case is DTSprintReflectionViewController: return AppTextService.get(AppTextKey.my_qot_my_sprints_my_sprint_details_takeways_questionnaire)
        case is DTTBVViewController: return AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_generator)

        default: preconditionFailure()
        }
    }
}

private extension UIViewController {
    var preparePageKey: String {
        if let introKey = (self as? DTPrepareViewController)?.interactor?.getIntroKey {
            switch introKey {
            case Prepare.QuestionKey.Intro: return AppTextService.get(AppTextKey.coach_prepare_questionnaire)
            case Prepare.QuestionKey.BenefitsInput: return AppTextService.get(AppTextKey.coach_prepare_edit_intentions_benefits)
            case Prepare.Key.feel.rawValue: return AppTextService.get(AppTextKey.coach_prepare_edit_intentions_feel)
            case Prepare.Key.know.rawValue: return AppTextService.get(AppTextKey.coach_prepare_edit_intentions_know)
            case Prepare.Key.perceived.rawValue: return AppTextService.get(AppTextKey.coach_prepare_edit_intentions_perceived)
            default: preconditionFailure()
            }
        }
        preconditionFailure()
    }
}

private extension UIViewController {
    var shortTBVPageKey: String {
        if let introKey = (self as? DTShortTBVViewController)?.interactor?.getIntroKey {
            switch introKey {
            case ShortTBV.QuestionKey.IntroMindSet: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_minsdset_shifter_questionnaire_tbv_generator)
            case ShortTBV.QuestionKey.IntroPrepare: return AppTextService.get(AppTextKey.coach_prepare_questionnaire_tbv_generator)
            case ShortTBV.QuestionKey.IntroOnboarding: return AppTextService.get(AppTextKey.onboarding_sign_up_tbv_generator)
            case ShortTBV.QuestionKey.Work: return AppTextService.get(AppTextKey.coach_solve_questionnaire_tbv_generator)
            default: preconditionFailure()
            }
        }
        preconditionFailure()
    }
}

// MARK: - MyLibraryUserStorage IDs
private extension UIViewController {
    var userStoragePageKey: String {
        switch (self as? MyLibraryUserStorageViewController)?.interactor?.itemType {
        case .ALL?: return AppTextService.get(AppTextKey.my_qot_my_library_all)
        case .BOOKMARKS?: return AppTextService.get(AppTextKey.my_qot_my_library_bookmarks)
        case .DOWNLOADS?: return AppTextService.get(AppTextKey.my_qot_my_library_downloads)
        case .LINKS?: return AppTextService.get(AppTextKey.my_qot_my_library_links)
        case .NOTES?: return AppTextService.get(AppTextKey.my_qot_my_library_notes)
        default: preconditionFailure()
        }
    }
}

// MARK: AskPermission IDs
private extension UIViewController {
    var askPermissionPageKey: String {
        switch (self as? AskPermissionViewController)?.interactor?.permissionType {
        case .location?: return AppTextService.get(AppTextKey.coach_prepare_calendar_permission)
        case .notification?: return AppTextService.get(AppTextKey.coach_sprints_notification_permission)
        case .notificationOnboarding?: return AppTextService.get(AppTextKey.onboarding_notification_permission)
        case .calendar?: return AppTextService.get(AppTextKey.coach_prepare_calendar_permission)
        case .calendarOpenSettings?: return AppTextService.get(AppTextKey.coach_prepare_calendar_settings_permission)
        case .notificationOpenSettings?: return AppTextService.get(AppTextKey.coach_sprints_notification_settings_permission)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyLibraryNote IDs
private extension UIViewController {
    var myLibraryNoteKey: String {
        if let newNote = (self as? MyLibraryNotesViewController)?.interactor?.isCreatingNewNote, newNote == true {
            return AppTextService.get(AppTextKey.my_qot_my_library_notes_add_note)
        }
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note)
    }
}

// MARK: prepareReults IDs
private extension UIViewController {
    var prepareResultsPageKey: String {
        switch (self as? PrepareResultsViewController)?.interactor?.getType {
        case .LEVEL_DAILY?:  return AppTextService.get(AppTextKey.coach_prepare_result_medium)
        case .LEVEL_CRITICAL?:   return AppTextService.get(AppTextKey.coach_prepare_result_long)
        case .LEVEL_ON_THE_GO?:  return AppTextService.get(AppTextKey.coach_prepare_result_short)
        default: preconditionFailure()
        }
    }
}

// MARK: solveResults IDs
private extension UIViewController {
    var solveResultsPageKey: String {
        switch (self as? SolveResultsViewController)?.interactor?.resultType {
        case .solveDailyBrief?: return "" //AppTextService.get(AppTextKey.)
        case .solveDecisionTree?: return AppTextService.get(AppTextKey.coach_solve_result)
        case .recoveryDecisionTree?: return AppTextService.get(AppTextKey.coach_tools_interactive_tool_3drecovery_result)
        case .recoveryMyPlans?: return "" //AppTextService.get(AppTextKey.)
        case .mindsetShifterDecisionTree?: return "" //AppTextService.get(AppTextKey.)
        case .mindsetShifterMyPlans?: return "" //AppTextService.get(AppTextKey.)
        case .prepareDecisionTree?: return "" //AppTextService.get(AppTextKey.)
        case .prepareMyPlans?: return "" //AppTextService.get(AppTextKey.)
        case .prepareDailyBrief?: return "" //AppTextService.get(AppTextKey.)
        default: preconditionFailure()
        }
    }
}

private extension UIViewController {
    var subscriptionReminderPageKey: String {
        if (self as? PaymentReminderViewController)?.interactor?.isExpired ?? false {
            return AppTextService.get(AppTextKey.generic_payment_screen_expired)
        } else {
            return AppTextService.get(AppTextKey.generic_payment_screen_expire_soon)
        }
    }
}
