import Foundation
import CoreLocation

@MainActor
final class WeatherViewModel {

    private let weatherService: WeatherService
    private let locationService: LocationService

    var onStateChanged: ((ViewState) -> Void)?

    private(set) var state: ViewState = .loading {
        didSet { onStateChanged?(state) }
    }

    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func loadWeather() {
        state = .loading

        Task {
            do {
                let coordinate = await locationService.requestLocation()
                let data = try await weatherService.fetchWeather(for: coordinate)
                state = .loaded(data)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    func search(city: String) {
        let trimmed = city.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            loadWeather()
            return
        }
        state = .loading

        Task {
            do {
                let data = try await weatherService.fetchWeather(city: trimmed)
                state = .loaded(data)
            } catch {
                state = .error("Город не найден")
            }
        }
    }
}
