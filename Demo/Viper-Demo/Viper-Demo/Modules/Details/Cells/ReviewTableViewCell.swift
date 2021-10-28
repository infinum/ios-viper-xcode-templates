//
//  ReviewTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit
import Kingfisher

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            profileImageView.clipsToBounds = true
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = 25
        }
    }
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var ratingStackView: RatingsStackView!
    @IBOutlet private var commentlabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.cancelDownloadTask()
        ratingStackView.removeAllArrangedSubviews()
    }

    func configure(with item: Review?) {
        usernameLabel.text = item?.user.email
        commentlabel.text = item?.comment
        ratingStackView.setRating(of: item?.rating ?? 0)
        guard let safeURL = URL(string: item?.user.imageUrl ?? "") else {
            profileImageView.image = UIImage(named: "profile_placeholder")
            return
        }

        profileImageView.kf.setImage(with: safeURL, placeholder: UIImage(named: "profile_placeholder"), options: nil, completionHandler: nil)
    }
}
