import SwiftUI
import Foundation
import PlaygroundSupport

//Declaring global variables to save the user's choices
var badgeHolderName: String = ""
var badgeColorChoice: BadgeColor = .silver

//The first step that greets the users and tells them about the software
struct StarterView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom)
            VStack {
                Text("Welcome to WWDC20 Badge Creator!")
                    .bold()
                    .scaledFont(.title1)
                    .padding()
                Text("No one will have a badge for WWDC20? Wrong. A WWDC without a badge is like an egg without the egg part.")
                    .scaledFont(.title3)
                HStack {
                    Sticker(stickerType: .hello)
                        .scaleEffect(0.5)
                    Spacer()
                    Sticker(stickerType: .WWDC)
                        .scaleEffect(0.5)
                }
                Spacer()
                Text("Go ahead and create your own fully customized WWDC20 badge and celebrate the first ever all online WWDC!")
                    .scaledFont(.title3)
                    //The button that redirects the user to the first step
                Button(action: {
                    PlaygroundPage.current.setLiveView(NameEntryView().animation(.linear))
                    }, label: {ButtonLabelWithIcon(buttonTitle: "Start Creating", SFSymbol: "paintbrush.fill")})
                    .buttonStyle(GradientButton(gradient: .rainbowGradient))
                    .padding()
            }
        }
    }
}

//The step in which the user enters their name for the badge
struct NameEntryView: View {
    @State private var textFieldValue: String = ""
    @State private var greetingMessageVisible = false
    @State private var showAlert = false
    var body: some View{
        ZStack {
            LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom)
            VStack{
                Text("First Things First!")
                    .bold()
                    .scaledFont(.title1)
                    .padding()
                Text("Your name is the most special part of your badge. Plese enter it below.")
                    .scaledFont(.title3)
                Spacer()
                    //The text field in which the user writes their name
                TextField("Click to edit", text: $textFieldValue)
                    .scaledFont(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .textContentType(.name)
                Capsule()
                    .fill(LinearGradient(gradient: .rainbowGradient, startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(1000)
                    .frame(height: 5)
                    .padding(.horizontal, 50)
                //Greeting the user and informing them that the next step is loading after they submit their name
                if greetingMessageVisible {
                    Text("Nice to meet you \(badgeHolderName.components(separatedBy: " ").first!.trimmingCharacters(in: .whitespaces))! Plese wait a second while the next step is loading.")
                        .scaledFont(.title3)
                }
                Spacer()
                    //When cliclked to the button, the return value of the text field is checked to make sure it contains a real name. If the name is valid, the return value of the text field is saved in the global variable and the user is redirected to the next step. Otherwise an error message is presented.
                Button(action: {
                    if self.textFieldValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        self.showAlert = true
                    }else{
                        badgeHolderName = self.textFieldValue
                        withAnimation {
                            self.greetingMessageVisible = true
                        }
                            //Adding an extra 2 second delay before switching to the next step for the user to read the message
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            PlaygroundPage.current.setLiveView(ColorPickerView())
                        }
                    }
                }, label: {ButtonLabelWithIcon(buttonTitle: "Done", SFSymbol: "checkmark.seal.fill")})
                    .buttonStyle(GradientButton(gradient: .coolGradient))
                    .padding()
            }
                //The alert presented when the user submits an invalid name(Caution: Contains humor.)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Houston, we have a problem."), message: Text("Unfortunately, we couldn't find your name. Please make sure you have enterred it correctly and try again."), dismissButton: .default(Text("Got it!")))
                }.background(LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom))
        }
    }
}

//The step in which the user choses the color of their badge
struct ColorPickerView: View {
    //Defining a State variable to hold the current selection of the user before it is submitted
    @State private var selectedBadgeColor:BadgeColor = .silver
    var body: some View {
        ZStack {
            LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom)
            VStack {
                Text("Make Space For The Colors!")
                    .bold()
                    .scaledFont(.title1)
                    .padding()
                Text("Click a badge to select it. Scroll sideways to see more.")
                    .scaledFont(.title3)
                    //A horizontal ScrollView that creates a view for every possible badge color selection
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(BadgeColor.allCases, id: \.self) { color in
                            ZStack(alignment: .bottomTrailing) {
                                Badge(color: color, name: badgeHolderName)
                                    //Adding a selection indicator to all badges that adapts appearance to the selected badge color
                                Image(systemName: self.selectedBadgeColor == color ? "checkmark.circle.fill" : "circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(25)
                            }.onTapGesture {
                                //Set the selected badge color to the tapped badge
                                self.selectedBadgeColor = color
                            }
                            .padding()
                        }
                    }
                }
                    //Save the badge selection to the global variable and redirect the user to the next step when clicked on the button
                Button(action: {
                    badgeColorChoice = self.selectedBadgeColor
                    PlaygroundPage.current.setLiveView(StickerPlacementView())
                    
                }, label: {ButtonLabelWithIcon(buttonTitle: "Done", SFSymbol: "checkmark.seal.fill")})
                    .buttonStyle(GradientButton(gradient: .coolGradient))
                    .padding()
            }
        }
    }
}

