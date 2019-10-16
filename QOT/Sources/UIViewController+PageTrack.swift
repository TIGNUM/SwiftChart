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
        case is ShifterResultViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_mindsetshifter_results)
        case is MyQotProfileViewController: return AppTextService.get(AppTextKey.page_track_myprofile_home)
        case is MyQotAccountSettingsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_accountsettings)
        case is ProfileSettingsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_accountsettings_edit)
        case is MyQotAppSettingsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_appsettings)
        case is MyQotAboutUsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_aboutus)
        case is MyQotSupportViewController: return AppTextService.get(AppTextKey.page_track_myprofile_support)
        case is MyQotSensorsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_appsettings_activitytrackers)
        case is MyQotSiriShortcutsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_appsettings_sirishortcuts)
        case is MyQotSupportDetailsViewController: return myQOTSupportDetailsViewControllerPageKey
        case is MyVisionViewController: return AppTextService.get(AppTextKey.page_track_tobevision)
        case is MyVisionEditDetailsViewController: return AppTextService.get(AppTextKey.page_track_tobevision_edit)
        case is MyToBeVisionRateViewController: return AppTextService.get(AppTextKey.page_track_tobevision_tracker_questionaire)
        case is MyToBeVisionTrackerViewController: return myToBeVisionTrackerViewControllerPageKey
        case is CoachViewController: return AppTextService.get(AppTextKey.page_track_coach_main)
        case is SearchViewController: return AppTextService.get(AppTextKey.page_track_search_main)
        case is ToolsViewController: return AppTextService.get(AppTextKey.page_track_coach_tools)
        case is ToolsCollectionsViewController: return AppTextService.get(AppTextKey.page_track_coach_tools_list)
        case is ToolsItemsViewController: return AppTextService.get(AppTextKey.page_track_coach_tools_item_detail)
        case is KnowingViewController: return AppTextService.get(AppTextKey.page_track_know_feed)
        case is SolveResultsViewController: return AppTextService.get(AppTextKey.page_track_solve_results)
        case is MyQotMainViewController: return AppTextService.get(AppTextKey.page_track_myqot_main)
        case is MyPrepsViewController: return AppTextService.get(AppTextKey.page_track_myqot_mypreps)
        case is AudioFullScreenViewController: return AppTextService.get(AppTextKey.page_track_fullscreen_audioplayer)
        case is PrepareResultsViewController: return AppTextService.get(AppTextKey.page_track_prepare_results)
        case is PreparationWithMissingEventViewController: return AppTextService.get(AppTextKey.page_track_prepare_missing_event)
        case is MyLibraryCategoryListViewController: return AppTextService.get(AppTextKey.page_track_mylibrary)
        case is DailyCheckinStartViewController: return AppTextService.get(AppTextKey.page_track_dailyCheckin_start)
        case is DailyCheckinQuestionsViewController: return AppTextService.get(AppTextKey.page_track_dailyCheckin_questions)
        case is MySprintsListViewController: return AppTextService.get(AppTextKey.page_track_myqot_mysprints)
        case is MySprintDetailsViewController: return AppTextService.get(AppTextKey.page_track_myqot_mysprints_sprint_detail)
        case is SigningInfoViewController: return AppTextService.get(AppTextKey.page_track_landingpage)
        case is CreateAccountInfoViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount)
        case is RegistrationEmailViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount_email)
        case is RegistrationCodeViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount_activationcode)
        case is RegistrationNamesViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount_name)
        case is RegistrationAgeViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount_birthdate)
        case is TrackSelectionViewController: return AppTextService.get(AppTextKey.page_track_onboarding_createaccount_welcome)
        case is StrategyListViewController: return AppTextService.get(AppTextKey.page_track_know_feed_strategy_list)
        case is ArticleViewController: return AppTextService.get(AppTextKey.page_track_article_detail)
        case is SyncedCalendarsViewController: return AppTextService.get(AppTextKey.page_track_myprofile_appsettings_syncedCalendars)
        case is MyDataScreenViewController: return AppTextService.get(AppTextKey.page_track_myqot_mydata)
        case is MyDataSelectionViewController: return AppTextService.get(AppTextKey.page_track_myqot_mydata_lineselection)
        case is MyDataExplanationViewController: return myDataInfoViewControllerPageKey
        case is AskPermissionViewController: return askPermissionPageKey
        case is ChoiceViewController: return AppTextService.get(AppTextKey.page_track_prepare_result_add_remove_strategies)
        case is MediaPlayerViewController: return AppTextService.get(AppTextKey.page_track_fullscreen_videoPlayer)
        case is PDFReaderViewController: return AppTextService.get(AppTextKey.page_track_fullscreen_pdfreader)
        case is PopUpCopyrightViewController: return AppTextService.get(AppTextKey.page_track_daily_brief_content_copyright)
        case is DailyBriefViewController: return AppTextService.get(AppTextKey.page_track_daily_brief)
        case is MyToBeVisionDataNullStateViewController: return AppTextService.get(AppTextKey.page_track_tobevision_mytbvdata)
        case is WalkthroughSearchViewController: return AppTextService.get(AppTextKey.page_track_walkthrough_search)
        case is WalkthroughCoachViewController: return AppTextService.get(AppTextKey.page_track_walkthrough_coach)
        case is WalkthroughSwipeViewController: return AppTextService.get(AppTextKey.page_track_walkthrough_swipe)
        case is QuestionnaireViewController: return AppTextService.get(AppTextKey.page_track_sleep_quantity_customize_target)
        case is OnboardingLoginViewController: return AppTextService.get(AppTextKey.page_track_onboarding_login)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyQotSupportDetailsViewController
