import SwiftUI

// An extension to gradients to access pre-defined gradients easily
public extension Gradient {
    static var rainbowGradient = Gradient(colors:[Color(UIColor.systemRed), Color(UIColor.systemOrange), Color(UIColor.systemYellow), Color(UIColor.systemGreen), Color(UIColor.systemTeal), Color(UIColor.systemBlue), Color(UIColor.systemIndigo), Color(UIColor.systemPurple)])
    static var coolGradient = Gradient(colors: [Color(UIColor.systemGreen), Color(UIColor.systemTeal)])
    static var silverGradient = Gradient(colors: [Color(red: 0.71, green: 0.71, blue: 0.73), Color(red: 0.58, green: 0.58, blue: 0.6)])
}

// * This was initially used in the code in the competition, removing it for better UI optimization *
// An extension to Text to access pre-defined text styles easily
//  public extension Text {
//      func title() -> Text {
//          self
//              .fontWeight(.bold)
//              .font(.largeTitle)
//              .foregroundColor(.black)
//      }
//      
//      func heading() -> Text {
//          self
//              .font(.headline)
//              .foregroundColor(.black)
//      }
//  }

// * Added 2021 for better UI optimization *
// I am scaling up the dynmaic fonts for better looks on Mac!
// Scale the fonts by 1.5 times if using a 13 inch MacBook or smaller, scale them up by 1.8 times if using a Mac with a higher screen resolution
// Comment the next line if on iPadOS!
let fontScalingCoefficent: CGFloat = UIScreen.main.bounds.height < 1100 ? 1.25 : 1.8

// A view modifier that scales up dymaic fonts and uses rounded design as default for better looks!
// I used a bit of a hack here, but it works ;)
fileprivate struct ScaledFont: ViewModifier {
    let style: UIFont.TextStyle
    let design: Font.Design = .default
    let weight: Font.Weight = .regular
    public func body(content: Content) -> some View {
        content
            .font(.system(size: (UIFont.preferredFont(forTextStyle: style).pointSize * fontScalingCoefficent), weight: weight, design: design))
    }
}

public extension View {
    func scaledFont(_ style: UIFont.TextStyle) -> some View {
        self.modifier(ScaledFont(style: style))
    }
}