//The view in which the user puts stickers on their badge
struct StickerPlacementView: View {
    @State private var badgeFrame: CGRect = .zero
    var body: some View {
        ZStack {
            LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom)
            VStack {
                Text(String("Time To Bring Out The Stickers!"))
                    .bold()
                    .scaledFont(.title1)
                    .padding()
                Text("Place the sticker by dagging it onto the badge. Reset its position by double clicking it")
                    .scaledFont(.title3)
                HStack {
                    VStack {
                        //Crreate a sticker view for every possible sticker type
                        ForEach(StickerType.allCases, id: \.self) { sticker in
                            Sticker(stickerType: sticker, draggable: true, onChanged: self.stickerMoved)
                        }.padding()
                    }
                    .zIndex(1)
                        //View the badge that the user configured
                    Badge(color: badgeColorChoice, name: badgeHolderName)
                        .overlay(
                            GeometryReader { geoReader in
                                Color.clear
                                    .onAppear {
                                        self.badgeFrame = geoReader.frame(in: .global)
                                    }
                            }
                        )
                        .padding()
                }
                Button(action: {
                    PlaygroundPage.current.setLiveView(CreditsView())
                }, label: {ButtonLabelWithIcon(buttonTitle: "Continue to credits", SFSymbol: "doc.append")})
                    .buttonStyle(GradientButton(gradient: .coolGradient))
                    .padding()
            }
        }
    }
    //Checking if the sticker is on the badge
    func stickerMoved(location: CGPoint) -> Bool {
        if badgeFrame.contains(location) {
            return true
        }else {
            return false
        }
    }
}

//Image credits, thanks to the user and the WWDC20 Countdown
struct CreditsView: View {
    let WWDC20Date: Date
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
        dateFormatter.locale = Locale(identifier: "en_US")
        WWDC20Date = dateFormatter.date(from: "22/06/2020 10:00")!
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .silverGradient, startPoint: .top, endPoint: .bottom)
            VStack {
                Text("Thanks For Trying Out My Playground. Hope you enjoyed it!")
                    .bold()
                    .scaledFont(.title1)
                    .padding()
                Text("Made with love and passion #BehindTheMac")
                    .scaledFont(.title1)
                HStack {
                    Sticker(stickerType: .hello)
                        .scaleEffect(0.5)
                    Spacer()
                    Sticker(stickerType: .WWDC)
                        .scaleEffect(0.5)
                }
                Spacer()
                    // Added 2021, better date formatting!
                if Date.init() >= WWDC20Date {
                    Text("Have a wonderful WWDC!")
                        .scaledFont(.largeTitle)
                }else {
                    (Text("See you in ") + Text(WWDC20Date, style: .relative))
                        .scaledFont(.largeTitle)
                }
                Spacer()
                Text("Links to images used for badge and sticker design(All credits to Apple Inc.)")
                    .scaledFont(.headline)
                    .padding()
                Text("\u{2022} https://www.apple.com/newsroom/images/live-action/wwdc/Apple_wwdc2020_03132020_big.jpg.large.jpg")
                    .scaledFont(.headline)
                    .padding()
                Text("\u{2022} https://developer.apple.com/wwdc20/swift-student-challenge/images/swift-large_2x.png")
                    .scaledFont(.headline)
                    .padding()
                Text("\u{2022} https://developer.apple.com/wwdc20/images/masthead-20.svg")
                    .scaledFont(.headline)
                    .padding()
            }
        }
    }
}

PlaygroundPage.current.setLiveView(StarterView())
PlaygroundPage.current.wantsFullScreenLiveView = true
