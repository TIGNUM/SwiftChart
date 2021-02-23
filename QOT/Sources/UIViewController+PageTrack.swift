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
        case is ShifterResultViewController: return "decisiontree.mindsetshifter.results"
        case is MyQotProfileViewController: return "myprofile.home"
        case is MyQotAccountSettingsViewController: return "myprofile.accountsettings"
        case is ProfileSettingsViewController: return "myprofile.accountsettings.edit"
        case is MyQotAppSettingsViewController: return "myprofile.appsettings"
        case is MyQotAboutUsViewController: return "myprofile.aboutus"
        case is MyQotSupportViewController: return "myprofile.support"
        case is MyQotSensorsViewController: return "myprofile.appsettings.activitytrackers"
        case is MyQotSiriShortcutsViewController: return "myprofile.appsettings.sirishortcuts"
        case is MyQotSupportDetailsViewController: return myQOTSupportDetailsViewControllerPageKey
        case is MyVisionViewController: return "tobevision"
        case is MyVisionEditDetailsViewController: return "tobevision.edit"
        case is MyToBeVisionRateViewController: return "tobevision.tracker.questionaire"
        case is MyToBeVisionTrackerViewController: return myToBeVisionTrackerViewControllerPageKey
        case is CoachViewController: return "coach.main"
        case is SearchViewController: return "search.main"
        case is ToolsViewController: return "coach.tools"
        case is ToolsCollectionsViewController: return "coach.tools.list"
        case is ToolsItemsViewController: return "coach.tools.item.detail"
        case is KnowingViewController: return "know.feed"
        case is SolveResultsViewController: return "solve.results"
        case is MyQotMainViewController: return "myqot.main"
        case is MyPrepsViewController: return "myqot.mypreps"
        case is AudioFullScreenViewController: return "fullscreen.audioplayer"
        case is PreparationWithMissingEventViewController: return "prepare.missing.event"
        case is MyLibraryCategoryListViewController: return "mylibrary"
        case is DailyCheckinQuestionsViewController: return "dailyCheckin.questions"
        case is MySprintsListViewController: return "myqot.mysprints"
        case is MySprintDetailsViewController: return "myqot.mysprints.sprint.detail"
        case is SigningInfoViewController: return "landingpage"
        case is CreateAccountInfoViewController: return "onboarding.createaccount"
        case is RegistrationEmailViewController: return "onboarding.createaccount.email"
        case is RegistrationCodeViewController: return "onboarding.createaccount.activationcode"
        case is RegistrationNamesViewController: return "onboarding.createaccount.name"
        case is StrategyListViewController: return "know.feed.strategy.list"
        case is ArticleViewController: return "article.detail"
        case is SyncedCalendarsViewController: return "myprofile.appsettings.syncedCalendars"
        case is MyDataScreenViewController: return "myqot.mydata"
        case is MyDataSelectionViewController: return "myqot.mydata.lineselection"
        case is AskPermissionViewController: return askPermissionPageKey
        case is ChoiceViewController: return "prepare.result.add.remove.strategies"
        case is MediaPlayerViewController: return "fullscreen.videoPlayer"
        case is PDFReaderViewController: return "fullscreen.pdfreader"
        case is PopUpCopyrightViewController: return "daily.brief.content.copyright"
        case is DailyBriefViewController: return "daily.brief"
        case is TBVRateHistoryNullStateViewController: return "tobevision.mytbvdata"
        case is FeatureExplainerViewController: return featureExplainerPageKey
        case is QuestionnaireViewController:
            if let controllerType = (self as? QuestionnaireViewController)?.controllerType {
                switch controllerType {
                case .teamVision: return "teamtobevision.tracker.questionaire"
                case .vision: return "tobevision.tracker.questionaire"
                case .dailyCheckin: return "daily.checkin.questions"
                case .customize: return "sleep.quantity.customize.target"
                }
            }
            return "daily.checkin.questions"
        case is OnboardingLoginViewController: return "onboarding.login"
        case is CoachMarksViewController: return walkThroughPageKey
        case is PaymentReminderViewController: return subscriptionReminderPageKey
        case is RegisterIntroViewController: return "onboarding.createaccount.info"
        case is ResultsPrepareViewController: return resultsPareparePageKey
        case is DTPrepareStartViewController: return "decisiontree.prepare.start"
        case is CalendarEventSelectionViewController: return "calendar.event.selection"
        case is MyQotAdminSettingsListViewController: return "myqot.adminsettings"
        case is MyXTeamSettingsViewController: return "myX.settings.teamsettings"
        case is MyXTeamMembersViewController: return "myX.settings.teamMembers"
        case is TeamEditViewController: return teamEditViewControllerPageKey
        case is TeamInvitesViewController: return "team.pending.invitations"
        case is BookMarkSelectionViewController: return "bookmark_library_selection"
        case is TeamToBeVisionViewController: return "teamTBV"
        case is VisionRatingExplanationViewController: return "rating_feature_explanation"
        case is TeamToBeVisionOptionsViewController: return "teamTBV.options"
        default: preconditionFailure()
        }
    }
}

