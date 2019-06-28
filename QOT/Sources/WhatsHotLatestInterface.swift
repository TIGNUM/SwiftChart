//
//  WhatsHotLatestInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import Foundation

protocol WhatsHotLatestViewControllerInterface: class {
}

protocol  WhatsHotLatestPresenterInterface {
}

protocol  WhatsHotLatestInteractorInterface: Interactor {
    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void))
    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void))
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void))
    func presentWhatsHotArticle(selectedID: Int)
}

protocol WhatsHotLatestRouterInterface {
    func presentWhatsHotArticle(selectedID: Int)
}
