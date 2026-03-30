import UIKit

enum WeatherIcon {

    /// Маппинг кодов WeatherAPI на SF Symbols
    static func sfSymbolName(for code: Int) -> String {
        switch code {
        case 1000: return "sun.max.fill"
        case 1003: return "cloud.sun.fill"
        case 1006: return "cloud.fill"
        case 1009: return "smoke.fill"
        case 1030: return "cloud.fog.fill"
        case 1063, 1150, 1153: return "cloud.drizzle.fill"
        case 1066, 1210, 1213: return "cloud.snow.fill"
        case 1069, 1204, 1207: return "cloud.sleet.fill"
        case 1072, 1168, 1171: return "cloud.hail.fill"
        case 1087: return "cloud.bolt.fill"
        case 1114, 1117: return "wind.snow"
        case 1135, 1147: return "cloud.fog.fill"
        case 1180, 1183: return "cloud.drizzle.fill"
        case 1186, 1189: return "cloud.rain.fill"
        case 1192, 1195: return "cloud.heavyrain.fill"
        case 1198, 1201: return "cloud.sleet.fill"
        case 1216, 1219: return "cloud.snow.fill"
        case 1222, 1225: return "snow"
        case 1237: return "cloud.hail.fill"
        case 1240: return "cloud.sun.rain.fill"
        case 1243, 1246: return "cloud.heavyrain.fill"
        case 1249, 1252: return "cloud.sleet.fill"
        case 1255, 1258: return "cloud.snow.fill"
        case 1261, 1264: return "cloud.hail.fill"
        case 1273, 1276: return "cloud.bolt.rain.fill"
        case 1279, 1282: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }

    static func image(for code: Int, pointSize: CGFloat = 20) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
        return UIImage(systemName: sfSymbolName(for: code), withConfiguration: config)?
            .withRenderingMode(.alwaysOriginal)
    }
}
