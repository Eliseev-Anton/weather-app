import UIKit

final class LoadingView: UIView {

    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        spinner.color = .white
        label.text = "Загрузка погоды..."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .Weather.secondaryText
    }

    func startAnimating() {
        spinner.startAnimating()
    }

    func stopAnimating() {
        spinner.stopAnimating()
    }
}
