import UIKit
import RNSRegistry
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    guard let jsLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil) else {
      return false;
    }
    RNSMainRegistry.main.data["initialBundle"] = jsLocation
    guard let rv:RCTRootView = RCTRootView(bundleURL: jsLocation, moduleName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, initialProperties: nil, launchOptions: launchOptions) else {
      return false
    }
    if let bgdict = Bundle.main.infoDictionary!["backgroundColor"] as? [String:Any] {
      let r = bgdict["red"] as? Float ?? 1.0
      let g = bgdict["green"] as? Float ?? 1.0
      let b = bgdict["blue"] as? Float ?? 1.0
      let a = bgdict["alpha"] as? Float ?? 1.0
      let c = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
      rv.backgroundColor = c
    } else {
      rv.backgroundColor = UIColor.white
    }
    let w = UIWindow(frame: UIScreen.main.bounds)
    let rvc = UIViewController()
    rvc.view = rv
    w.rootViewController = rvc
    w.makeKeyAndVisible()
    self.window = w
    let _ = RNSMainRegistry.main.triggerEvent("app.didFinishLaunchingWithOptions", data: launchOptions ?? [:])
    return true
  }
  func applicationWillResignActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.main.triggerEvent("app.willresignactive", data: [:])
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    let _ = RNSMainRegistry.main.triggerEvent("app.didenterbackground", data: [:])
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    let _ = RNSMainRegistry.main.triggerEvent("app.willenterforeground", data: [:])
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.main.triggerEvent("app.didbecomeactive", data: [:])
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    let _ = RNSMainRegistry.main.triggerEvent("app.willterminate", data: [:])
  }
  //MARK:Shortcut Management
  public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    DispatchQueue.main.async() {
      RNSMainRegistry.main.data["shortcuttriggered"] = shortcutItem.type
      RNSMainRegistry.main.data["shortcut." + shortcutItem.type] = shortcutItem.userInfo ?? [:]
      let _ = RNSMainRegistry.main.triggerEvent("shortcut." + shortcutItem.type, data: shortcutItem.userInfo ?? [:])
      completionHandler(true)
    }
  }
  //MARK:URL Management
  public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    RNSMainRegistry.main.data["app.url"] = url
    RNSMainRegistry.main.data["app.urlinfo"] = options
    return RNSMainRegistry.main.triggerEvent("app.openedurl", data: url);
  }
}