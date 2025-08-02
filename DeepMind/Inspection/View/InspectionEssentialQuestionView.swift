//
//  InspectionEssentialQuestionView.swift
//  DeepMind
//
//  Created by 하창진 on 8/16/23.
//

import SwiftUI

struct InspectionEssentialQuestionView: View {
    let type: DrawingTypeModel
    @Binding var answer_House: HouseEssentialQuestionAnswerModel
    @Binding var answer_Tree: TreeEssentialQuestionAnswerModel
    @Binding var answer_Person_First: PersonEssentialQuestionAnswerModel
    @Binding var answer_Person_Second: PersonEssentialQuestionAnswerModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var answer_House_3: HouseWeatherModel = .SUNNY
    @State private var answer_House_5 = 0
    @State private var answer_House_6: HouseFamilyTypeModel = .KIND
    @State private var answer_House_7: HouseAtmosphereModel = .HARMONIOUS
    @State private var answer_House_8: HouseInspirationModel = .PARENT
    @State private var answer_House_9: HouseRoomModel = .LARGE
    @State private var answer_House_10: HouseInspirationModel = .PARENT
    @State private var answer_House_12: HouseReferenceModel = .PARENT
    @State private var answer_House_Yes_No: [Int: Bool] = [0: true, 1: true, 3: true, 10: true, 12: true, 13: true]
    
    @State private var answer_Tree_3: HouseWeatherModel = .SUNNY
    @State private var answer_Tree_5 = 0
    @State private var answer_Tree_7 = 0
    @State private var answer_Tree_9: HouseInspirationModel = .PARENT
    @State private var answer_Tree_10: PersonGenderModel = .MALE
    @State private var answer_Tree_Yes_No: [Int: Bool] = [0: true, 1: true, 3: true, 5: true, 7: true, 10: true, 11: true, 12: true, 13: true]
    @State private var showProgress = false
    
    @State private var answer_Person_1 = 0
    @State private var answer_Person_3 = 0
    @State private var answer_Person_4 : HouseFamilyTypeModel = .KIND
    @State private var answer_Person_7 : HouseFamilyTypeModel = .KIND
    @State private var answer_Person_8 : HouseFamilyTypeModel = .KIND
    @State private var answer_Person_14 : HouseReferenceModel = .PARENT
    @State private var answer_Person_15 : HouseReferenceModel = .PARENT
    @State private var answer_Person_Yes_No: [Int: Bool] = [1: true, 4: true, 5: true, 8: true, 9: true, 10: true, 11: true, 12: true]
    
    @State private var questions_House : [InspectionEssentialQuestionType] = [
        InspectionEssentialQuestionType(question: "이 집은 도심에 있는 집인가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 집 가까이에 다른 집이 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 그림에서 날씨는 어떠한가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 집은 당신에게서 멀리 있는 집인가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 집에 살고 있는 가족은 몇 사람인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 집에 살고 있는 가족은 어떤 사람들인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "가정의 분위기는 어떤가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 집을 보면 누가 생각나나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "당신은 이 집의 어느 방에 살고 싶은가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "당신은 누구와 이 집에 살고 싶나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "당신의 집은 이 집보다 큰가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 집을 그릴 때 누구의 집을 생각하고 그렸나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 그림에 첨가하여 더 그리고 싶은 것이 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신이 그리려고 했던 대로 잘 그려졌나요?", isYesNoQuestion: true)
    ]
    
    @State private var questions_Tree : [InspectionEssentialQuestionType] = [
        InspectionEssentialQuestionType(question: "이 나무는 상록수인가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 나무는 숲 속에 있나요? (아니오: 한 그루만 있음)", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 그림의 날씨는 어떠한가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "바람이 불고 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 나무는 몇 년쯤 된 나무인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 나무는 살아 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 나무가 죽었다면 언제쯤 말라죽었나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 나무는 강한 나무인가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 나무는 당신에게 누구를 생각나게 하나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 나무는 남자와 여자 중 어느 쪽을 닮았나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 나무는 당신으로부터 멀리 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 나무는 당신보다 큰가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 그림에 더 첨가하여 그리고 싶은 것이 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신이 그리려고 했던 대로 잘 그려졌나요?", isYesNoQuestion: true)
    ]
    
