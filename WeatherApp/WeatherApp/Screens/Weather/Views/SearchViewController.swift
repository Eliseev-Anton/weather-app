import UIKit

final class SearchViewController: UIViewController {

    var onCitySelected: ((String) -> Void)?

    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let searchBar = UISearchBar()
    private let cancelButton = UIButton(type: .system)
    private let headerStack = UIStackView()
    private let locationButton = UIButton(type: .system)
    private let separatorView = UIView()
    private let hintLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .clear

        // Blur фон на весь экран
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupSearchRow()
        setupSeparator()
        setupLocationButton()
        setupHint()
    }

    private func setupSearchRow() {
        // Search bar
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .white

        let textField = searchBar.searchTextField
        textField.textColor = .white
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        textField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.5)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Поиск города",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.4)]
        )
        textField.font = .systemFont(ofSize: 15)

        // Cancel
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancelButton.tintColor = .white
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)

        blurView.contentView.addSubview(searchBar)
        blurView.contentView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupSeparator() {
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupLocationButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let icon = UIImage(systemName: "location.fill", withConfiguration: config)

        var btnConfig = UIButton.Configuration.plain()
        btnConfig.image = icon
        btnConfig.title = "Моя геопозиция"
        btnConfig.imagePadding = 10
        btnConfig.baseForegroundColor = .white
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        locationButton.configuration = btnConfig
        locationButton.contentHorizontalAlignment = .leading
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)

        blurView.contentView.addSubview(locationButton)

        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupHint() {
        hintLabel.text = "Введите название города"
        hintLabel.font = .systemFont(ofSize: 15, weight: .regular)
        hintLabel.textColor = UIColor.white.withAlphaComponent(0.35)
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func locationTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCitySelected?("")
        }
    }

    private func submitSearch() {
        guard let city = searchBar.text?.trimmingCharacters(in: .whitespaces), !city.isEmpty else { return }
        dismiss(animated: true) { [weak self] in
            self?.onCitySelected?(city)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        submitSearch()
    }
}
