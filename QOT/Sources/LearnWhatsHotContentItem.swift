//
//  LearnWhatsHotContentItem.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol LearnWhatsHotContentItem {

    var contentItemValue: ContentItemValue { get }

}

extension ContentItem: LearnWhatsHotContentItem {
    
}