    @State private var questions_Person : [InspectionEssentialQuestionType] = [
        InspectionEssentialQuestionType(question: "이 사람의 나이는 몇 살인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람은 결혼을 했나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 사람의 가족은 몇 명인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람의 가족은 어떤 사람들인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람의 신체는 건강한가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 사람은 친구가 많나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 사람의 친구는 어떤 친구들인가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람의 성질은 어떠한가요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람은 행복한가요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "이 사람에게 필요한게 있나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신은 이 사람이 좋나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신은 이 사람처럼 되고 싶나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신은 이 사람과 함께 생활하고 친구가 되고 싶나요?", isYesNoQuestion: true),
        InspectionEssentialQuestionType(question: "당신은 이 사람을 그릴 때 누구를 생각하고 있었나요?", isYesNoQuestion: false),
        InspectionEssentialQuestionType(question: "이 사람은 누구를 닮았나요?", isYesNoQuestion: false)
    ]
    
    let img: UIImage?
    
    private func binding_Yes_No(for key: Int) -> Binding<Bool>{
        switch type{
        case .HOUSE:
            return .init(
                get: {self.answer_House_Yes_No[key, default: true]},
                set: {self.answer_House_Yes_No[key] = $0}
            )
            
        case .TREE:
            return .init(
                get: {self.answer_Tree_Yes_No[key, default: true]},
                set: {self.answer_Tree_Yes_No[key] = $0}
            )
            
        case .PERSON_1, .PERSON_2:
            return .init(
                get: {self.answer_Person_Yes_No[key, default: true]},
                set: {self.answer_Person_Yes_No[key] = $0}
            )
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        if img != nil{
                            Image(uiImage: img!)
                                .resizable()
                                .frame(width: 250, height : 250)
                            
                            Spacer().frame(height : 20)
                        }
                        
                        if type == .HOUSE{
                            Group{
                                ForEach(questions_House.indices, id:\.self){index in
                                    HStack{
                                        Text(questions_House[index].question)
                                        
                                        Spacer()
                                        
                                        if questions_House[index].isYesNoQuestion{
                                            CheckBox(checked: self.binding_Yes_No(for: index), title: "예")
                                        } else{
                                            switch index{
                                            case 2:
                                                Picker("답변 선택", selection: $answer_House_3){
                                                    ForEach(HouseWeatherModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 4:
                                                Stepper(value: $answer_House_5, in: 1...100, label: {
                                                    Text("\(answer_House_5)명")
                                                        .foregroundStyle(Color.accent)
                                                })
                                                
                                            case 5:
                                                Picker("답변 선택", selection: $answer_House_6){
                                                    ForEach(HouseFamilyTypeModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 6:
                                                Picker("답변 선택", selection: $answer_House_7){
                                                    ForEach(HouseAtmosphereModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 7:
                                                Picker("답변 선택", selection: $answer_House_8){
                                                    ForEach(HouseInspirationModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 8:
                                                Picker("답변 선택", selection: $answer_House_9){
                                                    ForEach(HouseRoomModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 9:
                                                Picker("답변 선택", selection: $answer_House_10){
                                                    ForEach(HouseInspirationModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 11:
                                                Picker("답변 선택", selection: $answer_House_12){
                                                    ForEach(HouseReferenceModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
                        
                        
                        else if type == .TREE{
                            Group{
                                ForEach(questions_Tree.indices, id:\.self){index in
                                    HStack{
                                        Text(questions_Tree[index].question)
                                            .isHidden(index == 6 && answer_Tree_Yes_No[5]!)
                                        
                                        Spacer()
                                        
                                        if questions_Tree[index].isYesNoQuestion{
                                            CheckBox(checked: self.binding_Yes_No(for: index), title: "예")
                                        } else{
                                            switch index{
                                            case 2:
                                                Picker("답변 선택", selection: $answer_Tree_3){
                                                    ForEach(HouseWeatherModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 4:
                                                Stepper(value: $answer_Tree_5, in: 1...100, label: {
                                                    Text("\(answer_Tree_5)년")
                                                        .foregroundStyle(Color.accent)
                                                })
                                                
                                            case 6:
                                                Stepper(value: $answer_Tree_7, in: 1...100, label: {
                                                    Text("\(answer_Tree_7)년 전")
                                                        .foregroundStyle(Color.accent)
                                                }).isHidden(answer_Tree_Yes_No[5]!)
                                                
                                            case 8:
                                                Picker("답변 선택", selection: $answer_Tree_9){
                                                    ForEach(HouseInspirationModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 9:
                                                Picker("답변 선택", selection: $answer_Tree_10){
                                                    ForEach(PersonGenderModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
                        
                        else if type == .PERSON_1 || type == .PERSON_2{
                            Group{
                                ForEach(questions_Person.indices, id:\.self){index in
                                    HStack{
                                        Text(questions_Person[index].question)
                                        
                                        Spacer()
                                        
                                        if questions_Person[index].isYesNoQuestion{
                                            CheckBox(checked: self.binding_Yes_No(for: index), title: "예")
                                        } else{
                                            switch index{
                                            case 0:
                                                Stepper(value: $answer_Person_1, in: 1...100, label: {
                                                    Text("\(answer_Person_1)살")
                                                        .foregroundStyle(Color.accent)
                                                })
                                                
                                            case 2:
                                                Stepper(value: $answer_Person_3, in: 1...100, label: {
                                                    Text("\(answer_Person_3)명")
                                                        .foregroundStyle(Color.accent)
                                                })
                                                
                                            case 3:
                                                Picker("답변 선택", selection: $answer_Person_4){
                                                    ForEach(HouseFamilyTypeModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 6:
                                                Picker("답변 선택", selection: $answer_Person_7){
                                                    ForEach(HouseFamilyTypeModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 7:
                                                Picker("답변 선택", selection: $answer_Person_8){
                                                    ForEach(HouseFamilyTypeModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 13:
                                                Picker("답변 선택", selection: $answer_Person_14){
                                                    ForEach(HouseReferenceModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            case 14:
                                                Picker("답변 선택", selection: $answer_Person_15){
                                                    ForEach(HouseReferenceModel.allCases){option in
                                                        Text(String(describing: option))
                                                    }
                                                }.pickerStyle(MenuPickerStyle())
                                                
                                            default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
                        
                    }.padding(20)
                }
            }.navigationTitle(Text("필수 문답"))
                .toolbar{
                    ToolbarItemGroup(placement: .topBarLeading, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                        }
                    })
                    
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                        Button(action:{
                            showProgress = true
                            
                            switch type{
                            case .HOUSE:
                                self.answer_House = HouseEssentialQuestionAnswerModel(
                                    ANSWER_01: answer_House_Yes_No[0],
                                    ANSWER_02: answer_House_Yes_No[1],
                                    ANSWER_03: answer_House_3,
                                    ANSWER_04: answer_House_Yes_No[3],
                                    ANSWER_05: answer_House_5,
                                    ANSWER_06: answer_House_6,
                                    ANSWER_07: answer_House_7,
                                    ANSWER_08: answer_House_8,
                                    ANSWER_09: answer_House_9,
                                    ANSWER_10: answer_House_10,
                                    ANSWER_11: answer_House_Yes_No[10],
                                    ANSWER_12: answer_House_12,
                                    ANSWER_13: answer_House_Yes_No[12],
                                    ANSWER_14: answer_House_Yes_No[13]
                                )
                                
                            case .TREE:
                                self.answer_Tree = TreeEssentialQuestionAnswerModel(
                                    ANSWER_01: answer_Tree_Yes_No[0],
                                    ANSWER_02: answer_Tree_Yes_No[1],
                                    ANSWER_03: answer_Tree_3,
                                    ANSWER_04: answer_Tree_Yes_No[3],
                                    ANSWER_05: answer_Tree_5,
                                    ANSWER_06: answer_Tree_Yes_No[5],
                                    ANSWER_07: answer_Tree_7,
                                    ANSWER_08: answer_Tree_Yes_No[7],
                                    ANSWER_09: answer_Tree_9,
                                    ANSWER_10: answer_Tree_10,
                                    ANSWER_11: answer_Tree_Yes_No[10],
                                    ANSWER_12: answer_Tree_Yes_No[11],
                                    ANSWER_13: answer_Tree_Yes_No[12],
                                    ANSWER_14: answer_Tree_Yes_No[13]
                                )
                                
                            case .PERSON_1:
                                self.answer_Person_First = PersonEssentialQuestionAnswerModel(
                                    ANSWER_01: answer_Person_1,
                                    ANSWER_02: answer_Person_Yes_No[1],
                                    ANSWER_03: answer_Person_3,
                                    ANSWER_04: answer_Person_4,
                                    ANSWER_05: answer_Person_Yes_No[4],
                                    ANSWER_06: answer_Person_Yes_No[5],
                                    ANSWER_07: answer_Person_7,
                                    ANSWER_08: answer_Person_8,
                                    ANSWER_09: answer_Person_Yes_No[8],
                                    ANSWER_10: answer_Person_Yes_No[9],
                                    ANSWER_11: answer_Person_Yes_No[10],
                                    ANSWER_12: answer_Person_Yes_No[11],
                                    ANSWER_13: answer_Person_Yes_No[12],
                                    ANSWER_14: answer_Person_14,
                                    ANSWER_15: answer_Person_15
                                )
                                
                            case .PERSON_2:
                                self.answer_Person_Second = PersonEssentialQuestionAnswerModel(
                                    ANSWER_01: answer_Person_1,
                                    ANSWER_02: answer_Person_Yes_No[1],
                                    ANSWER_03: answer_Person_3,
                                    ANSWER_04: answer_Person_4,
                                    ANSWER_05: answer_Person_Yes_No[4],
                                    ANSWER_06: answer_Person_Yes_No[5],
                                    ANSWER_07: answer_Person_7,
                                    ANSWER_08: answer_Person_8,
                                    ANSWER_09: answer_Person_Yes_No[8],
                                    ANSWER_10: answer_Person_Yes_No[9],
                                    ANSWER_11: answer_Person_Yes_No[10],
                                    ANSWER_12: answer_Person_Yes_No[11],
                                    ANSWER_13: answer_Person_Yes_No[12],
                                    ANSWER_14: answer_Person_14,
                                    ANSWER_15: answer_Person_15
                                )
                            }
                            
                            showProgress = false
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }){
                            if !showProgress{
                                Text("완료")
                            } else{
                                ProgressView()
                            }
                        }
                    })
                }
                .animation(.easeInOut)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    InspectionEssentialQuestionView(type: .PERSON_1, answer_House: .constant(HouseEssentialQuestionAnswerModel()), answer_Tree: .constant(TreeEssentialQuestionAnswerModel()), answer_Person_First: .constant(PersonEssentialQuestionAnswerModel()), answer_Person_Second: .constant(PersonEssentialQuestionAnswerModel()), img: nil)
}
