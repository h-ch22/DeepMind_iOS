//
//  InspectionHelper.swift
//  DeepMind
//
//  Created by 하창진 on 8/1/23.
//

import Foundation
import CoreML
import UIKit
import Vision

class InspectionHelper: ObservableObject{
    func detect(){
        guard let URL_CL01 = Bundle.main.url(forResource: "CL01", withExtension: "mlmodel", subdirectory: "include") else{
            print("CL01 Directory cannot be founded.")
            return
        }
        
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndNeuralEngine
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
        let houseDirectory = directory.appendingPathComponent("House.png", isDirectory: false)
        let houseImage = UIImage(contentsOfFile: houseDirectory!.absoluteString)
        
        do{
            let model_CL01 = try VNCoreMLModel(for: MLModel(contentsOf: URL_CL01, configuration: config))

        } catch let error as NSError{
            print("model cannot be loaded: \(error)")
        }
    }
}
