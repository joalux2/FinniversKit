//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

final class AddressCardDemoView: UIView {
    private lazy var addressCardView: AddressCardView = {
        let view = AddressCardView(withAutoLayout: true)
        view.dropShadow(color: .black, opacity: 0.3, radius: 3)
        view.layer.cornerRadius = 16
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)
        addSubview(addressCardView)

        NSLayoutConstraint.activate([
            addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            addressCardView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension AddressCardDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case `default`
        case withoutDirectionsButton
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            addressCardView.configure(with: .default)
        case .withoutDirectionsButton:
            addressCardView.configure(with: .withoutDirectionsButton)
        }
    }
}

// MARK: - AddressCardViewDelegate

extension AddressCardDemoView: AddressCardViewDelegate {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView) {
        print("addressCardViewDidSelectCopyButton")
    }

    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView, sender: UIView) {
        print("addressCardViewDidSelectGetDirectionsButton")
    }
}

// MARK: - Demo data

private extension AddressCardViewModel {
    static var `default`: Self {
        Self.init(
            title: "Møllerøya 32",
            subtitle: "7982 Bindalseidet",
            copyButtonTitle: "Kopier adresse",
            getDirectionsButtonTitle: "Åpne veibeskrivelse"
        )
    }

    static var withoutDirectionsButton: Self {
        Self.init(
            title: "7982",
            subtitle: "Bindalseidet",
            copyButtonTitle: "Kopier adresse"
        )
    }
}
