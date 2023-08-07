//
//  InspectionHelper.swift
//  DeepMind
//
//  Created by 하창진 on 8/1/23.
//

import Foundation
import CoreML
import UIKit
import Accelerate

class InspectionHelper: ObservableObject{
    private let inputWidth = 416
    private let inputHeight = 416
    private let maxBoundingBoxes = 50
    
    let confidenceThreshold: Float = 0.6
    let iouThreshold: Float = 0.4
    
    
    let anchors: [[Float]] = [[116,90,  156,198,  373,326], [30,61,  62,45,  59,119], [10,13,  16,30,  33,23]]
    
    public init() { }
    
    public func predict_CL01(image: CVPixelBuffer) throws -> [Prediction] {
        let model_CL01 = CL01()

        if let output = try? model_CL01.prediction(image: image) {
            return computeBoundingBoxes(features: output.var_1366, type: .HOUSE)
        } else {
            return []
        }
    }
    
    public func predict_CL02(image: CVPixelBuffer) throws -> [Prediction] {
        let model_CL02 = CL02()

        if let output = try? model_CL02.prediction(image: image) {
            return computeBoundingBoxes(features: output.var_1366, type: .TREE)
        } else {
            return []
        }
    }
    
    public func predict_CL03(image: CVPixelBuffer) throws -> [Prediction] {
        let model_CL03 = CL03()

        if let output = try? model_CL03.prediction(image: image) {
            return computeBoundingBoxes(features: output.var_1366, type: .PERSON)
        } else {
            return []
        }
    }
    
    public func computeBoundingBoxes(features: MLMultiArray, type: PredictTypeModel) -> [Prediction] {
        var predictions = [Prediction]()
        
        let blockSize: Float = 32
        let boxesPerCell = 3
        let numClasses : Int = {
            if type == .HOUSE{
                return 15
            } else if type == .TREE{
                return 14
            } else{
                return 20
            }
        }()
        
        var gridHeight = [13, 26, 52]
        var gridWidth = [13, 26, 52]
                
        var featurePointer = UnsafeMutablePointer<Double>(OpaquePointer(features.dataPointer))
        var channelStride = features.strides[0].intValue
        var yStride = features.strides[1].intValue
        var xStride = features.strides[2].intValue
        
        func offset(_ channel: Int, _ x: Int, _ y: Int) -> Int {
            return channel*channelStride + y*yStride + x*xStride
        }
        
        for i in 0..<3 {
            featurePointer = UnsafeMutablePointer<Double>(OpaquePointer(features.dataPointer))
            channelStride = features[i].intValue
            yStride = features[i].intValue
            xStride = features[i].intValue
            for cy in 0..<gridHeight[i] {
                for cx in 0..<gridWidth[i] {
                    for b in 0..<boxesPerCell {
                        let channel = b*(numClasses + 5)
                        
                        let tx = Float(featurePointer[offset(channel    , cx, cy)])
                        let ty = Float(featurePointer[offset(channel + 1, cx, cy)])
                        let tw = Float(featurePointer[offset(channel + 2, cx, cy)])
                        let th = Float(featurePointer[offset(channel + 3, cx, cy)])
                        let tc = Float(featurePointer[offset(channel + 4, cx, cy)])

                        let scale = powf(2.0,Float(i))
                        let x = (Float(cx) * blockSize + sigmoid(tx))/scale
                        let y = (Float(cy) * blockSize + sigmoid(ty))/scale

                        let w = exp(tw) * anchors[i][2*b    ]
                        let h = exp(th) * anchors[i][2*b + 1]
                        
                        let confidence = sigmoid(tc)
                        
                        var classes = [Float](repeating: 0, count: numClasses)
                        for c in 0..<numClasses {
                            classes[c] = Float(featurePointer[offset(channel + 5 + c, cx, cy)])
                        }
                        classes = softmax(classes)
                        
                        let (detectedClass, bestClassScore) = classes.argmax()

                        let confidenceInClass = bestClassScore * confidence

                        if confidenceInClass > confidenceThreshold {
                            let rect = CGRect(x: CGFloat(x - w/2), y: CGFloat(y - h/2),
                                              width: CGFloat(w), height: CGFloat(h))
                            
                            let prediction = Prediction(classIndex: detectedClass,
                                                        score: confidenceInClass,
                                                        rect: rect)
                            predictions.append(prediction)
                        }
                    }
                }
            }
        }
        
        return nonMaxSuppression(boxes: predictions, limit: maxBoundingBoxes, threshold: iouThreshold)
    }
    
    private func nonMaxSuppression(boxes: [Prediction], limit: Int, threshold: Float) -> [Prediction] {
        
        let sortedIndices = boxes.indices.sorted { boxes[$0].score > boxes[$1].score }
        
        var selected: [Prediction] = []
        var active = [Bool](repeating: true, count: boxes.count)
        var numActive = active.count
        
    outer: for i in 0..<boxes.count {
        if active[i] {
            let boxA = boxes[sortedIndices[i]]
            selected.append(boxA)
            if selected.count >= limit { break }
            
            for j in i+1..<boxes.count {
                if active[j] {
                    let boxB = boxes[sortedIndices[j]]
                    if IOU(a: boxA.rect, b: boxB.rect) > threshold {
                        active[j] = false
                        numActive -= 1
                        if numActive <= 0 { break outer }
                    }
                }
            }
        }
    }
        
        return selected
    }
    
    private func IOU(a: CGRect, b: CGRect) -> Float {
        let areaA = a.width * a.height
        if areaA <= 0 { return 0 }
        
        let areaB = b.width * b.height
        if areaB <= 0 { return 0 }
        
        let intersectionMinX = max(a.minX, b.minX)
        let intersectionMinY = max(a.minY, b.minY)
        let intersectionMaxX = min(a.maxX, b.maxX)
        let intersectionMaxY = min(a.maxY, b.maxY)
        let intersectionArea = max(intersectionMaxY - intersectionMinY, 0) *
        max(intersectionMaxX - intersectionMinX, 0)
        return Float(intersectionArea / (areaA + areaB - intersectionArea))
    }
    
    public func sigmoid(_ x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    public func softmax(_ x: [Float]) -> [Float] {
        var x = x
        let len = vDSP_Length(x.count)
        
        var max: Float = 0
        vDSP_maxv(x, 1, &max, len)
        
        max = -max
        vDSP_vsadd(x, 1, &max, &x, 1, len)
        
        var count = Int32(x.count)
        vvexpf(&x, x, &count)
        
        var sum: Float = 0
        vDSP_sve(x, 1, &sum, len)
        vDSP_vsdiv(x, 1, &sum, &x, 1, len)
        
        return x
    }
}
