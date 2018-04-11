//
//  PokemonDetailsDescriptionTableViewCell.swift
//  Pokedex
//
//  Created by Filip Beć on 28/04/2017.
//  Copyright © 2017 Filip Beć. All rights reserved.
//

import UIKit

class PokemonDetailsDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: PokemonDetailsDescriptionItemInterface) {
        nameLabel.text = item.pokemonName
        descriptionLabel.text = item.pokemonDescription
    }

}
