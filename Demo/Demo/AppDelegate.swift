//
// Copyright © 2022 An Tran. All rights reserved.
//

import Combine
import DebugPane
import DebugPane_Diagnostics
import Logging
import SwiftUI
import UIKit
import Diagnostics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var bag = Set<AnyCancellable>()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    
        DebugPane.start {
            DiagnosticsBlade(presentingViewController: { self.window?.rootViewController?.topMostViewController() })
        }

        do {
            try DiagnosticsLogger.setup()
        } catch {
            print("Failed to setup the Diagnostics Logger")
        }

        DiagnosticsLogger.log(message: "App Started")

        return true
    }
}
