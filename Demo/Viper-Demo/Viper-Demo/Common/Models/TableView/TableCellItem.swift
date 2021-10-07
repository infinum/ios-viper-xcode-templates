//
//  TableCellItem.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit

/// Base interface for all table view cell items - used in conjuction with
/// `TableDataSourceDelegate`
public protocol TableCellItem: CellItem {

    // MARK: - Required methods and properties

    /// Dequeue and configure reusable cell at given index path
    /// from given table view
    ///
    /// Dequeued cell should be configured with current item before
    /// returning it.
    ///
    /// - Parameters:
    ///   - tableView: parent table view
    ///   - indexPath: index path of cell to configure
    /// - Returns: Dequeued, configured and reused cell
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

    // MARK: - Optional methods and properties

    /// Fixed cell height
    var height: CGFloat { get }

    /// Estimatated cell height
    ///
    /// If using auto layout - `height` property needs to return
    /// `UITableView.automaticDimension` in order to use estimated height
    var estimatedHeight: CGFloat { get }

    /// Tells the table view whether this item can be deleted by swiping.
    var canDelete: Bool { get }

    /// Notifies cell item when user selects table view cell.
    ///
    /// - Parameter indexPath: index path of a selected cell
    func didSelect(at indexPath: IndexPath)

    /// Notifies cell item when user deletes the table view cell.
    ///
    /// - Parameter indexPath: index path of a deleted cell
    func didDelete(at indexPath: IndexPath)

}

public extension TableCellItem {

    var height: CGFloat {
        return UITableView.automaticDimension
    }

    var estimatedHeight: CGFloat {
        return 44
    }

    var canDelete: Bool { false }

    func didSelect(at indexPath: IndexPath) {
        // Empty implementation
    }

    func didDelete(at indexPath: IndexPath) {
        // Empty implementation
    }

}
