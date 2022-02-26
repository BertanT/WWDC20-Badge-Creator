import SwiftUI

//An enum containing all the possible badge colors
public enum BadgeColor: Int, CaseIterable {
    case silver = 1, spaceGray, matteBlack, skyBlue, teal, yellow, fuschia
}

//A Badge View with a color and a name
public struct Badge: View {
    //Defining properties privately
    private let colorNumber: Int
    private let name: String
    
    //Initializing Publicly
    public init(color: BadgeColor, name: String) {
        self.colorNumber = color.rawValue
        self.name = name
    }
    
    //Defining the body property publicly
    public var body: some View {
        ZStack(alignment: .leading) {
            Image(uiImage: UIImage(named: "badge\(self.colorNumber)")!)
                .resizable()
                .scaledToFit()
                .shadow(radius: 10)
            Text(name)
                .bold()
                .scaledFont(.title2)
                .foregroundColor(.white)
                .padding(30)
        }
    }
}
