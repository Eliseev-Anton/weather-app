import UIKit

final class TemperatureBarView: UIView {

    private let trackLayer = CALayer()
    private let fillLayer = CAGradientLayer()

    private var minTemp: Int = 0
    private var maxTemp: Int = 0
    private var globalMin: Int = 0
    private var globalMax: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        trackLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.cornerRadius = 2
        layer.addSublayer(trackLayer)

        fillLayer.cornerRadius = 2
        fillLayer.startPoint = CGPoint(x: 0, y: 0.5)
        fillLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(fillLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        trackLayer.frame = bounds
        applyFill()
    }

    func configure(min minTemp: Int, max maxTemp: Int, globalMin: Int, globalMax: Int) {
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.globalMin = globalMin
        self.globalMax = globalMax
        setNeedsLayout()
    }

    private func applyFill() {
        let range = globalMax - globalMin
        guard range > 0 else {
            fillLayer.frame = bounds
            fillLayer.colors = colors(for: minTemp, max: maxTemp)
            return
        }

        let startFraction = CGFloat(minTemp - globalMin) / CGFloat(range)
        let endFraction   = CGFloat(maxTemp - globalMin) / CGFloat(range)

        let x     = bounds.width * startFraction
        let width = Swift.max(bounds.width * (endFraction - startFraction), 8)
        fillLayer.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
        fillLayer.colors = colors(for: minTemp, max: maxTemp)
    }

    private func colors(for minTemp: Int, max maxTemp: Int) -> [CGColor] {
        let cold = UIColor.systemCyan
        let mild = UIColor.systemYellow
        let warm = UIColor.systemOrange

        let minColor = interpolate(cold, mild, t: CGFloat(minTemp + 20) / 40)
        let maxColor = interpolate(mild, warm, t: CGFloat(maxTemp - 5)  / 25)
        return [minColor.cgColor, maxColor.cgColor]
    }

    private func interpolate(_ a: UIColor, _ b: UIColor, t: CGFloat) -> UIColor {
        let t = Swift.min(Swift.max(t, 0), 1)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0
        a.getRed(&r1, green: &g1, blue: &b1, alpha: nil)
        b.getRed(&r2, green: &g2, blue: &b2, alpha: nil)
        return UIColor(red: r1 + (r2-r1)*t, green: g1 + (g2-g1)*t, blue: b1 + (b2-b1)*t, alpha: 1)
    }
}
