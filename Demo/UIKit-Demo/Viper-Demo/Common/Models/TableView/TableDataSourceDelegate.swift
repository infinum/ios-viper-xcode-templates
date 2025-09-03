//
//  TableDataSourceDelegate.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Object serving as a data source and delegate for a table view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// table view data displaying.
///
/// It can handle both - sections and items
public class TableDataSourceDelegate: NSObject {

    // MARK: - Public properties

    /// Setting a sections will invoke internal reloader causing table view to refresh.
    public var sections: [TableSectionItem]? {
        didSet(oldValue) {
            _reloader.reload(_tableView, oldSections: oldValue, newSections: sections)
        }
    }

    /// Setting an items will invoke internal reloader causing table view to refresh.
    ///
    /// If there are multiple sections - then data is flattened to single array
    public var items: [TableCellItem]? {
        get {
            return sections?
                .map(\.items)
                .reduce(into: [TableCellItem]()) { $0 = $0 + $1 }
        }
        set {
            let section: TableSectionItem? = BlankTableSection(items: newValue)
            sections = [section].compactMap { $0 }
        }
    }

    // MARK: - Private properties

    private let _tableView: UITableView
    private let _reloader: TableViewReloader
    private let _disposeBag = DisposeBag()

    /// Creates a new data source delegate object responsible for handling
    /// table view data source and delegate logic.
    ///
    /// **If using the data source delegate object do not change the table view
    /// dataSource property since this object depends on it**
    ///
    /// Freely use `delegate` property since internally data source delegate will
    /// use pass through delegate.
    ///
    /// - Parameters:
    ///   - tableView: Table view to control
    ///   - reloader: Data reloader
    public init(tableView: UITableView, reloader: TableViewReloader = DefaultTableViewReloader()) {
        _tableView = tableView
        _reloader = reloader
        super.init()
        tableView.dataSource = self
        tableView.rx
            .setDelegate(self)
            .disposed(by: _disposeBag)
    }

}

extension TableDataSourceDelegate: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].items.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections![indexPath].cell(from: tableView, at: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].titleForHeader(from: tableView, at: section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections?[section].titleForFooter(from: tableView, at: section)
    }

}

extension TableDataSourceDelegate: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].estimatedHeaderHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].headerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].estimatedFooterHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].footerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath].estimatedHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath].height ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections?[section].headerView(from:tableView, at:section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections?[section].footerView(from:tableView, at:section)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections?[indexPath].didSelect(at: indexPath)
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return (sections?[indexPath].canDelete ?? false) ? .delete : .none
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard
            editingStyle == .delete,
            let item = sections?[indexPath],
            item.canDelete
            else { return }

        item.didDelete(at: indexPath)
    }

}
