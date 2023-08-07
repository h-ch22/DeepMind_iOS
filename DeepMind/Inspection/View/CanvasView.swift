//
//  CanvasView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable{
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    private let pencilInteraction = UIPencilInteraction()

    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        #if targetEnvironment(simulator)
        canvas.drawingPolicy = .anyInput
        
        #else
        canvas.drawingPolicy = UIDevice.current.userInterfaceIdiom == .pad ? .pencilOnly : .anyInput
        canvas.tool = isDraw ? ink : eraser
        
        #endif
        
        pencilInteraction.delegate = context.coordinator
        canvas.addInteraction(pencilInteraction)
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = context.coordinator.getStatus() ? ink : eraser
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isDraw: isDraw)
    }
    
    class Coordinator: NSObject, UIPencilInteractionDelegate{
        var isDraw: Bool
        
        init(isDraw: Bool) {
            self.isDraw = isDraw
        }
        
        func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
            isDraw.toggle()
        }
        
        func getStatus() -> Bool{
            return isDraw
        }
    }
}
