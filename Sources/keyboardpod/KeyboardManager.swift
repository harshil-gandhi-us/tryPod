#if canImport(UIKit)
    import UIKit

    public final class KeyboardManager {

        public static let shared = KeyboardManager()

        // Flag: enable/disable entire keyboard manager
        public var enable: Bool = false {
            didSet { enable ? startObserving() : stopObserving() }
        }

        // Flag: hide keyboard when tapping outside a text field
        public var resignOnTouchOutside: Bool = false {
            didSet { resignOnTouchOutside ? addTapGesture() : removeTapGesture() }
        }

        private weak var registeredView: UIView?
        private var tapGesture: UITapGestureRecognizer?
        private var isObserving = false

        private init() {}

        // MARK: - Register

        /// Register a UITextField or UITextView to be focused by openKeyboard()
        public func register(view: UIView) {
            registeredView = view
        }

        // MARK: - Open / Hide

        /// Opens keyboard on the registered view
        public func openKeyboard() {
            guard enable else { return }
            guard let view = registeredView else { return }
            DispatchQueue.main.async {
                view.becomeFirstResponder()
            }
        }

        /// Opens keyboard on a specific UITextField or UITextView
        public func openKeyboard(for view: UIView) {
            guard enable else { return }
            DispatchQueue.main.async {
                view.becomeFirstResponder()
            }
        }

        /// Hides the keyboard
        public func hideKeyboard() {
            guard enable else { return }
            DispatchQueue.main.async {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        }

        // MARK: - Keyboard Notifications

        private func startObserving() {
            guard !isObserving else { return }
            isObserving = true
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }

        private func stopObserving() {
            guard isObserving else { return }
            isObserving = false
            NotificationCenter.default.removeObserver(self)
            removeTapGesture()
        }

        @objc private func keyboardWillShow(_ notification: Notification) {
            guard resignOnTouchOutside else { return }
            addTapGesture()
        }

        @objc private func keyboardWillHide(_ notification: Notification) {
            removeTapGesture()
        }

        // MARK: - Outside Tap to Dismiss

        private func addTapGesture() {
            guard enable, resignOnTouchOutside, tapGesture == nil,
                let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow })
            else { return }

            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
            gesture.cancelsTouchesInView = false
            window.addGestureRecognizer(gesture)
            tapGesture = gesture
        }

        private func removeTapGesture() {
            guard let gesture = tapGesture else { return }
            gesture.view?.removeGestureRecognizer(gesture)
            tapGesture = nil
        }

        @objc private func handleOutsideTap() {
            hideKeyboard()
        }
    }
#endif
