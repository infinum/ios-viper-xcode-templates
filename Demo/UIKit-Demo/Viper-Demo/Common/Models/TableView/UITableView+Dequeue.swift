//
//  UITableView+Dequeue.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

public extension UITableView {

    /// Returns a reusable table-view cell object for the specified reuse identifier and type
    /// and adds it to the table.
    ///
    /// If identifier is not provided, cell type will be used as idenitifer.
    ///
    /// - Parameters:
    ///   - type: The class of a cell that you want to use in the table (must be a UITableViewCell subclass).
    ///   - identifier: Custom cell identifier
    ///   - indexPath: The index path specifying the location of the cell
    /// - Returns: A subclass of UITableViewCell object with the associated reuse identifier.
    func dequeueReusableCell<T: UITableViewCell>(
        ofType type: T.Type,
        withReuseIdentifier identifier: String? = nil,
        for indexPath: IndexPath
    ) -> T {
        let identifier = identifier ?? String(describing: type)
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }

    /// Returns a reusable header or footer view located by its identifier with concrete type.
    ///
    /// - Parameters:
    ///   - type: The class of a view that you want to use in the table (must be a UITableViewHeaderFooterView subclass).
    ///   - identifier: Custom header or footer view identifier
    /// - Returns: A subclass of UITableViewHeaderFooterView object with the associated reuse identifier.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        ofType type: T.Type,
        withReuseIdentifier identifier: String? = nil
    ) -> T {
        let identifier = identifier ?? String(describing: type)
        // swiftlint:disable:next force_cast
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }

}
