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
import Firebase
import FirebaseStorage

class InspectionHelper: ObservableObject{
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let auth = Auth.auth()
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
    
    func detect(type: DrawingTypeModel, docId: String) -> UIImage?{
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
                self.uploadImage(image: image!, isOriginal: true, type: type, docId: docId){ result in
                    guard let result = result else{return}
                }
                
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
                        
                        switch type{
                        case .HOUSE:
                            if !detections.contains(where: {$0.label == "0"}){
                                return nil
                            }
                            
                        case .TREE:
                            if !detections.contains(where: {$0.label == "0"}){
                                return nil
                            }
                            
                        case .PERSON_1, .PERSON_2:
                            if !detections.contains(where: {$0.label == "0"}) && !detections.contains(where: {$0.label == "1"}){
                                return nil
                            }
                        }
                        
                        self.uploadImage(image: drawImage!, isOriginal: false, type: type, docId: docId){ result in
                            guard let result = result else{return}
                        }
                        
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
    
    func uploadImage(image: UIImage, isOriginal: Bool, type: DrawingTypeModel, docId: String, completion: @escaping(_ result: Bool?) -> Void){
        var fileName = ""
        
        switch type{
        case .HOUSE:
            fileName = isOriginal ? "House_Original.png" : "House_Detected.png"
            
        case .TREE:
            fileName = isOriginal ? "Tree_Original.png" : "Tree_Detected.png"

        case .PERSON_1:
            fileName = isOriginal ? "Person_1_Original.png" : "Person_1_Detected.png"

        case .PERSON_2:
            fileName = isOriginal ? "Person_2_Original.png" : "Person_2_Detected.png"
        }
        
        self.storage.reference().child("Results/\(auth.currentUser?.uid ?? "")/\(docId)/\(fileName)").putData(image.pngData()!, metadata: nil){ (metadata, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                completion(true)
                return
            }
        }
    }
    
    func uploadEssentialQuestionAnswer(answer_House: HouseEssentialQuestionAnswerModel, answer_Tree: TreeEssentialQuestionAnswerModel, answer_Person_1: PersonEssentialQuestionAnswerModel, answer_Person_2: PersonEssentialQuestionAnswerModel, docId: String, completion: @escaping(_ result: Bool?) -> Void){
        self.db.collection("Users").document(auth.currentUser?.uid ?? "").setData(["lastInspection": docId]){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                self.db.collection("Users").document(self.auth.currentUser?.uid ?? "").collection("Results").document(docId).setData([
                    "answer_H_1" : answer_House.ANSWER_01,
                    "answer_H_2" : answer_House.ANSWER_02,
                    "answer_H_3" : answer_House.ANSWER_03?.description,
                    "answer_H_4" : answer_House.ANSWER_04,
                    "answer_H_5" : answer_House.ANSWER_05,
                    "answer_H_6" : answer_House.ANSWER_06?.description,
                    "answer_H_7" : answer_House.ANSWER_07?.description,
                    "answer_H_8" : answer_House.ANSWER_08?.description,
                    "answer_H_9" : answer_House.ANSWER_09?.description,
                    "answer_H_10" : answer_House.ANSWER_10?.description,
                    "answer_H_11" : answer_House.ANSWER_11,
                    "answer_H_12" : answer_House.ANSWER_12?.description,
                    "answer_H_13" : answer_House.ANSWER_13,
                    "answer_H_14" : answer_House.ANSWER_14,
                    "answer_T_1" : answer_Tree.ANSWER_01,
                    "answer_T_2" : answer_Tree.ANSWER_02,
                    "answer_T_3" : answer_Tree.ANSWER_03?.description,
                    "answer_T_4" : answer_Tree.ANSWER_04,
                    "answer_T_5" : answer_Tree.ANSWER_05,
                    "answer_T_6" : answer_Tree.ANSWER_06,
                    "answer_T_7" : answer_Tree.ANSWER_07,
                    "answer_T_8" : answer_Tree.ANSWER_08,
                    "answer_T_9" : answer_Tree.ANSWER_09?.description,
                    "answer_T_10" : answer_Tree.ANSWER_10?.description,
                    "answer_T_11" : answer_Tree.ANSWER_11,
                    "answer_T_12" : answer_Tree.ANSWER_12,
                    "answer_T_13" : answer_Tree.ANSWER_13,
                    "answer_T_14" : answer_Tree.ANSWER_14,
                    "answer_P_1_1" : answer_Person_1.ANSWER_01,
                    "answer_P_1_2" : answer_Person_1.ANSWER_02,
                    "answer_P_1_3" : answer_Person_1.ANSWER_03,
                    "answer_P_1_4" : answer_Person_1.ANSWER_04?.description,
                    "answer_P_1_5" : answer_Person_1.ANSWER_05,
                    "answer_P_1_6" : answer_Person_1.ANSWER_06,
                    "answer_P_1_7" : answer_Person_1.ANSWER_07?.description,
                    "answer_P_1_8" : answer_Person_1.ANSWER_08?.description,
                    "answer_P_1_9" : answer_Person_1.ANSWER_09,
                    "answer_P_1_10" : answer_Person_1.ANSWER_10,
                    "answer_P_1_11" : answer_Person_1.ANSWER_11,
                    "answer_P_1_12" : answer_Person_1.ANSWER_12,
                    "answer_P_1_13" : answer_Person_1.ANSWER_13,
                    "answer_P_1_14" : answer_Person_1.ANSWER_14?.description,
                    "answer_P_1_15" : answer_Person_1.ANSWER_15?.description,
                    "answer_P_2_1" : answer_Person_2.ANSWER_01,
                    "answer_P_2_2" : answer_Person_2.ANSWER_02,
                    "answer_P_2_3" : answer_Person_2.ANSWER_03,
                    "answer_P_2_4" : answer_Person_2.ANSWER_04?.description,
                    "answer_P_2_5" : answer_Person_2.ANSWER_05,
                    "answer_P_2_6" : answer_Person_2.ANSWER_06,
                    "answer_P_2_7" : answer_Person_2.ANSWER_07?.description,
                    "answer_P_2_8" : answer_Person_2.ANSWER_08?.description,
                    "answer_P_2_9" : answer_Person_2.ANSWER_09,
                    "answer_P_2_10" : answer_Person_2.ANSWER_10,
                    "answer_P_2_11" : answer_Person_2.ANSWER_11,
                    "answer_P_2_12" : answer_Person_2.ANSWER_12,
                    "answer_P_2_13" : answer_Person_2.ANSWER_13,
                    "answer_P_2_14" : answer_Person_2.ANSWER_14?.description,
                    "answer_P_2_15" : answer_Person_2.ANSWER_15?.description
                ]){error in
                    if error != nil{
                        print(error?.localizedDescription)
                        completion(false)
                        return
                    } else{
                        completion(true)
                        return
                    }
                }
            }
        }
    }
}
