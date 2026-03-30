import Foundation
import CoreLocation

final class WeatherService {

    private let networkService: NetworkService
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private let baseURL = "http://api.weatherapi.com/v1"

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherData {
        let query = "\(coordinate.latitude),\(coordinate.longitude)"

        guard let forecastURL = URL(string: "\(baseURL)/forecast.json?key=\(apiKey)&q=\(query)&days=3") else {
            throw NetworkError.invalidURL
        }

        let response: ForecastResponse = try await networkService.request(forecastURL)
        return mapToWeatherData(response)
    }

    private func mapToWeatherData(_ response: ForecastResponse) -> WeatherData {
        let current = CurrentInfo(
            temperature: Int(response.current.tempC.rounded()),
            feelsLike: Int(response.current.feelslikeC.rounded()),
            conditionText: response.current.condition.text,
            conditionCode: response.current.condition.code,
            humidity: response.current.humidity,
            windKph: response.current.windKph,
            uv: response.current.uv
        )

        let hourly = buildHourlyItems(from: response)
        let daily = buildDailyItems(from: response.forecast.forecastday)

        return WeatherData(
            cityName: response.location.name,
            current: current,
            hourly: hourly,
            daily: daily
        )
    }

    private func buildHourlyItems(from response: ForecastResponse) -> [HourlyItem] {
        let currentEpoch = response.location.localtimeEpoch
        var items: [HourlyItem] = []

        for (dayIndex, day) in response.forecast.forecastday.enumerated() {
            for hour in day.hour {
                // Сегодня — только оставшиеся часы, завтра — все
                if dayIndex == 0 && hour.timeEpoch < currentEpoch {
                    continue
                }
                // Пропускаем третий день для почасового прогноза
                if dayIndex >= 2 {
                    continue
                }

                let timeString = formatHourTime(hour.time)
                let isNow = dayIndex == 0 && items.isEmpty

                items.append(HourlyItem(
                    time: isNow ? "Сейчас" : timeString,
                    temperature: Int(hour.tempC.rounded()),
                    conditionCode: hour.condition.code,
                    isNow: isNow
                ))
            }
        }

        return items
    }

    private func buildDailyItems(from days: [ForecastDay]) -> [DailyItem] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"

        return days.enumerated().map { index, day in
            var dayName: String
            if index == 0 {
                dayName = "Сегодня"
            } else {
                if let date = formatter.date(from: day.date) {
                    let nameFormatter = DateFormatter()
                    nameFormatter.locale = Locale(identifier: "ru_RU")
                    nameFormatter.dateFormat = "EEEE"
                    dayName = nameFormatter.string(from: date).capitalized
                } else {
                    dayName = day.date
                }
            }

            return DailyItem(
                dayName: dayName,
                date: day.date,
                minTemp: Int(day.day.mintempC.rounded()),
                maxTemp: Int(day.day.maxtempC.rounded()),
                conditionCode: day.day.condition.code,
                chanceOfRain: day.day.dailyChanceOfRain
            )
        }
    }

    private func formatHourTime(_ time: String) -> String {
        // time формат: "2024-04-23 14:00" → "14:00"
        let components = time.split(separator: " ")
        if components.count == 2 {
            return String(components[1])
        }
        return time
    }
}
