import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let viewModel = WeatherViewModel(
            weatherService: WeatherService(),
            locationService: LocationService()
        )
        window.rootViewController = WeatherViewController(viewModel: viewModel)
        window.makeKeyAndVisible()
        self.window = window
    }
}