private extension UIViewController {
    var myQOTSupportDetailsViewControllerPageKey: String {
        switch (self as? MyQotSupportDetailsViewController)?.interactor?.category {
        case .FAQ?: return AppTextService.get(AppTextKey.page_track_myprofile_support_faq)
        case .UsingQOT?: return AppTextService.get(AppTextKey.page_track_myprofile_support_using_qot)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyDataExplanationViewController
private extension UIViewController {
    var myToBeVisionTrackerViewControllerPageKey: String {
        switch (self as? MyToBeVisionTrackerViewController)?.interactor?.controllerType {
        case .tracker?: return AppTextService.get(AppTextKey.page_track_tobevision_tracker_results)
        case .data?: return AppTextService.get(AppTextKey.page_track_tobevision_tracker_tbvTracker)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyDataExplanationViewController
private extension UIViewController {
    var myDataInfoViewControllerPageKey: String {
        switch (self as? MyDataExplanationViewController)?.interactor?.getPresentedFromSection() {
        case .dailyImpact?: return AppTextService.get(AppTextKey.page_track_myqot_mydata_impact_info)
        case .heatMap?: return AppTextService.get(AppTextKey.page_track_myqot_mydata_heatmap_info)
        default: preconditionFailure()
        }
    }
}

// MARK: - DecisionTree IDs
private extension UIViewController {
    var decisionTreePageKey: String {
        switch self {
        case is DTMindsetViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_mindsetshifter)
        case is DTPrepareViewController: return preparePageKey
        case is DTRecoveryViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_3drecovery)
        case is DTShortTBVViewController: return shortTBVPageKey
        case is DTSolveViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_solve)
        case is DTSprintViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_sprint)
        case is DTSprintReflectionViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_sprint_reflection)
        case is DTTBVViewController: return AppTextService.get(AppTextKey.page_track_decisiontree_tobevisiongenerator)

        default: preconditionFailure()
        }
    }
}

private extension UIViewController {
    var preparePageKey: String {
        if let introKey = (self as? DTPrepareViewController)?.interactor?.getIntroKey {
            switch introKey {
            case Prepare.QuestionKey.Intro: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare)
            case Prepare.QuestionKey.BenefitsInput: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare_edit_benefits)
            case Prepare.Key.feel.rawValue: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare_edit_intentions_feel)
            case Prepare.Key.know.rawValue: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare_edit_intentions_know)
            case Prepare.Key.perceived.rawValue: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare_edit_intentions_perceived)
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
            case ShortTBV.QuestionKey.IntroMindSet: return AppTextService.get(AppTextKey.page_track_decisiontree_mindsetshifter_tobevisiongenerator)
            case ShortTBV.QuestionKey.IntroPrepare: return AppTextService.get(AppTextKey.page_track_decisiontree_prepare_tobevisiongenerator)
            case ShortTBV.QuestionKey.IntroOnboarding: return AppTextService.get(AppTextKey.page_track_decisiontree_onboarding_tobevisiongenerator)
            case ShortTBV.QuestionKey.Work: return AppTextService.get(AppTextKey.page_track_decisiontree_solve_tobevisiongenerator)
            default: preconditionFailure()
            }
        }
        preconditionFailure()
    }
}

// MARK: - MyLibraryUserStorage IDs
private extension UIViewController {
    var userStoragePageKey: String {
        switch (self as? MyLibraryUserStorageViewController)?.interactor?.contentType {
        case .all?: return AppTextService.get(AppTextKey.page_track_mylibrary_all)
        case .bookmarks?: return AppTextService.get(AppTextKey.page_track_mylibrary_bookmarks)
        case .downloads?: return AppTextService.get(AppTextKey.page_track_mylibrary_downloads)
        case .links?: return AppTextService.get(AppTextKey.page_track_mylibrary_links)
        case .notes?: return AppTextService.get(AppTextKey.page_track_mylibrary_notes)
        default: preconditionFailure()
        }
    }
}

// MARK: AskPermission IDs
private extension UIViewController {
    var askPermissionPageKey: String {
        switch (self as? AskPermissionViewController)?.interactor?.permissionType {
        case .location?: return AppTextService.get(AppTextKey.page_track_askPermission_location)
        case .notification?: return AppTextService.get(AppTextKey.page_track_askPermission_notification)
        case .calendar?: return AppTextService.get(AppTextKey.page_track_askPermission_calendar)
        case .calendarOpenSettings?: return AppTextService.get(AppTextKey.page_track_askPermission_calendar_settings)
        case .notificationOpenSettings?: return AppTextService.get(AppTextKey.page_track_askPermission_notification_settings)
        default: preconditionFailure()
        }
    }
}

// MARK: - MyLibraryNote IDs
private extension UIViewController {
    var myLibraryNoteKey: String {
        if let newNote = (self as? MyLibraryNotesViewController)?.interactor?.isCreatingNewNote, newNote == true {
            return AppTextService.get(AppTextKey.page_track_mylibrary_notes_newnote)
        }
        return AppTextService.get(AppTextKey.page_track_mylibrary_notes_savednote)
    }
}
