//
//  TableSectionItem.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit

/// Base interface for all table view section items - used in conjuction with
/// `TableDataSourceDelegate`
public protocol TableSectionItem: SectionItem {

    // MARK: - Required methods and properties

    var items: [TableCellItem] { get }

    // MARK: - Optional methods and properties

    var headerHeight: CGFloat { get }
    var estimatedHeaderHeight: CGFloat { get }
    var footerHeight: CGFloat { get }
    var estimatedFooterHeight: CGFloat { get }

    func headerView(from tableView: UITableView, at index: Int) -> UIView?
    func footerView(from tableView: UITableView, at index: Int) -> UIView?

    func titleForHeader(from tableView: UITableView, at index: Int) -> String?
    func titleForFooter(from tableView: UITableView, at index: Int) -> String?

}

public extension TableSectionItem {

    var headerHeight: CGFloat {
        return UITableView.automaticDimension
    }

    var footerHeight: CGFloat {
        return UITableView.automaticDimension
    }

    var estimatedHeaderHeight: CGFloat {
        return 0
    }

    var estimatedFooterHeight: CGFloat {
        return 0
    }

    func headerView(from tableView: UITableView, at index: Int) -> UIView? {
        return nil
    }

    func footerView(from tableView: UITableView, at index: Int) -> UIView? {
        return nil
    }

    func titleForHeader(from tableView: UITableView, at index: Int) -> String? {
        return nil
    }

    func titleForFooter(from tableView: UITableView, at index: Int) -> String? {
        return nil
    }

}

public extension Array where Element: TableSectionItem {

    subscript(indexPath: IndexPath) -> TableCellItem {
        return self[indexPath.section].items[indexPath.row]
    }

}

public extension Array where Element == TableSectionItem {

    subscript(indexPath: IndexPath) -> TableCellItem {
        return self[indexPath.section].items[indexPath.row]
    }

}
