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

        func trackingKeys() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(AppTextKey.page_track_myqot_support_using)
            case .faq:
                return AppTextService.get(AppTextKey.page_track_myqot_support_faq)
            case .contactSupport:
                return AppTextService.get(AppTextKey.page_track_myqot_support_contactsupport)
            case .contactSupportNovartis:
                return AppTextService.get(AppTextKey.page_track_myqot_support_contactnovartis)
            case .featureRequest:
                return AppTextService.get(AppTextKey.page_track_myqot_support_featurerequest)
            }
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
