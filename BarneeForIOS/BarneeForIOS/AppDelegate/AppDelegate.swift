import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let apiService = APICaller.shared
        let interactor = CoctailsInteractor(apiService: apiService)
        
        let rootViewController = CoctailsView()
        let presenter = CoctailsPresenter(view: rootViewController, interactor: interactor)
        rootViewController.presenter = presenter
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
