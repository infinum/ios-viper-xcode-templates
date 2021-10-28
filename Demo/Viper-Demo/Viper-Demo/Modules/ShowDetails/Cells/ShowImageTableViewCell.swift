//
//  ShowImageTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import Foundation
import Kingfisher

class ShowImageTableViewCell: UITableViewCell {

    @IBOutlet private var showImageView: UIImageView! {
        didSet {
            showImageView.layer.masksToBounds = false
            showImageView.layer.cornerRadius = 10
            showImageView.clipsToBounds = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.kf.cancelDownloadTask()
    }

    func configure(with imageURL: String?) {

        guard let safeURL = URL(string: imageURL ?? "") else {
            showImageView.image = UIImage(named: "show_placeholder")
            return
        }

        showImageView.kf.setImage(with: safeURL, placeholder: UIImage(named: "show_placeholder"), options: nil, completionHandler: nil)
    }
}
