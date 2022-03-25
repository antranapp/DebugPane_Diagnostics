
import Combine
import Foundation
import SwiftUI
import TweakPane
import UIKit
import Diagnostics
import MessageUI

public struct DiagnosticsBlade: Blade {
    public var name: String? = "Share Logs"

    private var presentingViewController: () -> UIViewController?

    public init(presentingViewController: @escaping () -> UIViewController?) {
        self.presentingViewController = presentingViewController
    }

    public func render() -> AnyView {
        AnyView(ContentView(action: { presentingViewController()?.present($0, animated: true) }))
    }
}

private struct ContentView: View {
    var action: (UIViewController) -> Void

    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    var body: some View {
        VStack {
            Button(
                action: {
                    if MFMailComposeViewController.canSendMail() {
                        self.isShowingMailView.toggle()
                    } else {
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
            }
        }
    }
}
