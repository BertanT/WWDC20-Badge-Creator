import SwiftUI

//An enum containing all the possible sticker types
public enum StickerType: Int, CaseIterable {
    case hello = 1, WWDC, twentyTwenty, swift
}

//A Custom Sticker view with drag and drop alon with animation and shadows
public struct Sticker: View {
    //Defining properties privately
    private let stickerNumber: Int
    private let draggable: Bool
    @State private var dragArea: CGSize = .zero
    @State private var allowPlacement: Bool = true
    @State private var scale: CGFloat = 1
    @State private var shadowRadius:CGFloat = 0
    @State var dragState: Bool = false
    //Defining a Closure to save the location check output
    var onChanged: ((CGPoint) -> Bool)?
    
    //Initializing publicly
    public init(stickerType: StickerType, draggable: Bool? = false, onChanged: ((CGPoint) -> Bool)? = nil) {
        self.stickerNumber = stickerType.rawValue
        self.draggable = draggable!
        self.onChanged = onChanged
    }
    
    //Defiing the body property publicly
    public var body: some View {
        Image(uiImage: UIImage(named: "sticker\(self.stickerNumber)")!)
            .resizable()
            .scaledToFit()
            .scaleEffect(self.scale)
            .shadow(radius: self.shadowRadius)
            .animation(.interactiveSpring())
            .offset(dragArea)
            //Gesture modifier with gesture type DragGesture
            .gesture( self.draggable && allowPlacement ?
                        DragGesture(coordinateSpace: .global)
                        .onChanged {
                            self.dragArea = CGSize(width: $0.translation.width, height: $0.translation.height)
                            self.dragState = self.onChanged?($0.location) ?? false
                            self.scale = 1.2
                            self.shadowRadius = 10
                        }
                        //When dropped check if the sticker is within a given frame and if it is place it, otherwise reset the position
                        .onEnded {_ in
                            self.scale = 1
                            self.shadowRadius = 0
                            if self.dragState == true {
                                self.allowPlacement = false
                            }else {
                                self.dragArea = .zero
                                self.allowPlacement = true
                            }
                        }
                        : nil)
            //Reset the position of the sticker on double click
            .onTapGesture(count: 2) {
                self.dragArea = .zero
                self.allowPlacement = true
            }
    }
}

