//
//  MyQotAccountSettingsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAccountSettingsWorker {
    
    // MARK: - Properties
    
    private let services: Services
    private let userProfileManager: UserProfileManager?
    private let networkManager: NetworkManager

    // MARK: - Init
    
    init(services: Services, syncManager: SyncManager, networkManager: NetworkManager) {
        self.services = services
        self.networkManager = networkManager
        self.userProfileManager = UserProfileManager(services, syncManager)
    }
    
    func profile() -> UserProfileModel? {
        return userProfileManager?.profile()
    }
    
    func logout() {
        ExtensionsDataManager.didUserLogIn(false)
        UIApplication.shared.shortcutItems?.removeAll()
        NotificationHandler.postNotification(withName: .logoutNotification)
    }
    
    func resetPassword(completion: @escaping (NetworkError?) -> Void) {
        networkManager.performResetPasswordRequest(username: userEmail, completion: { error in
            completion(error)
        })
    }
    
    func alertType(for error: NetworkError?) -> AlertType {
        guard let error = error else { return .resetPassword }
        switch error.type {
        case .noNetworkConnection:
            return .noNetworkConnection
        case .notFound:
            return .emailNotFound
        default:
            return .unknown
        }
    }
}

// MARK: - ContentService

extension MyQotAccountSettingsWorker {

    var accountSettingsText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.accountSettings.predicate) ?? ""
    }
    var contactText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.contact.predicate) ?? ""
    }
    var emailText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.email.predicate) ?? ""
    }
    var phoneText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.phone.predicate) ?? ""
    }
    var personalDataText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.personalData.predicate) ?? ""
    }
    var heightText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.height.predicate) ?? ""
    }
    var weightText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.weight.predicate) ?? ""
    }
    var accountText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.account.predicate) ?? ""
    }
    
    var changePasswordKey: String {
        return ContentService.AccountSettings.Profile.changePassword.rawValue
    }
    
    var logoutQOTKey: String {
        return ContentService.AccountSettings.Profile.logoutQot.rawValue
    }
    
    var changePasswordText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.changePassword.predicate) ?? ""
    }
    var protectYourAccountText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.protectYourAccount.predicate) ?? ""
    }
    var logoutQotText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.logoutQot.predicate) ?? ""
    }
    var withoutDeletingAccountText: String {
        return services.contentService.localizedString(for: ContentService.AccountSettings.Profile.withoutDeletingAccountText.predicate) ?? ""
    }
}

// MARK: - Private extension

private extension MyQotAccountSettingsWorker {
    var userEmail: String {
        return self.profile()?.email ?? ""
    }
}
