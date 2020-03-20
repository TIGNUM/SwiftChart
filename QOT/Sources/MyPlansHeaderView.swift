//
//  MyPlansHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

class MyPlansHeaderView: UIView {

    static func instantiateFromNib(title: String?, theme: ThemeView?) -> MyPlansHeaderView {
         guard let headerView = R.nib.myPlansHeaderView.instantiate(withOwner: self).first as? MyPlansHeaderView else {
             fatalError("Cannot load header view")
         }
         let baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: headerView)
         baseHeaderView?.configure(title: title, subtitle: nil)
         ThemeText.strategyHeader.apply(title?.uppercased(), to: baseHeaderView?.titleLabel)
         theme?.apply(headerView)
         baseHeaderView?.addTo(superview: headerView)
         return headerView
     }
}
