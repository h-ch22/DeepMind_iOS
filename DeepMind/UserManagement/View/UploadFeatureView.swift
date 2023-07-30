//
//  UploadFeatureView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct UploadFeatureView: View {
    @State private var isChildAbuseAttacker: FeatureSeverityOption?
    @State private var isChildAbuseVictim: FeatureSeverityOption?
    @State private var isDomesticViolenceAttacker: FeatureSeverityOption?
    @State private var isDomesticViolenceVictim: FeatureSeverityOption?
    @State private var isPsychosis: FeatureSeverityOption?
    @State private var alertModel : SignUpAlertModel? = nil

    @State private var showProgress = false
    @State private var showAlert = false
    @State private var showHome = false
    
    @StateObject var helper: UserManagement
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Text("추가정보를 입력해주세요.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                    
                    Spacer().frame(height : 10)
                    
                    Text("모든 정보는 암호화되어 저장되며, 해당 정보는 사용자를 제외한 모든 사람이 조회할 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer().frame(height : 40)
                    
                    HStack{
                        Text("귀하께서는 아동학대 가해자로 판정받으신 적이 있습니까?")
                            .foregroundStyle(Color.txt_color)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        RadioButtonGroup(selection: $isChildAbuseAttacker,
                                         orientation: .horizonal,
                                         tags: FeatureSeverityOption.allCases,
                                         button: { isSelected in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.5)
                                    .frame(width : 20, height : 20)
                                    .animation(.easeInOut, value: 1.0)
                                
                                if isSelected{
                                    Circle()
                                        .foregroundColor(.accent)
                                        .frame(width : 10, height : 10)
                                        .animation(.easeInOut, value: 1.0)
                                }
                            }
                        }, label: {tag in
                            Text("\(tag.description)")
                        })
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text("귀하께서는 아동학대 피해자로 판정받으신 적이 있습니까?")
                            .foregroundStyle(Color.txt_color)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        RadioButtonGroup(selection: $isChildAbuseVictim,
                                         orientation: .horizonal,
                                         tags: FeatureSeverityOption.allCases,
                                         button: { isSelected in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.5)
                                    .frame(width : 20, height : 20)
                                    .animation(.easeInOut, value: 1.0)
                                
                                if isSelected{
                                    Circle()
                                        .foregroundColor(.accent)
                                        .frame(width : 10, height : 10)
                                        .animation(.easeInOut, value: 1.0)
                                }
                            }
                        }, label: {tag in
                            Text("\(tag.description)")
                        })
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text("귀하께서는 가정폭력 가해자로 판정받으신 적이 있습니까?")
                            .foregroundStyle(Color.txt_color)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        RadioButtonGroup(selection: $isDomesticViolenceAttacker,
                                         orientation: .horizonal,
                                         tags: FeatureSeverityOption.allCases,
                                         button: { isSelected in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.5)
                                    .frame(width : 20, height : 20)
                                    .animation(.easeInOut, value: 1.0)
                                
                                if isSelected{
                                    Circle()
                                        .foregroundColor(.accent)
                                        .frame(width : 10, height : 10)
                                        .animation(.easeInOut, value: 1.0)
                                }
                            }
                        }, label: {tag in
                            Text("\(tag.description)")
                        })
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text("귀하께서는 가정폭력 피해자로 판정받으신 적이 있습니까?")
                            .foregroundStyle(Color.txt_color)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        RadioButtonGroup(selection: $isDomesticViolenceVictim,
                                         orientation: .horizonal,
                                         tags: FeatureSeverityOption.allCases,
                                         button: { isSelected in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.5)
                                    .frame(width : 20, height : 20)
                                    .animation(.easeInOut, value: 1.0)
                                
                                if isSelected{
                                    Circle()
                                        .foregroundColor(.accent)
                                        .frame(width : 10, height : 10)
                                        .animation(.easeInOut, value: 1.0)
                                }
                            }
                        }, label: {tag in
                            Text("\(tag.description)")
                        })
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text("귀하께서는 전문의로부터 정신병 및 관련 질환을 진단받으신 적이 있습니까?")
                            .foregroundStyle(Color.txt_color)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        RadioButtonGroup(selection: $isPsychosis,
                                         orientation: .horizonal,
                                         tags: FeatureSeverityOption.allCases,
                                         button: { isSelected in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.5)
                                    .frame(width : 20, height : 20)
                                    .animation(.easeInOut, value: 1.0)
                                
                                if isSelected{
                                    Circle()
                                        .foregroundColor(.accent)
                                        .frame(width : 10, height : 10)
                                        .animation(.easeInOut, value: 1.0)
                                }
                            }
                        }, label: {tag in
                            Text("\(tag.description)")
                        })
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action: {
                        if isChildAbuseVictim?.description == nil ||
                            isChildAbuseAttacker?.description == nil ||
                            isDomesticViolenceVictim?.description == nil ||
                            isDomesticViolenceAttacker?.description == nil ||
                            isPsychosis?.description == nil{
                            alertModel = .EMPTY_FIELD
                            showAlert = true
                        } else{
                            showProgress = true
                            helper.uploadFeatures(isChildAbuseAttacker: isChildAbuseAttacker?.code == 1 ? true : false,
                                                  isChildAbuseVictim: isChildAbuseVictim?.code == 1 ? true : false,
                                                  isDomesticViolenceAttacker: isDomesticViolenceAttacker?.code == 1 ? true : false,
                                                  isDomesticViolenceVictim: isDomesticViolenceVictim?.code == 1 ? true : false,
                                                  isPsychosis: isPsychosis?.code == 1 ? true : false){ result in
                                guard let result = result else{return}
                                
                                if !result{
                                    alertModel = .INTERNAL_ERROR
                                    showAlert = true
                                } else{
                                    showHome = true
                                }
                                
                                showProgress = false
                            }
                        }
                    }){
                        HStack{
                            Text("다음 단계로")
                                .foregroundColor(.white)
                            
                            Image(systemName : "chevron.right")
                                .foregroundColor(.white)
                        }.padding([.vertical], 20)
                            .padding([.horizontal], 120)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.accent).shadow(radius: 5))
                    }
                }
                .animation(.easeInOut).padding(20)
                .overlay(ProcessView().isHidden(!showProgress))
                .alert(isPresented: $showAlert, error: alertModel){ _ in
                    
                } message: {error in
                    Text(error.recoverySuggestion ?? "")
                }
                .fullScreenCover(isPresented: $showHome, content: {
                    TabManager().environmentObject(helper)
                })
            }
        }
    }
}

#Preview {
    UploadFeatureView(helper: UserManagement())
}
