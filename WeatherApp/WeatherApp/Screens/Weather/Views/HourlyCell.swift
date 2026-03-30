import UIKit

final class HourlyCell: UICollectionViewCell {

    static let reuseID = "HourlyCell"

    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])

        timeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .Weather.primaryText
        timeLabel.textAlignment = .center

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28)
        ])

        tempLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tempLabel.textColor = .Weather.primaryText
        tempLabel.textAlignment = .center

        stack.addArrangedSubview(timeLabel)
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(tempLabel)
    }

    func configure(with item: HourlyItem) {
        timeLabel.text = item.time
        tempLabel.text = "\(item.temperature)°"
        iconView.image = WeatherIcon.image(for: item.conditionCode, pointSize: 24)

        if item.isNow {
            timeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        } else {
            timeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        }
    }
}
