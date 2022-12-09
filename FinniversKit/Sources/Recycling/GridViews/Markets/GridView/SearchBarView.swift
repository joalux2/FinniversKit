import Foundation

class SearchBarView: UIView {
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
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
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
