import XCTest
@testable import WeatherApp

final class WeatherModelsTests: XCTestCase {

    func testForecastResponseDecoding() throws {
        let json = Self.forecastJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(ForecastResponse.self, from: json)

        XCTAssertEqual(response.location.name, "Moscow")
        XCTAssertEqual(response.location.country, "Russia")
        XCTAssertEqual(response.current.tempC, 15.0)
        XCTAssertEqual(response.current.feelslikeC, 13.0)
        XCTAssertEqual(response.current.humidity, 60)
        XCTAssertEqual(response.current.windKph, 10.5)
        XCTAssertEqual(response.current.condition.text, "Partly cloudy")
        XCTAssertEqual(response.current.condition.code, 1003)
        XCTAssertEqual(response.current.uv, 3.0)
    }

    func testForecastDaysDecoding() throws {
        let json = Self.forecastJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(ForecastResponse.self, from: json)

        XCTAssertEqual(response.forecast.forecastday.count, 2)

        let firstDay = response.forecast.forecastday[0]
        XCTAssertEqual(firstDay.date, "2024-04-23")
        XCTAssertEqual(firstDay.day.maxtempC, 18.0)
        XCTAssertEqual(firstDay.day.mintempC, 8.0)
        XCTAssertEqual(firstDay.day.dailyChanceOfRain, 20)
        XCTAssertEqual(firstDay.hour.count, 2)
    }

    func testHourDecoding() throws {
        let json = Self.forecastJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(ForecastResponse.self, from: json)

        let hour = response.forecast.forecastday[0].hour[0]
        XCTAssertEqual(hour.time, "2024-04-23 12:00")
        XCTAssertEqual(hour.tempC, 14.0)
        XCTAssertEqual(hour.condition.code, 1003)
    }

    func testCurrentWeatherResponseDecoding() throws {
        let json = Self.currentJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(CurrentWeatherResponse.self, from: json)

        XCTAssertEqual(response.location.name, "Moscow")
        XCTAssertEqual(response.current.tempC, 15.0)
    }
}

// MARK: - Test JSON

extension WeatherModelsTests {

    static let forecastJSON = """
    {
        "location": {
            "name": "Moscow",
            "country": "Russia",
            "localtime": "2024-04-23 14:00",
            "localtime_epoch": 1713877200
        },
        "current": {
            "temp_c": 15.0,
            "feelslike_c": 13.0,
            "humidity": 60,
            "wind_kph": 10.5,
            "condition": {
                "text": "Partly cloudy",
                "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                "code": 1003
            },
            "uv": 3.0
        },
        "forecast": {
            "forecastday": [
                {
                    "date": "2024-04-23",
                    "date_epoch": 1713830400,
                    "day": {
                        "maxtemp_c": 18.0,
                        "mintemp_c": 8.0,
                        "condition": {
                            "text": "Partly cloudy",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            "code": 1003
                        },
                        "daily_chance_of_rain": 20
                    },
                    "hour": [
                        {
                            "time_epoch": 1713855600,
                            "time": "2024-04-23 12:00",
                            "temp_c": 14.0,
                            "condition": {
                                "text": "Partly cloudy",
                                "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                                "code": 1003
                            }
                        },
                        {
                            "time_epoch": 1713859200,
                            "time": "2024-04-23 13:00",
                            "temp_c": 15.0,
                            "condition": {
                                "text": "Sunny",
                                "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                                "code": 1000
                            }
                        }
                    ]
                },
                {
                    "date": "2024-04-24",
                    "date_epoch": 1713916800,
                    "day": {
                        "maxtemp_c": 20.0,
                        "mintemp_c": 10.0,
                        "condition": {
                            "text": "Sunny",
                            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            "code": 1000
                        },
                        "daily_chance_of_rain": 0
                    },
                    "hour": [
                        {
                            "time_epoch": 1713942000,
                            "time": "2024-04-24 12:00",
                            "temp_c": 19.0,
                            "condition": {
                                "text": "Sunny",
                                "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                                "code": 1000
                            }
                        }
                    ]
                }
            ]
        }
    }
    """

    static let currentJSON = """
    {
        "location": {
            "name": "Moscow",
            "country": "Russia",
            "localtime": "2024-04-23 14:00",
            "localtime_epoch": 1713877200
        },
        "current": {
            "temp_c": 15.0,
            "feelslike_c": 13.0,
            "humidity": 60,
            "wind_kph": 10.5,
            "condition": {
                "text": "Partly cloudy",
                "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                "code": 1003
            },
            "uv": 3.0
        }
    }
    """
}
