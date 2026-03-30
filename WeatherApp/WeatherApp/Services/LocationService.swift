import CoreLocation

final class LocationService: NSObject {

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Never>?

    private static let moscowCoordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() async -> CLLocationCoordinate2D {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                self.continuation = continuation
                manager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            return await fetchLocation()
        default:
            return Self.moscowCoordinate
        }
    }

    private func fetchLocation() async -> CLLocationCoordinate2D {
        if let location = manager.location {
            return location.coordinate
        }

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard continuation != nil else { return }

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            let cont = continuation
            continuation = nil
            cont?.resume(returning: Self.moscowCoordinate)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = locations.first?.coordinate ?? Self.moscowCoordinate
        let cont = continuation
        continuation = nil
        cont?.resume(returning: coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let cont = continuation
        continuation = nil
        cont?.resume(returning: Self.moscowCoordinate)
    }
}
