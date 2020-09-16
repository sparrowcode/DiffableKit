import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        if #available(iOS 13.0, *) {
            window?.rootViewController = UINavigationController(rootViewController: RootController())
        } else {
            window?.rootViewController = UIViewController()
        }
        window?.makeKeyAndVisible()
        return true
    }
}
