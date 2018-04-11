//
//  HomeTableViewCell.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        cellImageView.layer.borderWidth = 1.0 / UIScreen.main.scale
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.af_cancelImageRequest()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.layer.cornerRadius = cellImageView.frame.width / 2.0
    }

    func configure(with item: HomeViewItemInterface) {
        cellTextLabel.text = item.title

        if let url = item.imageURL {
            cellImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "image-placeholder"))
        } else {
            cellImageView.image = #imageLiteral(resourceName: "image-placeholder")
        }
    }

}
