//
//  MyWhyView.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyWhyView: UIView {

    // MARK: - Properties

    var myWhyItems = [MyWhy]()

    init(myWhyItems: [MyWhy], frame: CGRect) {
        self.myWhyItems = myWhyItems

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .red
    }
}
