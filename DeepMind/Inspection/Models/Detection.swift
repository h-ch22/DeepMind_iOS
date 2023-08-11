//
//  Detection.swift
//  DeepMind
//
//  Created by 하창진 on 8/10/23.
//

import Foundation
import UIKit

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}
