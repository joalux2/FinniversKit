import UIKit

public class WishlistAdTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    public var loadingColor: UIColor?
    
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            adView.remoteImageViewDataSource = remoteImageViewDataSource
        }
    }
    
    // MARK: - Private properties
    
    private lazy var adView: WishlistAdView = {
        let view = WishlistAdView(withAutoLayout: true)
        return view
    }()
    
    // MARK: - Init
    
    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - Overrides
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        adView.resetContent()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        adView.resetBackgroundColors()
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        adView.resetBackgroundColors()
    }
    
    // MARK: - Public methods
    
    public func configure(with viewModel: WishViewModel) {
        separatorInset = .leadingInset(.spacingXL + WishlistAdView.adImageWidth)
        adView.configure(with: viewModel)
    }
    
    public func loadImage() {
        adView.loadImage()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .bgPrimary
        setDefaultSelectedBackgound()
        contentView.addSubview(adView)
        adView.fillInSuperview()
    }
}
