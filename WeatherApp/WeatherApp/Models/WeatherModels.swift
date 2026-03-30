import Foundation

// MARK: - Current Weather Response

struct CurrentWeatherResponse: Decodable {
    let location: Location
    let current: Current
}

// MARK: - Forecast Response

struct ForecastResponse: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Shared Models

struct Location: Decodable {
    let name: String
    let country: String
    let localtime: String
    let localtimeEpoch: Int

    enum CodingKeys: String, CodingKey {
        case name, country, localtime
        case localtimeEpoch = "localtime_epoch"
    }
}

struct Current: Decodable {
    let tempC: Double
    let feelslikeC: Double
    let humidity: Int
    let windKph: Double
    let condition: Condition
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case feelslikeC = "feelslike_c"
        case humidity
        case windKph = "wind_kph"
        case condition
        case uv
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, hour
    }
}

struct Day: Decodable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition
    let dailyChanceOfRain: Int

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
        case dailyChanceOfRain = "daily_chance_of_rain"
    }
}

struct Hour: Decodable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case condition
    }
}
