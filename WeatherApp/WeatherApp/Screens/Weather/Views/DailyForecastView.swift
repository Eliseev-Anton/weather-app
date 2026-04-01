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

        let globalMin = items.map { $0.minTemp }.min() ?? 0
        let globalMax = items.map { $0.maxTemp }.max() ?? 0

        for (index, item) in items.enumerated() {
            let row = makeDayRow(item, globalMin: globalMin, globalMax: globalMax)
            rowsStack.addArrangedSubview(row)

            if index < items.count - 1 {
                let insetWrapper = UIView()
                insetWrapper.translatesAutoresizingMaskIntoConstraints = false

                let sep = UIView()
                sep.backgroundColor = .Weather.separator
                sep.translatesAutoresizingMaskIntoConstraints = false
                insetWrapper.addSubview(sep)

                NSLayoutConstraint.activate([
                    insetWrapper.heightAnchor.constraint(equalToConstant: 0.5),
                    sep.topAnchor.constraint(equalTo: insetWrapper.topAnchor),
                    sep.bottomAnchor.constraint(equalTo: insetWrapper.bottomAnchor),
                    sep.leadingAnchor.constraint(equalTo: insetWrapper.leadingAnchor, constant: 16),
                    sep.trailingAnchor.constraint(equalTo: insetWrapper.trailingAnchor, constant: -16)
                ])

                rowsStack.addArrangedSubview(insetWrapper)
            }
        }
    }

    private func makeDayRow(_ item: DailyItem, globalMin: Int, globalMax: Int) -> UIView {
        let container = UIView()
        container.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let dayLabel = UILabel()
        dayLabel.text = item.dayName
        dayLabel.font = .systemFont(ofSize: 17, weight: .medium)
        dayLabel.textColor = .Weather.primaryText
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = WeatherIcon.image(for: item.conditionCode, pointSize: 18)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let minLabel = UILabel()
        minLabel.text = "\(item.minTemp)°"
        minLabel.font = .systemFont(ofSize: 17, weight: .regular)
        minLabel.textColor = .Weather.secondaryText
        minLabel.textAlignment = .right
        minLabel.translatesAutoresizingMaskIntoConstraints = false

        let barView = TemperatureBarView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.configure(min: item.minTemp, max: item.maxTemp, globalMin: globalMin, globalMax: globalMax)

        let maxLabel = UILabel()
        maxLabel.text = "\(item.maxTemp)°"
        maxLabel.font = .systemFont(ofSize: 17, weight: .medium)
        maxLabel.textColor = .Weather.primaryText
        maxLabel.textAlignment = .right
        maxLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(dayLabel)
        container.addSubview(iconView)
        container.addSubview(minLabel)
        container.addSubview(barView)
        container.addSubview(maxLabel)

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalToConstant: 80),

            iconView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 4),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            minLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            minLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            minLabel.widthAnchor.constraint(equalToConstant: 34),

            barView.leadingAnchor.constraint(equalTo: minLabel.trailingAnchor, constant: 6),
            barView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            barView.heightAnchor.constraint(equalToConstant: 4),

            maxLabel.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: 6),
            maxLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            maxLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            maxLabel.widthAnchor.constraint(equalToConstant: 34)
        ])

        return container
    }
}
