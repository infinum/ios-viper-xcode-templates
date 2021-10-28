//
//  AverageRatingTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

class AverageRatingTableViewCell: UITableViewCell {

    @IBOutlet private var averageRatingLabel: UILabel!
    @IBOutlet private var ratingStackView: RatingsStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.removeAllArrangedSubviews()
    }

    func configure(with numberOfReviews: Int, _ averageRating: Double) {
        averageRatingLabel.text = "\(numberOfReviews) reviews, \(averageRating) average".uppercased()
        ratingStackView.setRating(of: Int(averageRating))
    }
}
