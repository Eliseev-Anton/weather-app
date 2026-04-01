# WeatherApp

Погодное приложение для iOS, написанное на Swift + UIKit полностью программно, без Storyboard.

## Скриншоты

<p align="center">
  <img src="https://github.com/user-attachments/assets/09a69e93-34f1-4282-b984-794a85ab7903" width="30%"/>
  <img src="https://github.com/user-attachments/assets/e0211685-502b-4b09-8240-32ae6f3010a4" width="30%"/>
  <img src="https://github.com/user-attachments/assets/f77ac4a8-36f5-45fc-b2c7-7b91b9c677c8" width="30%"/>
</p>

## Функциональность

- Текущая погода: температура, ощущается как, влажность, ветер, UV-индекс
- Почасовой прогноз — оставшиеся часы сегодня + все часы завтра
- Прогноз на 3 дня с градиентным температурным баром
- Автоматическое определение геолокации, при отказе — Москва
- Поиск погоды по названию города
- Выбор местоположения на интерактивной карте (MapKit)
- Сохранение последней выбранной точки на карте между сессиями
- Состояния загрузки и ошибки с кнопкой повтора

## Стек

- **Swift 5**, **UIKit** — программная вёрстка, без Storyboard
- **async/await** — сетевые запросы и геолокация
- **CoreLocation** — определение координат пользователя
- **MapKit** — интерактивная карта с выбором точки
- **URLSession** — HTTP-запросы без сторонних зависимостей
- **XCTest** — unit-тесты
- **XcodeGen** — генерация `.xcodeproj` из `project.yml`

## Архитектура

**MVVM**

```
WeatherApp/
├── App/                        # AppDelegate, SceneDelegate
├── Models/                     # Codable-модели WeatherAPI + ViewState
├── Services/
│   ├── NetworkService          # Generic URLSession + async/await
│   ├── LocationService         # CLLocationManager с async/await
│   └── WeatherService          # Фасад: маппинг ответа API в UI-модели
├── Screens/Weather/
│   ├── WeatherViewController   # Отображение состояний экрана
│   ├── WeatherViewModel        # Бизнес-логика, state machine
│   └── Views/
│       ├── CurrentWeatherView
│       ├── HourlyCollectionView + HourlyCell
│       ├── DailyForecastView + TemperatureBarView
│       ├── MapViewController   # Выбор точки на карте
│       ├── SearchViewController
│       ├── LoadingView
│       └── ErrorView
└── Extensions/
    ├── UIColor+Theme           # Цветовая палитра
    └── WeatherIcons            # Маппинг кодов WeatherAPI → SF Symbols
```

## Запуск

1. Клонировать репозиторий
2. Установить [XcodeGen](https://github.com/yonaskolb/XcodeGen):
   ```bash
   brew install xcodegen
   ```
3. Сгенерировать проект:
   ```bash
   cd WeatherApp
   xcodegen generate
   ```
4. Открыть `WeatherApp.xcodeproj` и запустить

## Тесты

```bash
xcodebuild test -project WeatherApp.xcodeproj \
  -scheme WeatherAppTests \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

9 тестов покрывают парсинг Codable-моделей и логику маппинга WeatherService.

## API

[WeatherAPI](https://www.weatherapi.com) — прогноз погоды по координатам и названию города.

## Требования

- iOS 16+
- Xcode 15+
