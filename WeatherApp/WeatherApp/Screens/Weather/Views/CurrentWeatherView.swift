import UIKit

final class CurrentWeatherView: UIView {

    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let detailsStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        cityLabel.font = .systemFont(ofSize: 34, weight: .regular)
        cityLabel.textColor = .Weather.primaryText
        cityLabel.textAlignment = .center

        temperatureLabel.font = .systemFont(ofSize: 96, weight: .thin)
        temperatureLabel.textColor = .Weather.primaryText
        temperatureLabel.textAlignment = .center

        conditionLabel.font = .systemFont(ofSize: 20, weight: .medium)
        conditionLabel.textColor = .Weather.primaryText
        conditionLabel.textAlignment = .center

        feelsLikeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        feelsLikeLabel.textColor = .Weather.secondaryText
        feelsLikeLabel.textAlignment = .center

        stack.addArrangedSubview(cityLabel)
        stack.addArrangedSubview(temperatureLabel)
        stack.addArrangedSubview(conditionLabel)
        stack.addArrangedSubview(feelsLikeLabel)

        stack.setCustomSpacing(0, after: cityLabel)
        stack.setCustomSpacing(4, after: temperatureLabel)
        stack.setCustomSpacing(8, after: conditionLabel)

        setupDetailsRow()
        stack.addArrangedSubview(detailsStack)
        stack.setCustomSpacing(20, after: feelsLikeLabel)
    }

    private func setupDetailsRow() {
        detailsStack.axis = .horizontal
        detailsStack.distribution = .equalSpacing
        detailsStack.spacing = 24
    }

    private func makeDetailItem(icon: String, value: String) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 4
        container.alignment = .center

        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        imageView.image = UIImage(systemName: icon, withConfiguration: config)
        imageView.tintColor = .Weather.secondaryText
        imageView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .Weather.secondaryText
        label.text = value

        container.addArrangedSubview(imageView)
        container.addArrangedSubview(label)
        return container
    }

    func configure(with data: WeatherData) {
        cityLabel.text = data.cityName
        temperatureLabel.text = "\(data.current.temperature)°"
        conditionLabel.text = data.current.conditionText
        feelsLikeLabel.text = "Ощущается как \(data.current.feelsLike)°"

        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        detailsStack.addArrangedSubview(makeDetailItem(icon: "humidity.fill", value: "\(data.current.humidity)%"))
        detailsStack.addArrangedSubview(makeDetailItem(icon: "wind", value: "\(Int(data.current.windKph)) км/ч"))
        detailsStack.addArrangedSubview(makeDetailItem(icon: "sun.max.fill", value: "UV \(Int(data.current.uv))"))
    }
}
