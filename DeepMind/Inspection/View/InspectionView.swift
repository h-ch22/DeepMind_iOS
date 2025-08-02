//
//  InspectionView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct InspectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showDrawingView = false

    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName : "applepencil.and.scribble")
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer().frame(width : 10)
                        
                        VStack{
                            HStack{
                                Text("딥러닝 기반 HTP 검사 진행")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            HStack{
                                Text("딥러닝 모델을 기반으로 HTP 검사를 진행하며, 검사 결과를 바로 확인할 수 있습니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "chart.line.uptrend.xyaxis")
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer().frame(width : 10)
                        
                        VStack{
                            HStack{
                                Text("검사 추이")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            HStack{
                                Text("검사를 진행하면 홈 탭에서 마지막 검사 결과와 통계 탭에서 세부 검사 결과를 확인할 수 있습니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "exclamationmark.circle.fill")
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer().frame(width : 10)
                        
                        VStack{
                            HStack{
                                Text("주의사항")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            HStack{
                                Text("DeepMind는 심리 검사 결과에 대한 정확성을 보증하지 않습니다. 사용자는 DeepMind를 통해 치료상의 이익 및/또는 의학적인 이익을 얻을 수 없으며, 정신.심리 상태에 문제가 있다고 의심되는 경우 의료기관에서 전문의와 상담을 통해 의학적 조치를 받으십시오.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showDrawingView = true
                    }){
                        HStack{
                            Text("다음 단계로")
                                .foregroundColor(.white)
                            
                            Image(systemName : "chevron.right")
                                .foregroundColor(.white)
                        }.padding([.vertical], 20)
                            .padding([.horizontal], 80)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.accent).shadow(radius: 5))
                    }
                    
                }.padding(20).navigationTitle(Text("HTP 검사 시작하기"))
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }){
                                Image(systemName: "xmark")
                            }
                        })
                    })
                    .fullScreenCover(isPresented: $showDrawingView, content: {
                        DrawingView()
                    })
            }
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}

#Preview {
    InspectionView()
}
