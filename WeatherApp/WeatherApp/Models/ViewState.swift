import Foundation

enum ViewState {
    case loading
    case loaded(WeatherData)
    case error(String)
}

struct WeatherData {
    let cityName: String
    let current: CurrentInfo
    let hourly: [HourlyItem]
    let daily: [DailyItem]
}

struct CurrentInfo {
    let temperature: Int
    let feelsLike: Int
    let conditionText: String
    let conditionCode: Int
    let humidity: Int
    let windKph: Double
    let uv: Double
}

struct HourlyItem {
    let time: String
    let temperature: Int
    let conditionCode: Int
    let isNow: Bool
}

struct DailyItem {
    let dayName: String
    let date: String
    let minTemp: Int
    let maxTemp: Int
    let conditionCode: Int
    let chanceOfRain: Int
}
