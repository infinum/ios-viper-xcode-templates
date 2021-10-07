//
//  AddReviewTableViewCell.swift
//  Viper-Demo
//
//  Created by Zvonimir Medak on 07.10.2021..
//

import UIKit
import RxSwift
import RxCocoa

class AddReviewTableViewCell: UITableViewCell {

    @IBOutlet private weak var addReviewButton: UIButton!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configure(with openReviewsRelay: PublishRelay<String>?, _ showId: String?) {
        guard let openReviewsRelay = openReviewsRelay else {
            return
        }

        addReviewButton
            .rx
            .tap
            .asSignal()
            .compactMap { showId }
            .emit(to: openReviewsRelay)
            .disposed(by: disposeBag)
    }
}
