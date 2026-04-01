import UIKit

final class WeatherViewController: UIViewController {

    private let viewModel: WeatherViewModel

    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let loadingView = LoadingView()
    private let errorView = ErrorView()

    private let currentWeatherView = CurrentWeatherView()
    private let hourlyView = HourlyCollectionView()
    private let dailyView = DailyForecastView()

    private let gradientLayer = CAGradientLayer()
    private let searchButton = UIButton(type: .system)

    // MARK: - Init

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupScrollView()
        setupContentStack()
        setupStateViews()
        setupSearchButton()
        bindViewModel()
        viewModel.loadWeather()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Setup

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.Weather.gradientTop.cgColor,
            UIColor.Weather.gradientBottom.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentStack() {
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        let insets = UIEdgeInsets(top: 60, left: 16, bottom: 32, right: 16)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: insets.top),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: insets.left),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -insets.right),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -insets.bottom),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(insets.left + insets.right))
        ])

        contentStack.addArrangedSubview(currentWeatherView)
        contentStack.addArrangedSubview(hourlyView)
        contentStack.addArrangedSubview(dailyView)
    }

    private func setupStateViews() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.addSubview(errorView)

        for stateView in [loadingView, errorView] {
            NSLayoutConstraint.activate([
                stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
                stateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
            ])
        }

        errorView.onRetry = { [weak self] in
            self?.viewModel.loadWeather()
        }
    }

    private func setupSearchButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        searchButton.setImage(image, for: .normal)
        searchButton.tintColor = .white
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 36),
            searchButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    // MARK: - Search

    @objc private func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.onCitySelected = { [weak self] city in
            self?.viewModel.search(city: city)
        }
        searchVC.modalPresentationStyle = .overFullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true)
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.applyState(state)
        }
    }

    private func applyState(_ state: ViewState) {
        switch state {
        case .loading:
            loadingView.isHidden = false
            errorView.isHidden = true
            scrollView.isHidden = true
            loadingView.startAnimating()

        case .loaded(let data):
            loadingView.isHidden = true
            errorView.isHidden = true
            scrollView.isHidden = false
            loadingView.stopAnimating()

            currentWeatherView.configure(with: data)
            hourlyView.configure(with: data.hourly)
            dailyView.configure(with: data.daily)

            animateContentAppearance()

        case .error(let message):
            loadingView.isHidden = true
            errorView.isHidden = false
            scrollView.isHidden = true
            loadingView.stopAnimating()
            errorView.configure(message: message)
        }
    }

    private func animateContentAppearance() {
        scrollView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.scrollView.alpha = 1
        }
    }
}
