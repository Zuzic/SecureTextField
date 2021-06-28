import UIKit

open class SecureTextField: UITextField {
    let defaultTextChangeAction = #selector(secureTextDidChanged)
    private(set) var isSecure: Bool = false
    private var timer: Timer?
    private var securedText: [Character] = .init() {
        didSet {
            visualizeTextUpdate()
        }
    }
            
    public override var isSecureTextEntry: Bool {
        get {
            return false
        }
        set {
            super.isSecureTextEntry = newValue
            isSecure = newValue
        }
    }
    
    public override var text: String? {
        get {
            return .init(securedText)
        }
        set {
            securedText = .init(newValue ?? "")
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        subscribeTextChange()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        subscribeTextChange()
    }
    
    open override func addTarget(_ target: Any?,
                            action: Selector,
                            for controlEvents: UIControl.Event) {
        guard controlEvents != .editingChanged || action == defaultTextChangeAction else {
            return
        }
        super.addTarget(target, action: action, for: controlEvents)
    }
    
    //MARK: - private
    private func subscribeTextChange() {
        addTarget(self, action: defaultTextChangeAction, for: .editingChanged)
    }
        
    private func updateSubstring(by text: String) {
        var updatedText = text
        let updatedCount = text.count
        let diff = updatedCount - securedText.count
        
        if diff > 0 {
            updatedText.removeFirst(securedText.count)
            securedText.append(contentsOf: updatedText)
        } else {
            securedText.removeLast(Int(diff.magnitude))
        }
    }
    
    private func visualizeTextUpdate() {
        timer?.fire()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25,
                                     repeats: false,
                                     block: { [weak self] timer in
                                        guard let self = self else {
                                            return
                                        }
                                        let value: String = .init(repeating: "•",
                                                          count: self.securedText.count)
                                        let attributes: [NSAttributedString.Key: Any] = [.font: self.font ?? UIFont.systemFont(ofSize: 16)]
                                        self.attributedText = .init(string: value, attributes: attributes)
                                        timer.invalidate()
                                        
                                     })
    }
    
    @objc private func secureTextDidChanged() {
        guard isSecure else {
            return
        }
        updateSubstring(by: attributedText?.string ?? "")
    }
}

