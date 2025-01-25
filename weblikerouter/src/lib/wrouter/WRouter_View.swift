import Foundation
import SwiftUI


struct WRouterView<Content: View>: View {
    let content: (_ path: String, _ queryparm: String) -> Content
    
    let maxAllowance: CGFloat = 10;
    let minMovement: CGFloat = 3;
    
    @State var frwdOffset: CGFloat = -64;
    @State var bkwdOffset: CGFloat = -64;
    @State var detectedGesture: WRouter_GestureType = .detecting;
    
    @State var yofset: CGFloat = 0;
    
    init(@ViewBuilder content: @escaping (_ path: String, _ queryparm: String) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                if WPath.shared.background != nil {
                    Color(WPath.shared.background!).edgesIgnoringSafeArea(.all)
                }
                VStack(alignment: .leading) {
                    content(WPath.shared.path, WPath.shared.queryparm)
                    Spacer()
                }
                .frame(alignment: .topLeading)
                
                VStack {
                    Image(systemName: "arrowshape.turn.up.backward")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.white)
                        .padding(12)
                }
                .background(Color.black.opacity(0.8))
                .clipShape(.circle)
                .edgesIgnoringSafeArea(.all)
                .offset(x: frwdOffset, y: yofset - geo.safeAreaInsets.top - 22)
                
                VStack {
                    Image(systemName: "arrowshape.turn.up.forward")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.white)
                        .padding(12)
                }
                .background(Color.black.opacity(0.8))
                .clipShape(.circle)
                .edgesIgnoringSafeArea(.all)
                .offset(x: (-64 - bkwdOffset) + geo.size.width, y: yofset - geo.safeAreaInsets.top - 22)
            }
            .frame(
                maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading
            )
            .frame(
                width: geo.size.width,
                height: geo.size.height,
                alignment: .topLeading
            )
            .contentShape(.rect)
#if os(iOS)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        let pgalwn = isPathGesture(startLocation: value.startLocation)
                        
                        // no gesture handling required
                        if pgalwn == .none {
                            return;
                        }
                        
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        if abs(verticalAmount) <= minMovement && abs(horizontalAmount) <= minMovement {
                            return;
                        }
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            let movementLike: WRouter_GestureType = horizontalAmount < 0 ? .forward : .backward;
                            
                            if movementLike != pgalwn {
                                detectedGesture = .none;
                                return;
                            }
                            
                            detectedGesture = movementLike;
                            yofset = value.startLocation.y
                            
                            if movementLike == .backward {
                                withAnimation(.interactiveSpring) {
                                    frwdOffset = min(value.translation.width - 64, 0) + calcBitoffset(ofst: value.translation.width - 32)
                                }
                            } else {
                                withAnimation(.interactiveSpring) {
                                    bkwdOffset = min((-1 * value.translation.width) - 64, 0) + calcBitoffset(ofst: (-1 * value.translation.width) - 32)
                                }
                            }
                        } else {
                            detectedGesture = .none;
                        }
                    }
                    .onEnded { value in
                        withAnimation(.interactiveSpring) {
                            frwdOffset = -64;
                            bkwdOffset = -64;
                        }
                        if detectedGesture == .none || detectedGesture == .detecting {
                            return;
                        }
                        
                        if detectedGesture == .backward {
                            WPath.shared.backward()
                        }
                        if detectedGesture == .forward {
                            WPath.shared.forward()
                        }
                        
                        detectedGesture = .detecting;
                    }
            )
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func calcBitoffset(ofst: CGFloat) -> CGFloat {
        return 0.01 * log2(abs(ofst)) * abs(ofst)
    }
    
#if os(iOS)
    func isPathGesture(startLocation: CGPoint) -> WRouter_GestureType {
        if startLocation.x <= maxAllowance {
            return .backward
        }
        
        if startLocation.x >= Device().width - maxAllowance {
            return .forward
        }
        
        return .none
    }
#endif
}
