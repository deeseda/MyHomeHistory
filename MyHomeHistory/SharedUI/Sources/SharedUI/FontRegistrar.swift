import CoreText
import Foundation

public enum FontRegistrar {
    public static func registerFonts() {
        ["Fellix-Regular", "Fellix-SemiBold"].forEach(registerFont)
    }

    private static func registerFont(named fontName: String) {
        guard let fontURL = Bundle.module.url(forResource: fontName, withExtension: "otf") ??
            Bundle.module.url(forResource: fontName, withExtension: "ttf")
        else {
            return
        }

        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}
