//
//  TableViewReloader.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 27.09.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

/// Used in conjuction with TableDataSourceDelegate to provide a way
/// to control table view reloading behavior
public protocol TableViewReloader {

    /// Called when new data arrives and reload is necessary
    ///
    /// - Parameters:
    ///   - tableView: Current table view
    ///   - oldSections: Previous sections/items
    ///   - newSections: New sections/items
    func reload(
        _ tableView: UITableView,
        oldSections: [TableSectionItem]?,
        newSections: [TableSectionItem]?
    )

}

/// Reloads table view data simply calling table view reloadData method
public struct DefaultTableViewReloader: TableViewReloader {

    public init() { }

    public func reload(_ tableView: UITableView, oldSections: [TableSectionItem]?, newSections: [TableSectionItem]?) {
        tableView.reloadData()
    }

}
