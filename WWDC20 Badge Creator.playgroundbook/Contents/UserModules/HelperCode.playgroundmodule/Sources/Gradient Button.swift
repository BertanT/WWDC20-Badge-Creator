import SwiftUI

//A custom button label view with a Text and SFSymbol
public struct ButtonLabelWithIcon: View {
    //Defining properties privately
    private let SFSymbol: String
    private let buttonTitle: String
    
    //Initializing publicly
    public init(buttonTitle:String, SFSymbol:String) {
        self.buttonTitle = buttonTitle
        self.SFSymbol = SFSymbol
    }
    
    //Defining the body property
    public var body: some View {
        HStack {
            Text(buttonTitle)
                .fontWeight(.bold)
                .font(.title)
            Image(systemName: SFSymbol)
                .font(.largeTitle)
        }
    }
}

//A ButtonStyle with animation, shadow and gradient
public struct GradientButton: ButtonStyle {
    //Defining properties privately
    private let gradient: Gradient
    
    //Initializing publicly
    public init(gradient: Gradient){
        self.gradient = gradient
    }
    
    //Defining the makeBody function publicly
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule()
                    .fill(
                        LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
                    ).shadow(radius: configuration.isPressed ? 0 : 10)
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.4, blendDuration: 0.3))
        
    }
}
