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
        case introduction

        static var supportValues: [MyQotSupportModelItem] {
            #if NOVARTIS
            return [.usingQOT, .faq, .contactSupportNovartis, .featureRequest, .introduction]
            #else
            return [.usingQOT, .faq, .contactSupport, .featureRequest, .introduction]
            #endif
        }
// these are not tracking keys
        func trackingKeys() -> String {
            switch self {
            case .usingQOT:
                return ".my_qot_my_profile_support_using_qot"
            case .faq:
                return ".my_qot_my_profile_support_faq"
            case .contactSupport:
                return ".my_qot_my_profile_support_contact_support"
            case .contactSupportNovartis:
                return ".my_qot_my_profile_contact_support_novartis"
            case .featureRequest:
                return ".my_qot_my_profile_support_feature_request"
            case .introduction:
                return ".my_qot_my_profile_contact_support_introduction"
            }
        }

        func title() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(.my_qot_my_profile_support_using_qot_section_header_title)
            case .faq:
                return AppTextService.get(.my_qot_my_profile_support_section_faq_title)
            case .contactSupport:
                return AppTextService.get(.my_qot_my_profile_support_section_contact_support_title)
            case .contactSupportNovartis:
                return AppTextService.get(.my_qot_my_profile_support_section_contact_support_title_novartis)
            case .featureRequest:
                return AppTextService.get(.my_qot_my_profile_support_section_feature_request_title)
            case .introduction:
                return AppTextService.get(.my_qot_my_profile_support_section_introduction_request_title)
            }
        }

        func subtitle() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(.my_qot_my_profile_support_section_using_qot_subtitle)
            case .faq:
                return AppTextService.get(.my_qot_my_profile_support_section_faq_subtitle)
            case .contactSupport, .contactSupportNovartis:
                return AppTextService.get(.my_qot_my_profile_support_section_contact_support_subtitle)
            case .featureRequest:
                return AppTextService.get(.my_qot_my_profile_support_section_feature_request_subtitle)
            case .introduction:
                return ""
            }
        }
    }
}
