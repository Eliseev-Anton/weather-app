import XCTest
@testable import WeatherApp

final class WeatherServiceTests: XCTestCase {

    func testMapCurrentInfo() throws {
        let response = makeForecastResponse(tempC: 15.4, feelslike: 12.6, humidity: 65, wind: 11.2, uv: 4.0)
        let service = WeatherService()

        let data = service.testMapToWeatherData(response)

        XCTAssertEqual(data.cityName, "Moscow")
        XCTAssertEqual(data.current.temperature, 15)
        XCTAssertEqual(data.current.feelsLike, 13)
        XCTAssertEqual(data.current.humidity, 65)
        XCTAssertEqual(data.current.windKph, 11.2)
        XCTAssertEqual(data.current.uv, 4.0)
    }

    func testHourlyFiltering() throws {
        let response = makeForecastResponse(tempC: 15.0, feelslike: 13.0, humidity: 60, wind: 10.0, uv: 3.0)
        let service = WeatherService()

        let data = service.testMapToWeatherData(response)

        // Первый час (12:00) раньше localtime_epoch (14:00) → отфильтрован
        // Остаётся 15:00 сегодня + 12:00 завтра
        XCTAssertEqual(data.hourly.count, 2)
        XCTAssertEqual(data.hourly[0].time, "Сейчас")
        XCTAssertTrue(data.hourly[0].isNow)
        XCTAssertEqual(data.hourly[0].temperature, 16)
        XCTAssertEqual(data.hourly[1].time, "12:00")
        XCTAssertFalse(data.hourly[1].isNow)
    }

    func testDailyItems() throws {
        let response = makeForecastResponse(tempC: 15.0, feelslike: 13.0, humidity: 60, wind: 10.0, uv: 3.0)
        let service = WeatherService()

        let data = service.testMapToWeatherData(response)

        XCTAssertEqual(data.daily.count, 2)
        XCTAssertEqual(data.daily[0].dayName, "Сегодня")
        XCTAssertEqual(data.daily[0].minTemp, 8)
        XCTAssertEqual(data.daily[0].maxTemp, 18)
        XCTAssertEqual(data.daily[0].chanceOfRain, 20)
    }

    func testTemperatureRounding() throws {
        let response = makeForecastResponse(tempC: 15.5, feelslike: 12.4, humidity: 60, wind: 10.0, uv: 3.0)
        let service = WeatherService()

        let data = service.testMapToWeatherData(response)

        XCTAssertEqual(data.current.temperature, 16)  // 15.5 → 16
        XCTAssertEqual(data.current.feelsLike, 12)     // 12.4 → 12
    }

    func testWeatherIconMapping() {
        XCTAssertEqual(WeatherIcon.sfSymbolName(for: 1000), "sun.max.fill")
        XCTAssertEqual(WeatherIcon.sfSymbolName(for: 1003), "cloud.sun.fill")
        XCTAssertEqual(WeatherIcon.sfSymbolName(for: 1195), "cloud.heavyrain.fill")
        XCTAssertEqual(WeatherIcon.sfSymbolName(for: 1273), "cloud.bolt.rain.fill")
        XCTAssertEqual(WeatherIcon.sfSymbolName(for: 9999), "cloud.fill") // unknown → default
    }
}

// MARK: - Test Helpers

extension WeatherServiceTests {

    private func makeForecastResponse(
        tempC: Double,
        feelslike: Double,
        humidity: Int,
        wind: Double,
        uv: Double
    ) -> ForecastResponse {
        let condition = Condition(text: "Partly cloudy", icon: "", code: 1003)

        return ForecastResponse(
            location: Location(name: "Moscow", country: "Russia", localtime: "2024-04-23 14:00", localtimeEpoch: 1713877200),
            current: Current(tempC: tempC, feelslikeC: feelslike, humidity: humidity, windKph: wind, condition: condition, uv: uv),
            forecast: Forecast(forecastday: [
                ForecastDay(
                    date: "2024-04-23",
                    dateEpoch: 1713830400,
                    day: Day(maxtempC: 18.0, mintempC: 8.0, condition: condition, dailyChanceOfRain: 20),
                    hour: [
                        Hour(timeEpoch: 1713855600, time: "2024-04-23 12:00", tempC: 14.0, condition: condition),
                        Hour(timeEpoch: 1713888000, time: "2024-04-23 15:00", tempC: 16.0, condition: condition)
                    ]
                ),
                ForecastDay(
                    date: "2024-04-24",
                    dateEpoch: 1713916800,
                    day: Day(maxtempC: 20.0, mintempC: 10.0, condition: Condition(text: "Sunny", icon: "", code: 1000), dailyChanceOfRain: 0),
                    hour: [
                        Hour(timeEpoch: 1713942000, time: "2024-04-24 12:00", tempC: 19.0, condition: Condition(text: "Sunny", icon: "", code: 1000))
                    ]
                )
            ])
        )
    }
}