// MARK: - MyQotSupportDetailsViewController
private extension UIViewController {
    var myQOTSupportDetailsViewControllerPageKey: String {
        switch (self as? MyQotSupportDetailsViewController)?.interactor?.category {
        case .FAQ?: return "myprofile.support.faq"
        case .FAQTeam?: return "myprofile.support.faq.team"
        case .FAQBeforeLogin?: return "myprofile.support.faqbeforelogin"
        case .UsingQOT?: return "myprofile.support.using.tignumx"
        default: preconditionFailure()
        }
    }
}

// MARK: - MyDataExplanationViewController
private extension UIViewController {
    var myToBeVisionTrackerViewControllerPageKey: String {
        switch (self as? MyToBeVisionTrackerViewController)?.interactor?.getDisplayType {
        case .tracker?: return  "tobevision.tracker.results"
        case .data?: return "tobevision.tracker.tbvTracker"
        default: preconditionFailure()
        }
    }
}

// MARK: - TeamEditViewController
private extension UIViewController {
    var teamEditViewControllerPageKey: String {
        switch (self as? TeamEditViewController)?.interactor?.getType {
        case .edit?: return "myX.settings.editTeam"
        case .create?: return "myX.createTeam"
        case .memberInvite?: return "myX.inviteMembers"
        default: preconditionFailure()
        }
    }
}

// MARK: - DecisionTree IDs
private extension UIViewController {
    var decisionTreePageKey: String {
        switch self {
        case is DTMindsetViewController: return "decisiontree.mindsetshifter"
        case is DTPrepareViewController: return "decisiontree.prepare"
        case is DTRecoveryViewController: return "decisiontree.3drecovery"
        case is DTShortTBVViewController: return shortTBVPageKey
        case is DTSolveViewController: return "decisiontree.solve"
        case is DTSprintViewController: return "decisiontree.sprint"
        case is DTSprintReflectionViewController: return "decisiontree.sprint.reflection"
        case is DTTBVViewController: return "decisiontree.tobevision.generator"
        case is DTTeamTBVViewController: return "decisiontree.team.tobevision.generator"

        default: preconditionFailure()
        }
    }
}

