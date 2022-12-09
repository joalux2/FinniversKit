import Foundation

class SearchBarView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        return imageView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.searchBarStyle = .default
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.backgroundColor = .bgPrimary
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedLineAtBottom()
    }

    private func setup() {
        addSubview(imageView)
        addSubview(searchBar)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            searchBar.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),

            heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func configure(withPlaceholder placeholder: String, icon: UIImage) {
        searchBar.placeholder = placeholder
        imageView.image = icon
    }
}

extension UIView {
    func addDashedLineAtBottom(width: CGFloat = 1 / UIScreen.main.scale, color: CGColor = .tableViewSeparator) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [6,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: frame.height), CGPoint(x: frame.width, y: frame.height)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
}
