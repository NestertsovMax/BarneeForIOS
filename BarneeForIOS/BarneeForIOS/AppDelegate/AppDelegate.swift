import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Убедитесь, что окно не создается, если SceneDelegate поддерживается
        if #available(iOS 13.0, *) {
            // Ничего не делаем здесь, окно настроим в SceneDelegate
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        
            let rootViewController = CoctailsView()
            
            window?.rootViewController = rootViewController
            
            window?.makeKeyAndVisible()
        }
        return true
    }
}
