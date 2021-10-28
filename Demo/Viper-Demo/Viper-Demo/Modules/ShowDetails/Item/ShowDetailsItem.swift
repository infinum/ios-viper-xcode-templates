//
//  DetailsItem.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit
import RxCocoa

struct ShowWithReviews {
    let show: Show?
    let review: Review?
}

enum ShowDetailsCellType {
    case image, description, reviewsTitle, averageRating, noReviews, addReview, review
}

struct ShowDetailsItem {
    let model: ShowWithReviews
    let type: ShowDetailsCellType

    init(model: ShowWithReviews, type: ShowDetailsCellType) {
        self.model = model
        self.type = type
    }
}

extension ShowDetailsItem: TableCellItem {

    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .image:
            let cell = tableView.dequeueReusableCell(ofType: ShowImageTableViewCell.self, for: indexPath)
            cell.configure(with: model.show?.imageUrl)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(ofType: ShowDescriptionTableViewCell.self, for: indexPath)
            cell.configure(with: model.show?.description)
            return cell
        case .reviewsTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.reviewsTitleCell, for: indexPath)
            return cell
        case .averageRating:
            let cell = tableView.dequeueReusableCell(ofType: AverageRatingTableViewCell.self, for: indexPath)
            cell.configure(with: model.show?.noOfReviews ?? 0, model.show?.averageRating ?? 0)
            return cell
        case .noReviews:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.noReviewsCell, for: indexPath)
            return cell
        case .addReview:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.addReviewCell, for: indexPath)
            return cell
        case .review:
            let cell = tableView.dequeueReusableCell(ofType: ReviewTableViewCell.self, for: indexPath)
            cell.configure(with: model.review)
            return cell
        }
    }
}

struct ShowDetailsSection: TableSectionItem {
    let items: [TableCellItem]
}

