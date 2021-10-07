//
//  HomeTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import Foundation
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet private var showImageView: UIImageView! {
        didSet {
            showImageView.clipsToBounds = true
            showImageView.layer.masksToBounds = false
            showImageView.layer.cornerRadius = 5
        }
    }

    @IBOutlet private var showTitleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.kf.cancelDownloadTask()
    }

    func configure(with item: Show) {
        showTitleLabel.text = item.title

        guard let safeURL = URL(string: item.imageUrl ?? "") else {
            showImageView.image = UIImage(named: "show_placeholder")
            return
        }

        showImageView.kf.setImage(with: safeURL, placeholder: UIImage(named: "show_placeholder"), options: nil, completionHandler: nil)
        selectionStyle = .none
    }
}
