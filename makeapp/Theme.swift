import UIKit

enum Theme: Int {
    //1
    case `default`
    
    //2
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    //3
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 214.0/225.0, green: 62.0/225.0, blue: 128.0/225.0, alpha: 1.0)
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        UIApplication.shared.delegate?.window??.tintColor = mainColor
    }
}