private extension UIViewController {
    var preparePageKey: String {
        if let introKey = (self as? DTPrepareViewController)?.interactor?.getIntroKey {
            switch introKey {
            case Prepare.QuestionKey.EventTypeSelectionDaily,
                 Prepare.QuestionKey.EventTypeSelectionCritical: return "decisiontree.prepare"
            case Prepare.QuestionKey.BenefitsInput: return "decisiontree.prepare.edit.benefits"
            case Prepare.Key.feel.rawValue: return "decisiontree.prepare.edit.intentions.feel"
            case Prepare.Key.know.rawValue: return "decisiontree.prepare.edit.intentions.know"
            case Prepare.Key.perceived.rawValue: return "decisiontree.prepare.edit.intentions.perceived"
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
            case ShortTBV.QuestionKey.IntroMindSet: return "decisiontree.mindsetshifter.tobevisiongenerator"
            case ShortTBV.QuestionKey.IntroPrepare: return "decisiontree.prepare.tobevisiongenerator"
            case ShortTBV.QuestionKey.IntroOnboarding: return "decisiontree.onboarding.tobevisiongenerator"
            case ShortTBV.QuestionKey.Work: return "decisiontree.solve.tobevisiongenerator"
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
        case .ALL?: return "mylibrary.all"
        case .BOOKMARK?: return "mylibrary.bookmarks"
        case .DOWNLOAD?: return "mylibrary.downloads"
        case .EXTERNAL_LINK?: return "mylibrary.links"
        case .NOTE?: return "mylibrary.notes"
        default: preconditionFailure()
        }
    }
}

// MARK: AskPermission IDs
private extension UIViewController {
    var askPermissionPageKey: String {
        switch (self as? AskPermissionViewController)?.interactor.getPermissionType {
        case .location?: return "askPermission.location"
        case .notification?: return "askPermission.notification"
        case .notificationOnboarding?: return "askPermission.notification.onboarding"
        case .calendar?: return "askPermission.calendar"
        case .calendarOpenSettings?: return "askPermission.calendar.settings"
        case .notificationOpenSettings?: return "askPermission.notification.settings"
        default: preconditionFailure()
        }
    }
}

private extension UIViewController {
    var featureExplainerPageKey: String {
        switch (self as? FeatureExplainerViewController)?.interactor.getFeatureType {
        case .sprint?: return "feature.explainer.sprint"
        case .prepare?: return "feature.explainer.prepare"
        case .recovery?: return "feature.explainer.recovery"
        case .solve?: return "feature.explainer.solve"
        case .tools?: return "feature.explainer.tools"
        case .mindsetShifter?: return "feature.explainer.mindsetShifter"
        default: preconditionFailure()
        }
    }
}

// MARK: - MyLibraryNote IDs
private extension UIViewController {
     var myLibraryNoteKey: String {
           if let newNote = (self as? MyLibraryNotesViewController)?.interactor?.isCreatingNewNote, newNote == true {
               return "mylibrary.notes.newnote"
           }
           return "mylibrary.notes.savednote"
       }
}

// MARK: prepareReults IDs
private extension UIViewController {
    var resultsPareparePageKey: String {
        switch (self as? ResultsPrepareViewController)?.interactor.getType {
        case .LEVEL_DAILY?: return "prepare.results.daily"
        case .LEVEL_CRITICAL?: return "prepare.results.critical"
        case .LEVEL_ON_THE_GO?: return "prepare.results.onthego"
        default: preconditionFailure()
        }
    }
}

// MARK: solveResults IDs
private extension UIViewController {
    var subscriptionReminderPageKey: String {
        if (self as? PaymentReminderViewController)?.interactor?.isExpired ?? false {
            return "subscription.reminder.generic.payment.screen.expired"
        } else {
            return "subscription.reminder.generic.payment.screen.soon"
        }
    }
}

// MARK: solveResults IDs
private extension UIViewController {
    var walkThroughPageKey: String {
        let pageIndex: Int = (self as? CoachMarksViewController)?.interactor?.currentPage ?? 0
        switch pageIndex {
        case 0:
            return "onboarding.walkthrough.know"
        case 1:
            return "onboarding.walkthrough.myqot"
        case 2:
            return "onboarding.walkthrough.coach"
        case 3:
            return "onboarding.walkthrough.search"
        default:
            return "onboarding.walkthrough.know"
        }
    }
}
