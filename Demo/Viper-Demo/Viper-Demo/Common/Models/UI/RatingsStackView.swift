//
//  RatingsStackView.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

class RatingsStackView: UIStackView {

    private static let maxRating = 5

    func setRating(of rating: Int, withButtons: Bool = false) {
        if withButtons {
            addStarButtons(filled: rating, notFilled: RatingsStackView.maxRating - rating)
        } else {
            addStarImages(filled: rating, notFilled: RatingsStackView.maxRating - rating)
        }
    }

    func addStarImages(filled: Int, notFilled: Int) {
        (1...filled).forEach { _ in
            addArrangedSubview(UIImageView(image: UIImage(named: "star_selected")))
        }

        guard notFilled != 0 else { return }

        (1...notFilled).forEach { _ in
            addArrangedSubview(UIImageView(image: UIImage(named: "star_unselected")))
        }
    }

    func addStarButtons(filled: Int, notFilled: Int) {

        let ratingButton: (_ tag: Int, _ selected: Bool) -> UIButton = { tag, selected in
            let ratingButton = UIButton()
            ratingButton.tag = tag
            ratingButton.setBackgroundImage(UIImage(named: "star_selected"), for: .selected)
            ratingButton.setBackgroundImage(UIImage(named: "star_unselected"), for: .normal)
            ratingButton.isSelected = selected
            return ratingButton
        }

        guard filled == 0  else {
            (1...filled).forEach { i in
                addArrangedSubview(ratingButton(i, true))
            }
            (arrangedSubviews.count...RatingsStackView.maxRating).forEach { i in
                addArrangedSubview(ratingButton(i, false))
            }
            return
        }

        (arrangedSubviews.count + 1...RatingsStackView.maxRating).forEach { i in
            addArrangedSubview(ratingButton(i, false))
        }
    }

    func setButtonState(for rating: Int) {
        arrangedSubviews.forEach { view in
            guard let ratingButton = view as? UIButton else {
                return
            }
            ratingButton.isSelected = ratingButton.tag <= rating ? true : false
        }
    }
}
