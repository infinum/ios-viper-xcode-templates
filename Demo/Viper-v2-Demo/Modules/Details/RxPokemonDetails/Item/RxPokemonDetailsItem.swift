//
//  RxPokemonDetailsItem.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 27.09.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import RxCocoa

struct RxPokemonDetailsItem {
    let model: PokemonDetailsItem
}

extension RxPokemonDetailsItem: TableCellItem {

    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch model {
        case .description(let descriptionItem):
            let cell = tableView.dequeueReusableCell(ofType: PokemonDetailsDescriptionTableViewCell.self, for: indexPath)
            cell.configure(with: descriptionItem)
            return cell

        case .characteristics(let characteristicsItem):
            let cell = tableView.dequeueReusableCell(ofType: PokemonDetailsCharacteristicsTableViewCell.self, for: indexPath)
            cell.configure(with: characteristicsItem)
            return cell

        case .comment(let commentItem):
            let cell = tableView.dequeueReusableCell(ofType: PokemonDetailsCommentTableViewCell.self, for: indexPath)
            cell.configure(with: commentItem)
            return cell
        }
    }

}

struct RxPokemonDetailsSection: TableSectionItem {
    let items: [TableCellItem]
}
