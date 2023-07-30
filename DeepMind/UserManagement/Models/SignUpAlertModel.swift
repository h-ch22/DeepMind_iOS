//
//  SignUpAlertModel.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation

enum SignUpAlertModel : Error, LocalizedError{
    case WEAK_PASSWORD, PASSWORD_MISMATCH, EMPTY_FIELD, REQUIRED_LICENSE_ACCEPT, ERROR, INVALID_EMAIL_TYPE, INTERNAL_ERROR
    
    var failureReason: String?{
        switch self{
        case .WEAK_PASSWORD:
            return "안전하지 않은 비밀번호"
            
        case .PASSWORD_MISMATCH:
            return "비밀번호 불일치"
            
        case .EMPTY_FIELD:
            return "공백 필드"
            
        case .REQUIRED_LICENSE_ACCEPT:
            return "약관 동의 필요"
            
        case .ERROR:
            return "오류"
            
        case .INVALID_EMAIL_TYPE:
            return "올바르지 않은 E-Mail 형식"
            
        case .INTERNAL_ERROR:
            return "알 수 없는 오류"
        }
    }
    
    var recoverySuggestion: String?{
        switch self{
        case .WEAK_PASSWORD:
            return "보안을 위해 6자리 이상의 비밀번호를 설정해주세요."
            
        case .PASSWORD_MISMATCH:
            return "비밀번호와 비밀번호 확인을 다시 입력해주세요."
            
        case .EMPTY_FIELD:
            return "모든 필수 항목을 입력해주세요."
            
        case .REQUIRED_LICENSE_ACCEPT:
            return "필수 동의 항목을 읽고 동의해주세요."
            
        case .ERROR:
            return "네트워크 상태를 확인하거나 이미 가입된 E-Mail인지 확인해주세요."
            
        case .INVALID_EMAIL_TYPE:
            return "올바른 형식의 E-Mail을 입력해주세요."
            
        case .INTERNAL_ERROR:
            return "네트워크 상태, 정상 회원가입 여부를 확인한 후 다시 시도해주세요."
        }
    }
    
    var errorDescription: String?{
        switch self{
        case .WEAK_PASSWORD:
            return "비밀번호의 길이가 너무 짧습니다."
            
        case .PASSWORD_MISMATCH:
            return "비밀번호와 비밀번호 확인이 일치하지 않습니다."
            
        case .EMPTY_FIELD:
            return "필수 입력 항목 중 일부가 누락되었습니다."
            
        case .REQUIRED_LICENSE_ACCEPT:
            return "필수 동의 약관 중 일부가 동의되지 않았습니다."
            
        case .ERROR:
            return "작업을 처리하는 중 오류가 발생했습니다."
            
        case .INVALID_EMAIL_TYPE:
            return "입력한 E-Mail의 형식이 올바르지 않습니다."
            
        case .INTERNAL_ERROR:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
