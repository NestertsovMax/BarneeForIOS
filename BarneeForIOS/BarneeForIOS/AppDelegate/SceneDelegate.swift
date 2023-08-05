import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Убедитесь, что это сцена для окна
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаем окно и устанавливаем его фрейм
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        // Создаем экземпляр вашего корневого контроллера, который будет управлять вашим интерфейсом программно
        let rootViewController = CoctailsView()

        // Устанавливаем ваш контроллер как корневой для окна
        window?.rootViewController = rootViewController

        // Делаем окно видимым
        window?.makeKeyAndVisible()
    }
}

