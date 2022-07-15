import UIKit

final class WishlistAdView: UIView {
    static let adImageWidth: CGFloat = 80
    static let verticalPadding: CGFloat = 24
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }
    
    var loadingColor: UIColor?
    
    // MARK: - Private properties
    
    private var viewModel: WishViewModel?
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel = Label(style: .bodyStrong, withAutoLayout: true)

    private lazy var addressLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
        return label
    }()
    
    private lazy var updateTimeLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
        return label
    }()
    
    private lazy var statusRibbon = RibbonView(withAutoLayout: true)
    private lazy var fallbackImage: UIImage = UIImage(named: .noImage)
    
    private lazy var contentView = UIView(withAutoLayout: true)
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - Internal
    
    func configure(with viewModel: WishViewModel) {
        self.viewModel = viewModel
        
        if let ribbonViewModel = viewModel.ribbonViewModel {
            statusRibbon.isHidden = false
            statusRibbon.configure(with: ribbonViewModel)
        } else {
            statusRibbon.isHidden = true
        }
        
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        addressLabel.text = viewModel.place
        if let updatedDate = viewModel.updateTime {
            updateTimeLabel.text = dateFormatter.string(from: updatedDate)
        }
    }
    
    func loadImage() {
        guard let viewModel = viewModel, let imagePath = viewModel.imageUrl else {
            imageView.setImage(fallbackImage, animated: false)
            return
        }
        
        imageView.loadImage(
            for: imagePath,
            imageWidth: WishlistAdView.adImageWidth,
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )
    }
    
    func resetContent() {
        imageView.cancelLoading()
        imageView.setImage(nil, animated: false)
        
        [titleLabel, priceLabel, addressLabel, updateTimeLabel].forEach {
            $0.text = nil
        }
    }
    
    func resetBackgroundColors() {
        imageView.backgroundColor = imageView.image == nil ? loadingColor : .clear
        
        if let ribbonViewModel = viewModel?.ribbonViewModel {
            statusRibbon.style = ribbonViewModel.style
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(contentView)
        contentView.fillInSuperview()
        
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(statusRibbon)
        
        infoStackView.addArrangedSubview(addressLabel)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(updateTimeLabel)
        
        infoStackView.setCustomSpacing(.spacingXXS, after: addressLabel)
        infoStackView.setCustomSpacing(.spacingS, after: titleLabel)
        infoStackView.setCustomSpacing(.spacingS, after: priceLabel)
        infoStackView.setCustomSpacing(.spacingS, after: updateTimeLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: WishlistAdView.adImageWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingS),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            infoStackView.topAnchor.constraint(equalTo: statusRibbon.bottomAnchor, constant: .spacingXS),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -WishlistAdView.verticalPadding),
            
            statusRibbon.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            statusRibbon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
        ])
    }
}
