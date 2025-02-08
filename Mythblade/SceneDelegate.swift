import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    static var universalLinkToLaunch: URL? = nil;
    static var shortcutLinkToLaunch: URL? = nil

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
        #endif

        for userActivity in connectionOptions.userActivities {
            if let universalLink = userActivity.webpageURL {
                SceneDelegate.universalLinkToLaunch = universalLink;
                break
            }
        }

        if let shortcutUrl = connectionOptions.shortcutItem?.type {
            SceneDelegate.shortcutLinkToLaunch = URL.init(string: shortcutUrl)
        }
        
        if let schemeUrl = connectionOptions.urlContexts.first?.url {
            var comps = URLComponents(url: schemeUrl, resolvingAgainstBaseURL: false)
            comps?.scheme = "https"
            
            if let url = comps?.url {
                SceneDelegate.universalLinkToLaunch = url;
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let scheme = URLContexts.first?.url {
            var comps = URLComponents(url: scheme, resolvingAgainstBaseURL: false)
            comps?.scheme = "https"

            if let url = comps?.url {
                Mythblade.webView.evaluateJavaScript("location.href = '\(url)'")
            }
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let universalLink = userActivity.webpageURL else {
            return
        }

        Mythblade.webView.evaluateJavaScript("location.href = '\(universalLink)'")
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if let shortcutUrl = URL.init(string: shortcutItem.type) {
            Mythblade.webView.evaluateJavaScript("location.href = '\(shortcutUrl)'");
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
