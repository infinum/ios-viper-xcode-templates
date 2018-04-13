//
//  UITableView+DequeueCell.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/13/18.
//  Copyright © 2018 Infinum. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, withReuseIdentifier identifier: String? = nil, for indexPath: IndexPath) -> T {
        let identifier = identifier ?? String(describing: type)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
