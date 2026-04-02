# keyboardpod

Custom keyboard manager for iOS UIKit — open/hide keyboard programmatically with enable/disable flags.

---

## Add via SPM in Xcode

1. **File → Add Package Dependencies → Add Local...**
2. Select the `keyboardpod` folder → **Add Package**
3. Select `keyboardpod` → **Add Package**

---

## Setup in AppDelegate

```swift
import UIKit
import keyboardpod

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        KeyboardManager.shared.enable = true               // Flag: enable SDK
        KeyboardManager.shared.resignOnTouchOutside = true // Flag: hide on outside tap
        return true
    }
}
```

---

## Example

```swift
import UIKit
import keyboardpod

class ViewController: UIViewController {

    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Type here..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let openButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Open Keyboard", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let hideButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Hide Keyboard", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(textField)
        view.addSubview(openButton)
        view.addSubview(hideButton)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 40),

            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),

            hideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hideButton.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 20)
        ])

        // Register text field with KeyboardManager
        KeyboardManager.shared.register(view: textField)

        openButton.addTarget(self, action: #selector(openTapped), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(hideTapped), for: .touchUpInside)
    }

    @objc func openTapped() {
        KeyboardManager.shared.openKeyboard(for: textField)
    }

    @objc func hideTapped() {
        KeyboardManager.shared.hideKeyboard()
    }
}
```

---

## Flags

| Flag | Description |
|---|---|
| `enable` | Enable/disable KeyboardManager |
| `resignOnTouchOutside` | Hide keyboard when tapping outside |

---

## Requirements

- iOS 16+ / Xcode 15+ / Swift 5.9+
