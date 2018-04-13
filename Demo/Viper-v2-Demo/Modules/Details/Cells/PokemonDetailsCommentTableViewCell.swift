//
//  PokemonDetailsCommentTableViewCell.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class PokemonDetailsCommentTableViewCell: UITableViewCell {

    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: PokemonDetailsCommentItemInterface) {
        authorLabel.text = item.author
        commentLabel.text = item.text

        let dateString: String?
        if let date = item.date {
            dateString = DateFormatter.localizedString(
                from: date,
                dateStyle: .short,
                timeStyle: .short
            )
        } else {
            dateString = nil
        }
        dateLabel.text = dateString
    }

}
