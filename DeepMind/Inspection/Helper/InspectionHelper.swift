//
//  InspectionHelper.swift
//  DeepMind
//
//  Created by 하창진 on 8/1/23.
//

import Foundation
import UIKit
import Accelerate
import Vision

class InspectionHelper: ObservableObject{
    private let ciContext = CIContext()
    
    private let colors:[UIColor] = {
        var colorSet:[UIColor] = []
        for _ in 0...80 {
            let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
            colorSet.append(color)
        }
        return colorSet
    }()
    
    private func getDocumentsDirectory() -> URL?{
        do{
            let paths = try FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            return paths[0]
        } catch{
            print(error)
            return nil
        }

    }
    
    func saveImage(image: UIImage, imageName: String) -> Bool{
        do{
            let fileManager = FileManager.default

            let directory = getDocumentsDirectory()?.appendingPathComponent(imageName)
            
            if directory == nil{
                return false
            }
            
            if fileManager.fileExists(atPath: directory!.absoluteString){
                do{
                    try fileManager.removeItem(atPath: directory!.absoluteString)
                } catch let error{
                    print(error)
                    return false
                }
            }
            
            if let imageData = image.pngData(){
                try imageData.write(to: directory!)
                return true
            } else{
                return false
            }
        } catch{
            print(error)
            return false
        }
    }
    
    func getImage(type: DrawingTypeModel) -> UIImage?{
        let fileManager = FileManager.default
        var imagePath : URL?
        
        switch type{
        case .HOUSE:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("House.png")
            
        case .TREE:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Tree.png")

        case .PERSON_1:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Person_1.png")

        case .PERSON_2:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Person_2.png")
        }
        
        return UIImage(contentsOfFile: (imagePath?.path())!) ?? nil
    }
    
    func getDetectedImage(type: DrawingTypeModel) -> UIImage?{
        let fileManager = FileManager.default
        var imagePath : URL?
        
        switch type{
        case .HOUSE:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Detection_House.png")
            
        case .TREE:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Detection_Tree.png")

        case .PERSON_1:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Detection_Person_1.png")

        case .PERSON_2:
            imagePath = getDocumentsDirectory()?.appendingPathComponent("Detection_Person_2.png")
        }
        
        return UIImage(contentsOfFile: (imagePath?.path())!) ?? nil
    }
    
    func detect(type: DrawingTypeModel) -> UIImage?{
        do{
            var model: MLModel
            
            switch type{
            case .HOUSE:
                model = try CL01().model

            case .TREE:
                model = try CL02().model
                
            case .PERSON_1,
                .PERSON_2:
                model = try CL03().model
            }
            
            guard let classes = model.modelDescription.classLabels as? [String] else{
                return nil
            }
            
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            
            let image = getImage(type: type)
            
            if image != nil{
                let cvPixelBuffer = image?.pixelBuffer(width: 1080, height: 1080)
                
                if cvPixelBuffer != nil{
                    let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer!)
                    
                    do{
                        try handler.perform([request])
                        guard let results = request.results as? [VNRecognizedObjectObservation] else{
                            return nil
                        }
                        
                        var detections : [Detection] = []
                        
                        for result in results{
                            let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                            let box = VNImageRectForNormalizedRect(flippedBox, 1080, 1080)

                            guard let label = result.labels.first?.identifier as? String,
                                    let colorIndex = classes.firstIndex(of: label) else {
                                    return nil
                            }
                            let detection = Detection(box: box, confidence: result.confidence, label: label, color: colors[colorIndex])
                            detections.append(detection)
                        }
                        
                        let drawImage = drawRectsOnImage(detections, cvPixelBuffer!)
                        
                        return drawImage
                    } catch let error{
                        print("VNImageRequestHandler error occured.")
                        print(error.localizedDescription)
                        return nil
                    }
                } else{
                    print("CVPixelBuffer is nil.")
                    return nil
                }
            } else{
                print("Image is nil.")
                return nil
            }
            
        } catch let error{
            print("VNCoreModel load error")
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage?{
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        for detection in detections{
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
             if let labelText = detection.label {
                 cgContext.textMatrix = .identity
                 
                 let text = "\(labelText) : \(round(detection.confidence*100))"
                 
                 let textRect  = CGRect(x: invertedBox.minX + size.width * 0.01, y: invertedBox.minY - size.width * 0.01, width: invertedBox.width, height: invertedBox.height)
                 let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                 
                 let textFontAttributes = [
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
                     NSAttributedString.Key.foregroundColor: detection.color,
                     NSAttributedString.Key.paragraphStyle: textStyle
                 ]
                 
                 cgContext.saveGState()
                 defer { cgContext.restoreGState() }
                 let astr = NSAttributedString(string: text, attributes: textFontAttributes)
                 let setter = CTFramesetterCreateWithAttributedString(astr)
                 let path = CGPath(rect: textRect, transform: nil)
                 
                 let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
                 cgContext.textMatrix = CGAffineTransform.identity
                 CTFrameDraw(frame, cgContext)
                 
                 cgContext.setStrokeColor(detection.color.cgColor)
                 cgContext.setLineWidth(9)
                 cgContext.stroke(invertedBox)
             }
        }
        
        guard let newImage = cgContext.makeImage() else { return nil }
                return UIImage(ciImage: CIImage(cgImage: newImage))
    }
}
