//
//  AverageRatingTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit

class AverageRatingTableViewCell: UITableViewCell {

    @IBOutlet private weak var averageRatingLabel: UILabel!
    @IBOutlet private weak var ratingStackView: RatingsStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.removeAllArrangedSubviews()
    }

    func configure(with numberOfReviews: Int, _ averageRating: Double) {
        averageRatingLabel.text = "\(numberOfReviews) reviews, \(averageRating) average".uppercased()
        ratingStackView.setRating(of: Int(averageRating))
    }
}
