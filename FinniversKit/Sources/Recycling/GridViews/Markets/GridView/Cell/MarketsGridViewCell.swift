//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewCell: UICollectionViewCell {
    // MARK: - Internal properties

    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .externalLinkColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label: Label
        if isHorizontalSizeClassRegular {
            label = Label(style: .caption)
        } else {
            label = Label(style: .detail)
            label.font = UIFont.detail.withSize(11)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private lazy var iconTopAnchor = iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS)
    private lazy var titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingS)

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .clear

        addSubview(externalLinkImageView)
        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconTopAnchor,
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor),

            titleTopAnchor,
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            externalLinkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            externalLinkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            externalLinkImageView.widthAnchor.constraint(equalToConstant: 12),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    // MARK: - Superclass Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Dependency injection

    var model: MarketsViewModel? {
        didSet {
            iconImageView.image = model?.iconImage
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel

            let showExternalLinkIcon = model?.showExternalLinkIcon ?? false
            externalLinkImageView.isHidden = !showExternalLinkIcon

            let supportsMultilineTitle = model?.multilineTitle ?? false
            if supportsMultilineTitle {
                iconTopAnchor.constant = 0
                titleTopAnchor.constant = .spacingS
                titleLabel.numberOfLines = 2
            }
        }
    }
}

// TODO: - These colors should be added to the ColorProvider at some point
private extension UIColor {
    class var externalLinkColor: UIColor {
        return .blueGray400
    }

    class var tileSharpShadowColor: UIColor {
        return .blueGray600
    }

    class var tileSmoothShadowColor: UIColor {
        return .blueGray600
    }

    class var tileBackgroundColor: UIColor {
        return .dynamicColor(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}
