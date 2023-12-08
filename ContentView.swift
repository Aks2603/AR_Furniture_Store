

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @StateObject private var vm = FurnitureViewModel()
    let furnitures = ["sofa", "chair", "table", "armoire"]
    
    var body: some View {
        VStack {
            ARViewContainer(vm: vm).edgesIgnoringSafeArea(.all)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(furnitures, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .border(.white, width: vm.selectedFurniture == name ? 1.0: 0.0)
                            .onTapGesture {
                                vm.selectedFurniture = name
                            }
                    }
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let vm: FurnitureViewModel
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped)))
        context.coordinator.arView = arView
        arView.addCoachingOverlay() 
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(vm: vm)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
