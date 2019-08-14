//
//  ImpactReadinessItem.swift
//  QOT
//
//  Created by Srikanth Roopa on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct ImpactReadinessItem {
    var title: String?
    var subTitle: String?
    var averageValue: Double?
    var targetRefValue: Double?

    func isContentEqual(to source: ImpactReadinessItem) -> Bool {
        return title == source.title

    }
    var differenceIdentifier: String {
        return title ?? ""
    }
}
