import UIKit
import RNSRegistry
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var cachedLaunchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
  public func getRootView(_ jsLocation: URL) -> UIView? {
    guard let rv:RCTRootView = RCTRootView(bundleURL: jsLocation, moduleName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, initialProperties: nil, launchOptions: cachedLaunchOptions) else {
      return nil
    }
    return rv
  }
  //MARK: Lifecycle Management
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    cachedLaunchOptions = launchOptions
    guard let jsLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil) else {
      return false;
    }
    RNSMainRegistry.setData(key: "initialBundle", value: jsLocation.absoluteString)
    RNSMainRegistry.triggerEvent(type: "app.didFinishLaunchingWithOptions.start", data: [:])
    let w = UIWindow(frame: UIScreen.main.bounds)
    let rvc = UIViewController()
    rvc.view = getRootView(jsLocation)
    w.rootViewController = rvc
    w.makeKeyAndVisible()
    self.window = w
    let _ = RNSMainRegistry.addEvent(type: "app.reset", key: "core") { data in
        DispatchQueue.main.async {
          let rvc = UIViewController()
          guard let sURL = RNSMainRegistry.getData(key: "initialBundle") as? String, let jsLocation = URL(string: sURL)
          else { return }
          rvc.view = self.getRootView(jsLocation)
          self.window?.rootViewController = rvc
        }
        return true
    }
    let _ = RNSMainRegistry.triggerEvent(type: "app.didFinishLaunchingWithOptions", data: launchOptions ?? [:])
    return true
  }
  func applicationWillResignActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willresignactive", data: [:])
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didenterbackground", data: [:])
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willenterforeground", data: [:])
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didbecomeactive", data: [:])
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willterminate", data: [:])
  }
  //MARK:Shortcut Management
  public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
      RNSMainRegistry.setData(key: "shortcuttriggered", value: shortcutItem.type)
      RNSMainRegistry.setData(key: shortcutItem.type, value: shortcutItem.userInfo ?? [:])
    let ret = RNSMainRegistry.triggerEvent(type: shortcutItem.type, data: shortcutItem.userInfo ?? [:])
      completionHandler(ret)
  }
  //MARK:URL Management
  public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    RNSMainRegistry.setData(key: "app.url", value:url)
    RNSMainRegistry.setData(key: "app.urlinfo", value: options)
    let ret = RNSMainRegistry.triggerEvent(type: "app.openedurl", data: url)
    return ret
  }
  //MARK:Notification Management
  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didRegisterForRemoteNotifications", data: deviceToken)
  }
  public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didRegisterUserNotificationSettings", data: notificationSettings)
  }
  public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didReceiveRemoteNotification", data: userInfo)
  }
  public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didFailToRegisterForRemoteNotifications", data: error)
  }
  public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didReceiveLocalNotification", data: notification)
  }

}
