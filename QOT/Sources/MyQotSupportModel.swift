//
//  MyQotSupportModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MyQotSupportModel {
    
    enum MyQotSupportModelItem: Int {
        case featureRequest
        case tutorial
        case contactSupport
        case faq
        
        static var supportValues: [MyQotSupportModelItem] {
            return [.featureRequest, .tutorial, .contactSupport, .faq]
        }
        
        var primaryKey: Int {
            switch self {
            case .contactSupport: return 101192
            case .featureRequest,
                 .tutorial: return 0
            case .faq: return 100704
            }
        }
        
        func trackingKeys(for services: Services) -> String {
            switch self {
            case .contactSupport:
                return ContentService.Support.contactSupport.rawValue
            case .featureRequest:
                return ContentService.Support.featureRequest.rawValue
            case .tutorial:
                return ContentService.Support.tutorial.rawValue
            case .faq:
                return ContentService.Support.faq.rawValue
            }
        }
        
        func title(for services: Services) -> String {
            switch self {
            case .contactSupport:
                return services.contentService.localizedString(for: ContentService.Support.contactSupport.predicate) ?? ""
            case .featureRequest:
                return services.contentService.localizedString(for: ContentService.Support.featureRequest.predicate) ?? ""
            case .tutorial:
                return services.contentService.localizedString(for: ContentService.Support.tutorial.predicate) ?? ""
            case .faq:
                return services.contentService.localizedString(for: ContentService.Support.faq.predicate) ?? ""
            }
        }
        
        func subtitle(for services: Services) -> String {
            switch self {
            case .contactSupport:
                return services.contentService.localizedString(for: ContentService.Support.areYouMissingSomething.predicate) ?? ""
            case .featureRequest:
                return services.contentService.localizedString(for: ContentService.Support.learnHowToUseQot.predicate) ?? ""
            case .tutorial:
                return services.contentService.localizedString(for: ContentService.Support.contactUsForAnyQuestion.predicate) ?? ""
            case .faq:
                return services.contentService.localizedString(for: ContentService.Support.checkTheMostAskedQuestion.predicate) ?? ""
            }
        }
        
        var pageName: PageName {
            switch self {
            case .contactSupport: return .supportContact
            case .featureRequest: return .featureRequest
            case .tutorial: return .tutorial
            case .faq: return .faq
            }
        }
        
        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .contactSupport: return service.contentCollection(id: primaryKey)
            case .featureRequest,
                 .tutorial: return nil
            case .faq: return service.contentCollection(id: primaryKey)
            }
        }
    }
}
