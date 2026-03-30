import UIKit

final class ErrorView: UIView {

    var onRetry: (() -> Void)?

    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [iconView, messageLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
        iconView.image = UIImage(systemName: "exclamationmark.icloud.fill", withConfiguration: config)
        iconView.tintColor = .Weather.secondaryText
        iconView.contentMode = .scaleAspectFit

        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .Weather.secondaryText
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        retryButton.setTitle("Повторить", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        retryButton.layer.cornerRadius = 12
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    func configure(message: String) {
        messageLabel.text = message
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}
