//
//  RxPokemonDetailsInterfaces.swift
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

protocol RxPokemonDetailsWireframeInterface: WireframeInterface {
}

protocol RxPokemonDetailsViewInterface: ViewInterface {
}

protocol RxPokemonDetailsPresenterInterface: PresenterInterface {
    func configure(with output: RxPokemonDetails.ViewOutput) -> RxPokemonDetails.ViewInput
}

protocol RxPokemonDetailsFormatterInterface: FormatterInterface {
    func format(for input: RxPokemonDetails.FormatterInput) -> RxPokemonDetails.FormatterOutput
}

protocol RxPokemonDetailsInteractorInterface: InteractorInterface {
}

enum RxPokemonDetails {

    struct ViewOutput {
    }

    struct ViewInput {
        let models: FormatterOutput
        let events: RxPokemonDetailsEvent
    }

    struct FormatterInput {
        let models: Driver<Pokemon>
    }

    struct FormatterOutput {
        let sections: Driver<[TableSectionItem]>
    }

}

struct RxPokemonDetailsEvent {
    let title: Driver<String>
    let imageURL: Signal<URL>
}