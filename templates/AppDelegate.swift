import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    guard let jsLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil) else {
      return false;
    }
    guard let rv:RCTRootView = RCTRootView(bundleURL: jsLocation, moduleName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, initialProperties: nil, launchOptions: launchOptions) else {
      return false
    }
    rv.backgroundColor = UIColor.white;
    let w = UIWindow(frame: UIScreen.main.bounds)
    let rvc = UIViewController()
    rvc.view = rv
    w.rootViewController = rvc
    w.makeKeyAndVisible()
    self.window = w
    return true
  }
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
  
}


