import UIKit

final class DailyForecastView: UIView {

    private let titleLabel = UILabel()
    private let rowsStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .Weather.cardBackground
        layer.cornerRadius = 16
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.Weather.cardBorder.cgColor
        clipsToBounds = true

        titleLabel.text = "ПРОГНОЗ НА 3 ДНЯ"
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .Weather.secondaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        let separator = UIView()
        separator.backgroundColor = .Weather.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)

        rowsStack.axis = .vertical
        rowsStack.spacing = 0
        rowsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rowsStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            rowsStack.topAnchor.constraint(equalTo: separator.bottomAnchor),
            rowsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rowsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            rowsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with items: [DailyItem]) {
        rowsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, item) in items.enumerated() {
            let row = makeDayRow(item)
            rowsStack.addArrangedSubview(row)

            if index < items.count - 1 {
                let sep = UIView()
                sep.backgroundColor = .Weather.separator
                sep.translatesAutoresizingMaskIntoConstraints = false
                sep.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                rowsStack.addArrangedSubview(sep)

                let insetWrapper = UIView()
                insetWrapper.addSubview(sep)
                sep.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    sep.topAnchor.constraint(equalTo: insetWrapper.topAnchor),
                    sep.bottomAnchor.constraint(equalTo: insetWrapper.bottomAnchor),
                    sep.leadingAnchor.constraint(equalTo: insetWrapper.leadingAnchor, constant: 16),
                    sep.trailingAnchor.constraint(equalTo: insetWrapper.trailingAnchor, constant: -16)
                ])

                // Replace: remove sep from rowsStack, add wrapper instead
                rowsStack.removeArrangedSubview(sep)
                sep.removeFromSuperview()
                rowsStack.addArrangedSubview(insetWrapper)
            }
        }
    }

    private func makeDayRow(_ item: DailyItem) -> UIView {
        let container = UIView()
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let dayLabel = UILabel()
        dayLabel.text = item.dayName
        dayLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = .Weather.primaryText
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = WeatherIcon.image(for: item.conditionCode, pointSize: 20)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let rainLabel = UILabel()
        if item.chanceOfRain > 0 {
            rainLabel.text = "\(item.chanceOfRain)%"
            rainLabel.font = .systemFont(ofSize: 13, weight: .medium)
            rainLabel.textColor = UIColor.systemCyan
        }
        rainLabel.translatesAutoresizingMaskIntoConstraints = false

        let minLabel = UILabel()
        minLabel.text = "\(item.minTemp)°"
        minLabel.font = .systemFont(ofSize: 16, weight: .regular)
        minLabel.textColor = .Weather.secondaryText
        minLabel.textAlignment = .right
        minLabel.translatesAutoresizingMaskIntoConstraints = false

        let maxLabel = UILabel()
        maxLabel.text = "\(item.maxTemp)°"
        maxLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        maxLabel.textColor = .Weather.primaryText
        maxLabel.textAlignment = .right
        maxLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(dayLabel)
        container.addSubview(iconView)
        container.addSubview(rainLabel)
        container.addSubview(minLabel)
        container.addSubview(maxLabel)

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalToConstant: 110),

            iconView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),

            rainLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 4),
            rainLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            rainLabel.widthAnchor.constraint(equalToConstant: 36),

            maxLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            maxLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            maxLabel.widthAnchor.constraint(equalToConstant: 36),

            minLabel.trailingAnchor.constraint(equalTo: maxLabel.leadingAnchor, constant: -12),
            minLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            minLabel.widthAnchor.constraint(equalToConstant: 36)
        ])

        return container
    }
}
