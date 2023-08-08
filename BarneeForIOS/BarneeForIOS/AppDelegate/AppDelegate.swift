import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    //let interactor = CoctailsIteractor()
    //let presenter = CoctailsPresenter(interactor: interactor)
    let rootViewController = CoctailsView()//presenter: presenter)

    window?.rootViewController = rootViewController

    window?.makeKeyAndVisible()

    return true
  }
}
