//
//  HouseEssentialQuestionModels.swift
//  DeepMind
//
//  Created by 하창진 on 8/17/23.
//

import Foundation

enum HouseWeatherModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}

    case SUNNY, CLOUDY, RAINING, SNOWING
    
    var description: String{
        switch self{
        case .SUNNY:
            return "맑음"
            
        case .CLOUDY:
            return "흐림"
            
        case .RAINING:
            return "비"
            
        case .SNOWING:
            return "눈"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "맑음":
            return .SUNNY
            
        case "흐림":
            return .CLOUDY
            
        case "비":
            return .RAINING
            
        case "눈":
            return .SNOWING
            
        default:
            return .SUNNY
        }
    }
}

enum HouseFamilyTypeModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    
    case KIND, WARM, VIOLENT, DISSENSION, HAPPY, SCARY
    
    var description: String{
        switch self{
        case .KIND:
            return "친절한"
            
        case .WARM:
            return "따뜻한"
            
        case .VIOLENT:
            return "폭력적인"
            
        case .DISSENSION:
            return "불화가 있는"
            
        case .HAPPY:
            return "행복한"
            
        case .SCARY:
            return "무서운"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "친절한":
            return .KIND
            
        case "따뜻한":
            return .WARM
            
        case "폭력적인":
            return .VIOLENT
            
        case "불화가 있는":
            return .DISSENSION
            
        case "행복한":
            return .HAPPY
            
        case "무서운":
            return .SCARY
            
        default:
            return .KIND
        }
    }
}

enum HouseAtmosphereModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    
    case HARMONIOUS, WARM, VIOLENT, UNAFFECTIONATE
    
    var description: String{
        switch self{
        case .HARMONIOUS:
            return "화목한"
            
        case .WARM:
            return "따뜻한"
            
        case .VIOLENT:
            return "폭력적인"
            
        case .UNAFFECTIONATE:
            return "애정이 없는"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "화목한":
            return .HARMONIOUS
            
        case "따뜻한":
            return .WARM
            
        case "폭력적인":
            return .VIOLENT
            
        case "애정이 없는":
            return .UNAFFECTIONATE
            
        default:
            return .HARMONIOUS
        }
    }
}

enum HouseInspirationModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    
    case PARENT, BROTHERS, SPOUSE, FAMILY, FRIENDS, LOVER, OTHERS
    
    var description: String{
        switch self{
        case .PARENT:
            return "부모"
            
        case .BROTHERS:
            return "형제/자매"
            
        case .SPOUSE:
            return "배우자"
            
        case .FAMILY:
            return "그 외 가족"

        case .FRIENDS:
            return "친구"
            
        case .LOVER:
            return "애인"
            
        case .OTHERS:
            return "그 외/모르는 사람"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "부모":
            return .PARENT
            
        case "형제/자매":
            return .BROTHERS
            
        case "배우자":
            return .SPOUSE
            
        case "그 외 가족":
            return .FAMILY
            
        case "친구":
            return .FRIENDS
            
        case "애인":
            return .LOVER
            
        case "그 외/모르는 사람":
            return .OTHERS
            
        default:
            return .PARENT
        }
    }
}

enum HouseRoomModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    
    case LARGE, SMALL, LIVING_ROOM, ANY
    
    var description: String{
        switch self{
        case .LARGE:
            return "큰 방"
            
        case .SMALL:
            return "작은 방"
            
        case .LIVING_ROOM:
            return "거실"
            
        case .ANY:
            return "기타/상관없음"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "큰 방":
            return .LARGE
            
        case "작은 방":
            return .SMALL
            
        case "거실":
            return .LIVING_ROOM
            
        case "기타/상관없음":
            return .ANY
            
        default:
            return .LARGE
        }
    }
}

enum HouseReferenceModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    
    case PARENT, BROTHERS, SPOUSE, FAMILY, FRIENDS, LOVER, MY, OTHERS
    
    var description: String{
        switch self{
        case .PARENT:
            return "부모"
            
        case .BROTHERS:
            return "형제/자매"
            
        case .SPOUSE:
            return "배우자"
            
        case .FAMILY:
            return "그 외 가족"

        case .FRIENDS:
            return "친구"
            
        case .LOVER:
            return "애인"
            
        case .MY:
            return "자신"
            
        case .OTHERS:
            return "그 외/모르는 사람"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "부모":
            return .PARENT
            
        case "형제/자매":
            return .BROTHERS
            
        case "배우자":
            return .SPOUSE
            
        case "그 외 가족":
            return .FAMILY
            
        case "친구":
            return .FRIENDS
            
        case "애인":
            return .LOVER
            
        case "자신":
            return .MY
            
        case "그 외/모르는 사람":
            return .OTHERS
            
        default:
            return .PARENT
        }
    }
}
