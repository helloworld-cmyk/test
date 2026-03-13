import Flutter
import SwiftUI
import UIKit

class NativeViewFactory: NSObject, FlutterPlatformViewFactory {

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        let params = args as? [AnyHashable: Any]
        let fullName = params?["fullName"] as? String ?? "Guest"
        let email = params?["email"] as? String ?? "guest@example.com"

        return NativeView(frame: frame, fullName: fullName, email: email)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}


class NativeView: NSObject, FlutterPlatformView {

    private let hostingController: UIHostingController<NativeFlowView>

    init(frame: CGRect, fullName: String, email: String) {
        hostingController = UIHostingController(
            rootView: NativeFlowView(defaultFullName: fullName, defaultEmail: email)
        )
        super.init()
        hostingController.view.frame = frame
        hostingController.view.backgroundColor = .clear
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func view() -> UIView {
        return hostingController.view
    }
}

private struct NativeFlowView: View {
    @State private var isLoggedIn = false
    @State private var fullName: String
    @State private var email: String

    init(defaultFullName: String, defaultEmail: String) {
        _fullName = State(initialValue: defaultFullName)
        _email = State(initialValue: defaultEmail)
    }

    var body: some View {
        Group {
            if isLoggedIn {
                ProductScreen(fullName: fullName, email: email)
            } else {
                LoginView { loggedInFullName, loggedInEmail in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        fullName = loggedInFullName
                        email = loggedInEmail
                        isLoggedIn = true
                    }
                }
            }
        }
    }
}
