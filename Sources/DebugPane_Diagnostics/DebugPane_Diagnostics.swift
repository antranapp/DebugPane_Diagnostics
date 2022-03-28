//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Diagnostics
import Foundation
import MessageUI
import SwiftUI
import TweakPane
import UIKit

public struct DiagnosticsBlade: Blade {
    public var name: String? = "Diagnostics"

    private var presentingViewController: () -> UIViewController?
    
    @ObservedObject var viewModel = ViewModel()

    public init(presentingViewController: @escaping () -> UIViewController?) {
        self.presentingViewController = presentingViewController
    }

    public func render() -> AnyView {
        renderInternally().render()
    }
    
    private func renderInternally() -> Blade {
        FolderBlade {
            InputBlade(
                name: "Enable Logging",
                binding: InputBinding($viewModel.isLoggingEnabled)
            )
            UIBlade {
                ContentView(action: { presentingViewController()?.present($0, animated: true) })
            }
        }
    }
}

extension DiagnosticsBlade {
    final class ViewModel: ObservableObject {
        static let loggingEnabledKey = "app.antran.debugpane.diagnostics.loggingEnabledKey"
        
        @Published var isLoggingEnabled: Bool {
            didSet {
                UserDefaults.standard.set(isLoggingEnabled, forKey: Self.loggingEnabledKey)
            }
        }
        
        init() {
            isLoggingEnabled = UserDefaults.standard.bool(forKey: Self.loggingEnabledKey)
        }
    }
}

private struct ContentView: View {
    var action: (UIViewController) -> Void

    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    var body: some View {
        // TODO: Add Toggle to turn on/off logging
        VStack(alignment: .leading) {
            Button(
                action: {
                    if MFMailComposeViewController.canSendMail() {
                        self.isShowingMailView.toggle()
                    } else {
                        /// For debugging purposes you can save the report to desktop when testing on the simulator.
                        /// This allows you to iterate fast on your report.
                        DiagnosticsReporter.create().saveToDesktop()
                        print("Can't send emails from this device")
                    }
                    if result != nil {
                        print("Result: \(String(describing: result))")
                    }
                },
                label: {
                    Text("Share logs")
                }
            )
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $result) { composer in
                composer.setSubject("Secret")
                composer.setToRecipients(["someone@gmail.com"])
                composer.setMessageBody("Issue report", isHTML: false)
                composer.addDiagnosticReport(DiagnosticsReporter.create())
            }
        }
    }
}
