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
import FirebaseFirestore
import FirebaseStorage
import PDFKit

class InspectionHelper: ObservableObject{
    @Published var latestInspectionResult: String? = nil
    @Published var commonInspectionResult: InspectionResultModel? = nil
    @Published var houseInspectionResult: HouseResultModel? = nil
    @Published var treeInspectionResult: TreeResultModel? = nil
    @Published var personInspectionResult: PersonResultModel? = nil
    @Published var data: Data? = nil
    @Published var inspectionDate = ""
    @Published var inspectionResults: [String] = []
    @Published var fileURL : URL? = nil

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
    
    init() {
        //for Demo
        #if DEBUG
            commonInspectionResult = InspectionResultModel(emotionalDisorder: .HIGHLY_IMPROBABLE, inferiority: .HIGHLY_IMPROBABLE, severeDepression: .HIGHLY_IMPROBABLE, manic: .HIGHLY_IMPROBABLE, selfFirst: .HIGHLY_IMPROBABLE, lackOfPlanning: .EVEN_ODDS, alcoholics: .HIGHLY_IMPROBABLE, hysetical: .HIGHLY_IMPROBABLE, normalAndStable: .MODERATELY_LIKELY, fantasticism: .HIGHLY_IMPROBABLE, introverted: .HIGHLY_IMPROBABLE, pastStickiness: .HIGHLY_IMPROBABLE, extroverted: .HIGHLY_LIKELY, stability: .IMPROBABLE, impulsiveness: .IMPROBABLE, conscious: .IMPROBABLE, environmentalPhysicalBarriers: .HIGHLY_IMPROBABLE, poorExerciseControl: .HIGHLY_IMPROBABLE, brainDamage: .HIGHLY_IMPROBABLE, patientAndStable: .LIKELY, fast: .HIGHLY_LIKELY, adaptToTheOutside: .MODERATELY_LIKELY, slow: .IMPROBABLE, stickingToSpecificPart: .HIGHLY_IMPROBABLE, neurology: .MODERATELY_LIKELY, obsessive: .LIKELY, insecurity: .IMPROBABLE, uncompromising: .HIGHLY_IMPROBABLE, escapist: .HIGHLY_IMPROBABLE, simplicity: .LIKELY, exposure: .HIGHLY_IMPROBABLE, lowMentalIntelligence: .HIGHLY_IMPROBABLE, selfClosed: .HIGHLY_IMPROBABLE, guiltyConscience: .HIGHLY_IMPROBABLE, delusionalSchizophrenia: .HIGHLY_IMPROBABLE, anxiety: .IMPROBABLE, morbidOmen: .HIGHLY_IMPROBABLE, difficultyAccessToEnvironment: .HIGHLY_IMPROBABLE, bystanderAttitude: .HIGHLY_IMPROBABLE, workToWardToFuture: .LIKELY, futureuncertainty: .NOT_VERY_LIKELY, specialFeelingsForParents: .EVEN_ODDS)
            
            houseInspectionResult = HouseResultModel(scienceFiction: .HIGHLY_IMPROBABLE, emotionalAwareness: .HIGHLY_IMPROBABLE, obsessed: .HIGHLY_IMPROBABLE, lackOfControl: .HIGHLY_IMPROBABLE, selfDefense: .EVEN_ODDS, healthySelf: .LIKELY, poorSelfControl: .IMPROBABLE, criticalPower: .HIGHLY_IMPROBABLE, insufficientContact: .HIGHLY_IMPROBABLE, anxietyAtRealLevel: .MODERATELY_LIKELY, reluctantToEnvironment: .HIGHLY_IMPROBABLE, excessiveDependence: .HIGHLY_IMPROBABLE, desireToEmotionalWarmth: .IMPROBABLE, emotionsOfNotWantingToContact: .HIGHLY_IMPROBABLE, paranoia: .HIGHLY_IMPROBABLE, defensive: .NOT_VERY_LIKELY, preferenceOfDualRoles: .IMPROBABLE, openness: .EVEN_ODDS, skepticism: .HIGHLY_IMPROBABLE, characteristicsOfTheLipid: .HIGHLY_IMPROBABLE, sticking: .HIGHLY_IMPROBABLE, femeinine: .IMPROBABLE, existenceOfTension: .EVEN_ODDS, lackOfHomeWarmth: .EVEN_ODDS, pessimisticThoughtsFuture: .MODERATELY_LIKELY, distancingSelf: .HIGHLY_LIKELY, defensiveMeasures: .HIGHLY_IMPROBABLE, levelOfAnxiety: .MODERATELY_LIKELY, strongDesireForDependence: .HIGHLY_IMPROBABLE, obviousEnvySim: .HIGHLY_IMPROBABLE, seekingMotherProtection: .EVEN_ODDS)
            
            treeInspectionResult = TreeResultModel(energeticBeing: .LIKELY, haveFeelingsThatBeingDriven: .HIGHLY_IMPROBABLE, closed: .HIGHLY_IMPROBABLE, inferior: .HIGHLY_IMPROBABLE, signsOfMaladjustment: .IMPROBABLE, strongSensitivity: .IMPROBABLE, lackOfWarmth: .IMPROBABLE, pathologicalSigns: .HIGHLY_IMPROBABLE, actAggressively: .HIGHLY_IMPROBABLE, helplessness: .EVEN_ODDS, inflexiblePersonality: .HIGHLY_IMPROBABLE, slow: .HIGHLY_IMPROBABLE, strongFixationOnPast: .HIGHLY_IMPROBABLE, disbeliefInExtraterestrials: .HIGHLY_IMPROBABLE, pressure: .HIGHLY_IMPROBABLE, psychologicalTrauma: .HIGHLY_IMPROBABLE, highEnergy: .EVEN_ODDS, lowEnergy: .NOT_VERY_LIKELY, interestExpands: .EVEN_ODDS, depressed: .HIGHLY_IMPROBABLE, richSensitivity: .HIGHLY_IMPROBABLE, extroversion: .EVEN_ODDS, intellignece: .HIGHLY_IMPROBABLE, selfImprovement: .HIGHLY_IMPROBABLE, strongCriticism: .HIGHLY_IMPROBABLE, easyEmotions: .HIGHLY_IMPROBABLE, notSeekSatisfaction: .HIGHLY_IMPROBABLE, tryingToGetSatisfaction: .HIGHLY_IMPROBABLE, incompetence: .HIGHLY_IMPROBABLE, loveCraving: .HIGHLY_IMPROBABLE, interestInFamily: .HIGHLY_IMPROBABLE, grownIndependently: .HIGHLY_IMPROBABLE, lossOfLivelihood: .HIGHLY_IMPROBABLE, realityVerification: .HIGHLY_IMPROBABLE, instability: .HIGHLY_IMPROBABLE, immaturity: .HIGHLY_IMPROBABLE, strongDesireForStability: .MODERATELY_LIKELY, lossOfSelfConttrol: .HIGHLY_IMPROBABLE, helpless: .MODERATELY_LIKELY, face: .HIGHLY_IMPROBABLE, feelingRejected: .HIGHLY_IMPROBABLE, stonglyConscious: .HIGHLY_IMPROBABLE, resistive: .HIGHLY_IMPROBABLE, successiveBeats: .HIGHLY_IMPROBABLE, dependentOnOthers: .EVEN_ODDS, calm: .EVEN_ODDS)
            
            personInspectionResult = PersonResultModel(thinkingDisorder: .HIGHLY_IMPROBABLE, lowConfidence: .HIGHLY_IMPROBABLE, strongIntellectualEffort: .HIGHLY_LIKELY, obsessivePatients: .HIGHLY_IMPROBABLE, avoidFacingWorld: .HIGHLY_IMPROBABLE, lackOfConfidence: .HIGHLY_IMPROBABLE, compensationPsychology: .HIGHLY_IMPROBABLE, extremeAnxietyInEmotionalExchange: .HIGHLY_IMPROBABLE, ambivalenceOfApproach: .HIGHLY_IMPROBABLE, expressionOfEmotions: .HIGHLY_IMPROBABLE, atrophy: .HIGHLY_IMPROBABLE, anxietyInEmotionalExchange: .HIGHLY_IMPROBABLE, innerEmptiness: .HIGHLY_IMPROBABLE, narrowingTheChannel: .HIGHLY_IMPROBABLE, irritable: .HIGHLY_IMPROBABLE, obsessivePersonality: .HIGHLY_IMPROBABLE, contempt: .HIGHLY_IMPROBABLE, wild: .EVEN_ODDS, sentimentsAnxiety: .HIGHLY_IMPROBABLE, extremeSensitivity: .HIGHLY_IMPROBABLE, emotionalStimulus: .HIGHLY_IMPROBABLE, anxietyAboutEmotionalExchange: .HIGHLY_IMPROBABLE, veryInterestedInAppearance: .EVEN_ODDS, desireToShowOffOneSelf: .HIGHLY_IMPROBABLE, conflictWithSex: .EVEN_ODDS, homosexualTendencies: .HIGHLY_IMPROBABLE, powerStruggles: .HIGHLY_IMPROBABLE, agression: .HIGHLY_IMPROBABLE, considerableAggression: .HIGHLY_IMPROBABLE, bad: .HIGHLY_IMPROBABLE, immatureAttitude: .HIGHLY_IMPROBABLE, denialOfEarlyDepression: .HIGHLY_IMPROBABLE, projectingWeakness: .HIGHLY_IMPROBABLE, strongRejection: .HIGHLY_IMPROBABLE, conflictOrLackOfRelationships: .HIGHLY_IMPROBABLE, psychology: .HIGHLY_IMPROBABLE, avoidEmotionalInteraction: .LIKELY, insensitive: .LIKELY, personalityHostility: .HIGHLY_IMPROBABLE, excessiveDesireForAffection: .HIGHLY_IMPROBABLE, interpersonalInteractions: .HIGHLY_IMPROBABLE, happiness: .HIGHLY_IMPROBABLE, needAuthority: .HIGHLY_IMPROBABLE, weakness: .HIGHLY_IMPROBABLE, symbolOfPower: .EVEN_ODDS, desireToSignify: .HIGHLY_IMPROBABLE, sexualImmorality: .HIGHLY_IMPROBABLE, activeDaydreaming: .HIGHLY_IMPROBABLE, personallyExcessive: .HIGHLY_IMPROBABLE, excessivePassive: .HIGHLY_IMPROBABLE, impulsiveness: .HIGHLY_IMPROBABLE, selfish: .EVEN_ODDS)
        #endif
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
    
    func uploadResults(answer_House: HouseEssentialQuestionAnswerModel, answer_Tree: TreeEssentialQuestionAnswerModel, answer_Person_1: PersonEssentialQuestionAnswerModel, answer_Person_2: PersonEssentialQuestionAnswerModel,
                       img_House: UIImage, img_Tree: UIImage, img_Person_1: UIImage, img_Person_2: UIImage,
                       img_House_Detected: UIImage, img_Tree_Detected: UIImage, img_Person_1_Detected: UIImage, img_Person_2_Detected: UIImage,
                     UID: String, date: String?, elapsedTimes: [Int], completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss"
        let current = dateFormatter.string(from: Date())
        
        let docRef = self.db.collection("Inspection").document(auth.currentUser?.uid ?? "").setData([
            "latstInspection": date ?? current
        ]){_ in
            self.db.collection("Inspection").document(self.auth.currentUser?.uid ?? "").collection("Results").document(date ?? current).setData([
                "isSuccessful": true
            ]){error in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                } else{
                    let data = self.createPDF(answer_House: answer_House, answer_Tree: answer_Tree, answer_Person_1: answer_Person_1, answer_Person_2: answer_Person_2, img_House: img_House, img_Tree: img_Tree, img_Person_1: img_Person_1, img_Person_2: img_Person_2, img_House_Detected: img_House_Detected, img_Tree_Detected: img_Tree_Detected, img_Person_1_Detected: img_Person_1_Detected, img_Person_2_Detected: img_Person_2_Detected, UID: UID, date: date, elapsedTimes: elapsedTimes)
                    
                    self.storage.reference().child("Results/\(self.auth.currentUser?.uid ?? "")/\(date ?? current)/\(date ?? current).pdf").putData(data, metadata: nil){(metadata, error) in
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
    
    func getLatestHistory(completion: @escaping(_ result: Bool?) -> Void){
        self.db.collection("Inspection").document(auth.currentUser?.uid ?? "").getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if document != nil{
                self.latestInspectionResult = document!.get("latstInspection") as? String ?? nil
                completion(true)
                return
            }
        }
    }
    
    func getInspectionHistory(completion: @escaping(_ result: Bool?) -> Void){
        self.inspectionResults.removeAll()
        
        self.db.collection("Inspection").document(auth.currentUser?.uid ?? "").collection("Results").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    self.inspectionResults.append(document.documentID)
                }
            }
            
            self.inspectionResults.sort(by: {$0 > $1})
            completion(true)
            return
        }
    }
    
    func getInspectionHistory(uid: String, completion: @escaping(_ result: [String]?) -> Void){
        var results: [String] = []
        
        self.db.collection("Inspection").document(uid).collection("Results").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            } else{
                if querySnapshot != nil{
                    for document in querySnapshot!.documents{
                        results.append(document.documentID)
                    }
                }
            }
            
            results.sort(by: {$0 > $1})
            
            completion(results)
            return
        }
    }
    
    func getFileURL(id: String, completion: @escaping(_ result: Bool?) -> Void){
        storage.reference().child("Results/\(auth.currentUser?.uid ?? "")/\(id)/\(id).pdf").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.fileURL = downloadURL
            completion(true)
            return
        }
    }
    
    func getFileURL(uid: String, id: String, completion: @escaping(_ result: Bool?) -> Void){
        storage.reference().child("Results/\(uid)/\(id)/\(id).pdf").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.fileURL = downloadURL
            completion(true)
            return
        }
    }
    
    func createPDF(answer_House: HouseEssentialQuestionAnswerModel, answer_Tree: TreeEssentialQuestionAnswerModel, answer_Person_1: PersonEssentialQuestionAnswerModel, answer_Person_2: PersonEssentialQuestionAnswerModel,
                     img_House: UIImage, img_Tree: UIImage, img_Person_1: UIImage, img_Person_2: UIImage,
                     img_House_Detected: UIImage, img_Tree_Detected: UIImage, img_Person_1_Detected: UIImage, img_Person_2_Detected: UIImage,
                   UID: String, date: String?, elapsedTimes: [Int]) -> Data{
        var date: String? = date
        let questions_House = ["이 집은 도심에 있는 집인가요?", "이 집 가까이에 다른 집이 있나요?",
                                "이 그림에서 날씨는 어떠한가요?", "이 집은 당신에게서 멀리 있는 집인가요?",
                                "이 집에 살고 있는 가족은 몇 사람인가요?", "이 집에 살고 있는 가족은 어떤 사람들인가요?",
                                "가정의 분위기는 어떤가요?", "이 집을 보면 누가 생각나나요?",
                                "당신은 이 집의 어느 방에 살고 싶은가요?", "당신은 누구와 이 집에 살고 싶은가요?",
                                "당신의 집은 이 집보다 큰가요?", "이 집을 그릴 때 누구의 집을 생각하고 그렸나요?",
                                "이 그림에 첨가하여 더 그리고 싶은 것이 있나요?", "당신이 그리려고 했던 대로 잘 그려졌나요?"]
        
        let questions_Tree = ["이 나무는 상록수인가요?", "이 나무는 숲 속에 있나요? (아니오: 한 그루만 있음)",
                                "이 그림의 날씨는 어떠한가요?", "바람이 불고 있나요?",
                                "이 나무는 몇 년쯤 된 나무인가요?", "이 나무는 살아 있나요?",
                                "이 나무가 죽었다면 언제쯤 말라죽었나요?", "이 나무는 강한 나무인가요?",
                                "이 나무는 당신에게 누구를 생각나게 하나요?", "이 나무는 남자와 여자 중 어느 쪽을 닮았나요?",
                                "이 나무는 당신으로부터 멀리 있나요?", "이 나무는 당신보다 큰가요?",
                                "이 그림에 더 첨가하여 그리고 싶은 것이 있나요?", "당신이 그리려고 했던 대로 잘 그려졌나요?"]
        
        let questions_Person = ["이 사람의 나이는 몇 살인가요?", "이 사람은 결혼을 했나요?",
                                "이 사람의 가족은 몇 명인가요?", "이 사람의 가족은 어떤 사람들인가요?",
                                "이 사람의 신체는 건강한가요?", "이 사람은 친구가 많나요?",
                                "이 사람의 친구는 어떤 친구들인가요?", "이 사람의 성질은 어떠한가요?",
                                "이 사람은 행복한가요?", "이 사람에게 필요한게 있나요?",
                                "당신은 이 사람이 좋나요?", "당신은 이 사람처럼 되고 싶나요?",
                                "당신은 이 사람과 함께 생활하고 친구가 되고 싶나요?", "당신은 이 사람을 그릴 때 누구를 생각하고 있었나요?",
                                "이 사람은 누구를 닮았나요?"]
        
        if date == nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy. MM. dd. hh:mm:ss"
            
            date = dateFormatter.string(from: Date())
        }

        let pdfMetaData = [
            kCGPDFContextCreator: "DeepMind",
            kCGPDFContextAuthor: "DeepMind",
            kCGPDFContextTitle: "DeepMind_\(UID)_\(date!)"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String : Any]
        
        let pageRect = CGRect(x: 10, y: 10, width: 595.2, height: 841.8)
        let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.5
        
        let aspectWidth = maxWidth / 1280
        let aspectHeight = maxHeight / 1280
        let aspectRatio = min(aspectWidth, aspectHeight)
        let scaledWidth = 1280 * aspectRatio
        let scaledHeight = 1280 * aspectRatio
                
        let data = graphicsRenderer.pdfData{(context) in
            context.beginPage()
            
            let initialCursor: CGFloat = 279
            let deepMindLogo = UIImage(named: "ic_appstore")?.withRoundedCorners(radius: 40)
            
            let img_logo_Rect = CGRect(x: (pageRect.width/2) - (scaledWidth / 2), y: initialCursor, width: scaledWidth, height: scaledHeight)
            deepMindLogo!.draw(in: img_logo_Rect)
            
            var cursor = (scaledHeight + 3 + initialCursor)
            
            cursor = context.addCenteredText(fontSize: 24, weight: .bold, text: "DeepMind", cursor: cursor, pdfSize: pageRect.size)
            
            cursor += 12

            cursor = context.addCenteredText(fontSize: 24, weight: .bold, text: "HTP 검사 결과", cursor: cursor, pdfSize: pageRect.size)
            
            cursor += 12
            
            let leftMargin: CGFloat = 74
            
            cursor = context.addCenteredText(fontSize: 6, weight: .thin, text: "환자 고유 ID : \(UID)", cursor: cursor, pdfSize: pageRect.size)
            
            cursor += 6
            
            cursor = context.addCenteredText(fontSize: 12, weight: .thin, text: "검사일 : \(date!)", cursor: cursor, pdfSize: pageRect.size)
            
            context.beginPage()
            
            cursor = 12
            
            cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "집 (House) | 검사 소요 시간: \(elapsedTimes[0])초", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
            
            cursor += 6
            
            let img_H_Rect = CGRect(x: 12, y: cursor, width: scaledWidth, height: scaledHeight)
            img_House.draw(in: img_H_Rect)
                        
            let img_H_Detected_Rect = CGRect(x: 12 + scaledWidth, y: cursor, width: scaledWidth, height: scaledHeight)
            img_House_Detected.draw(in: img_H_Detected_Rect)
            
            cursor += (scaledHeight + 6)
            
            cursor = context.addSingleLineText(fontSize: 12, weight: .semibold, text: "필수 문답 (집)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
            
            cursor += 6
            
            for i in 0 ..< questions_House.count{
                cursor = context.addSingleLineText(fontSize: 12, weight: .regular, text: "\(questions_House[i]) : \(answer_House.getAnswer(index: i))", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                cursor += 6
            }
            
            context.beginPage()
            
            cursor = 12
            
            cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "나무 (Tree) | 검사 소요 시간: \(elapsedTimes[1])초", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
            
            cursor += 6
            
            let img_T_Rect = CGRect(x: 12, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Tree.draw(in: img_T_Rect)
                        
            let img_T_Detected_Rect = CGRect(x: 12 + scaledWidth, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Tree_Detected.draw(in: img_T_Detected_Rect)
            
            cursor += (scaledHeight + 6)
            
            cursor = context.addSingleLineText(fontSize: 12, weight: .semibold, text: "필수 문답 (나무)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
            
            cursor += 6
            
            for i in 0 ..< questions_Tree.count{
                cursor = context.addSingleLineText(fontSize: 12, weight: .regular, text: "\(questions_Tree[i]) : \(answer_Tree.getAnswer(index: i))", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                cursor += 6
            }
            
            context.beginPage()
            
            cursor = 12
            
            cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "첫번째 사람 (Person_1) | 검사 소요 시간: \(elapsedTimes[2])초", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
            
            cursor += 6
            
            let img_P_1_Rect = CGRect(x: 12, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Person_1.draw(in: img_P_1_Rect)
                        
            let img_P_1_Detected_Rect = CGRect(x: 12 + scaledWidth, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Person_1_Detected.draw(in: img_P_1_Detected_Rect)
            
            cursor += (scaledHeight + 6)
            
            cursor = context.addSingleLineText(fontSize: 12, weight: .semibold, text: "필수 문답 (첫번째 사람)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
            
            cursor += 6
            
            for i in 0 ..< questions_Person.count{
                cursor = context.addSingleLineText(fontSize: 12, weight: .regular, text: "\(questions_Person[i]) : \(answer_Person_1.getAnswer(index: i))", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                cursor += 6
            }
            
            context.beginPage()
            
            cursor = 12
            
            cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "두번째 사람 (Person_2) | 검사 소요 시간: \(elapsedTimes[3])초", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
            
            cursor += 6
            
            let img_P_2_Rect = CGRect(x: 12, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Person_2.draw(in: img_P_2_Rect)
                        
            let img_P_2_Detected_Rect = CGRect(x: 12 + scaledWidth, y: cursor, width: scaledWidth, height: scaledHeight)
            img_Person_2_Detected.draw(in: img_P_2_Detected_Rect)
            
            cursor += (scaledHeight + 6)
            
            cursor = context.addSingleLineText(fontSize: 12, weight: .semibold, text: "필수 문답 (두번째 사람)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
            
            cursor += 6
            
            for i in 0 ..< questions_Person.count{
                cursor = context.addSingleLineText(fontSize: 12, weight: .regular, text: "\(questions_Person[i]) : \(answer_Person_2.getAnswer(index: i))", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                cursor += 6
            }
            
            if commonInspectionResult != nil{
                context.beginPage()
                
                cursor = 12
                
                cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "HTP 검사 분석 결과 (공통)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
                                
                let titles = self.commonInspectionResult!.getTitle()
                let results = self.commonInspectionResult!.getResults()
                
                for i in titles.indices{
                    cursor += 10
                    
                    context.addSingleLineText(fontSize: 8, weight: .regular, text: "\(titles[i]) : \(results[i].rawValue)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                }
            }
            
            if houseInspectionResult != nil{
                context.beginPage()
                
                cursor = 12
                
                cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "HTP 검사 분석 결과 (집)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
                                
                let titles = self.houseInspectionResult!.getTitle()
                let results = self.houseInspectionResult!.getResults()
                
                for i in titles.indices{
                    cursor += 10

                    context.addSingleLineText(fontSize: 8, weight: .regular, text: "\(titles[i]) : \(results[i].rawValue)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                }
            }
            
            if treeInspectionResult != nil{
                context.beginPage()
                
                cursor = 15
                
                cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "HTP 검사 분석 결과 (나무)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
                                
                let titles = self.treeInspectionResult!.getTitle()
                let results = self.treeInspectionResult!.getResults()
                
                for i in titles.indices{
                    cursor += 10

                    context.addSingleLineText(fontSize: 8, weight: .regular, text: "\(titles[i]) : \(results[i].rawValue)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                }
            }
            
            if personInspectionResult != nil{
                context.beginPage()
                
                cursor = 12
                
                cursor = context.addSingleLineText(fontSize: 16, weight: .semibold, text: "HTP 검사 분석 결과 (사람)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: .underline, annotationColor: .black)
                                
                let titles = self.personInspectionResult!.getTitle()
                let results = self.personInspectionResult!.getResults()
                
                for i in titles.indices{
                    cursor += 10
                    
                    context.addSingleLineText(fontSize: 8, weight: .regular, text: "\(titles[i]) : \(results[i].rawValue)", indent: leftMargin, cursor: cursor, pdfSize: pageRect.size, annotation: nil, annotationColor: .black)
                }
            }

        }
        
        self.data = data
        
        return data
    }

    func exportAsPDF(data: Data, UID: String) -> URL{
        let document = PDFDocument(data: data)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd_hhmmss"
        
        let date = dateFormatter.string(from: Date())
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("HTP_\(UID)_\(date).pdf", isDirectory: false)
        
        try? document?.write(to: fileURL)
        
        return fileURL
    }
}
