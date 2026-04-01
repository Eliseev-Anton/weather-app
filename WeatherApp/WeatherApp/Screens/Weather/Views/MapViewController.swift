import UIKit
import MapKit

final class MapViewController: UIViewController {

    var onLocationSelected: ((CLLocationCoordinate2D) -> Void)?

    private let mapView = MKMapView()
    private let closeButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let pinAnnotation = MKPointAnnotation()

    private var selectedCoordinate: CLLocationCoordinate2D?

    private static let latKey = "map_last_lat"
    private static let lonKey = "map_last_lon"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupCloseButton()
        setupConfirmButton()
        setupTapGesture()
        restoreSavedPin()
    }

    // MARK: - Setup

    private func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.overrideUserInterfaceStyle = .dark
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let moscow = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let region = MKCoordinateRegion(center: moscow, latitudinalMeters: 500_000, longitudinalMeters: 500_000)
        mapView.setRegion(region, animated: false)
    }

    private func setupCloseButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 18
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupConfirmButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Показать погоду"
        config.image = UIImage(systemName: "cloud.sun.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor.systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
        confirmButton.configuration = config
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.alpha = 0
        confirmButton.transform = CGAffineTransform(translationX: 0, y: 20)
        view.addSubview(confirmButton)

        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.shadowOpacity = 0.3
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        confirmButton.layer.shadowRadius = 8

        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tap)
    }

    // MARK: - Saved Pin

    private func restoreSavedPin() {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: Self.latKey) != nil else { return }

        let lat = defaults.double(forKey: Self.latKey)
        let lon = defaults.double(forKey: Self.lonKey)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        selectedCoordinate = coordinate
        pinAnnotation.coordinate = coordinate
        mapView.addAnnotation(pinAnnotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100_000, longitudinalMeters: 100_000)
        mapView.setRegion(region, animated: false)

        geocodePin(coordinate)

        confirmButton.alpha = 1
        confirmButton.transform = .identity
    }

    private func savePin(_ coordinate: CLLocationCoordinate2D) {
        let defaults = UserDefaults.standard
        defaults.set(coordinate.latitude, forKey: Self.latKey)
        defaults.set(coordinate.longitude, forKey: Self.lonKey)
    }

    private func geocodePin(_ coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let name = placemarks?.first?.locality ?? placemarks?.first?.name {
                self?.pinAnnotation.title = name
            }
        }
    }

    // MARK: - Actions

    @objc private func mapTapped(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        selectedCoordinate = coordinate
        pinAnnotation.coordinate = coordinate

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pinAnnotation)

        geocodePin(coordinate)
        savePin(coordinate)

        if confirmButton.alpha == 0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.confirmButton.alpha = 1
                self.confirmButton.transform = .identity
            }
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func confirmTapped() {
        guard let coordinate = selectedCoordinate else { return }
        dismiss(animated: true) { [weak self] in
            self?.onLocationSelected?(coordinate)
        }
    }
}
