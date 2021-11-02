//
//  UIStackView+Subviews.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
