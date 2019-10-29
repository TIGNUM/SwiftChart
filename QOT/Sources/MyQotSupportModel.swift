//
//  MyQotSupportModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyQotSupportModel {

    enum MyQotSupportModelItem: Int {
        case usingQOT
        case faq
        case contactSupport
        case contactSupportNovartis
        case featureRequest

        static var supportValues: [MyQotSupportModelItem] {
            #if NOVARTIS
                return [.usingQOT, .faq, .contactSupportNovartis, .featureRequest]
            #else
                return [.usingQOT, .faq, .contactSupport, .featureRequest]
            #endif
        }

        func tag() -> Tags {
            switch self {
            case .usingQOT:
                return Tags.SupportUsingQOT
            case .faq:
                return Tags.SupportFaq
            case .contactSupport:
                return Tags.SupportContactSupport
            case .contactSupportNovartis:
                return Tags.SupportContactSupportNovartis
            case .featureRequest:
                return Tags.SupportFeatureRequest
            }
        }

        func trackingKeys() -> String {
            return tag().rawValue
        }

        func title() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_using_qot_view_title)
            case .faq:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_faq)
            case .contactSupport:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_contact_support)
            case .contactSupportNovartis:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_contact_support_novartis)
            case .featureRequest:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_using_qot)
            }
        }

        func subtitle() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_feature)
            case .faq:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_faq)
            case .contactSupport, .contactSupportNovartis:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_support)
            case .featureRequest:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_feature)
            }
        }
    }
}
