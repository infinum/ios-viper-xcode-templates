//
//  RxPokemonDetailsFormatter.swift
//  Viper-v2-Demo
//
//  Created by Zvonimir Medak on 27.09.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class RxPokemonDetailsFormatter {
}

// MARK: - Extensions -

extension RxPokemonDetailsFormatter: RxPokemonDetailsFormatterInterface {

    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput {
        return RxPokemonDetails.FormatterOutput(sections: createTableViewSections(from: input.models))
    }

}

private extension RxPokemonDetailsFormatter {

    func createTableViewSections(from pokemon: Driver<Pokemon>) -> Driver<[TableSectionItem]> {
        pokemon
            .map { [unowned self] in  createSections(with: $0)}
    }

    func createSections(with pokemon: Pokemon) -> [TableSectionItem] {
        var items: [TableSectionItem] = []
        items.append(createDescriptionSection(pokemon))
        return items
    }

    func createDescriptionSection(_ pokemon: Pokemon) -> TableSectionItem {
        return RxPokemonDetailsSection(items: [RxPokemonDetailsItem(model: PokemonDetailsItem.description(pokemon))])
    }

}
