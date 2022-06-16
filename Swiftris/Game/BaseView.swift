//
//  BaseView.swift
//  Swiftris
//
//  Created by X on 2022/6/16.
//  Copyright © 2022 1minute2life. All rights reserved.
//

import UIKit

class BaseView: UIVisualEffectView {

    
    init() {
        super.init(effect: UIBlurEffect(style: .light))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
