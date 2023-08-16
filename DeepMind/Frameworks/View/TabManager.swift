//
//  TabManager.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct TabManager: View {
    @State private var selectedIndex = 0
    @State private var showModal = false
    @StateObject var userManagement : UserManagement
    
    let icon = ["house.fill", "square.and.pencil", "applepencil.and.scribble", "chart.xyaxis.line", "ellipsis.circle.fill"]
    
    func changeView(index: Int){
        self.selectedIndex = index
    }
    
    func showInspectionSheet(){
        self.showModal = true
    }
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    switch selectedIndex{
                    case 0:
                        HomeView(userManagement: userManagement, parent: self).navigationTitle(Text("홈"))
                        
                    case 1:
                        DiaryView().navigationTitle(Text("하루 일기"))
                    case 3:
                        StatisticsView().navigationTitle(Text("통계"))

                    case 4:
                        MoreView(helper: userManagement)
                    default:
                        HomeView(userManagement: userManagement, parent: self).navigationTitle(Text("홈"))

                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack{
                    ForEach(0..<5, id:\.self){number in
                        Spacer()
                        
                        Button(action: {
                            if number == 2{
                                self.showModal = true
                            }
                            
                            else{
                                selectedIndex = number
                            }
                        }){
                            if number == 2{
                                Image(systemName: icon[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(.white)
                                    .frame(width : 60, height : 60)
                                    .background(Color.accent)
                                    .cornerRadius(30)
                                    .shadow(radius: 3)
                            }
                            
                            else{
                                Image(systemName: icon[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(selectedIndex == number ? .accent : .gray)
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
            }
            
            .sheet(isPresented: $showModal, content: {
                InspectionView()

            })
            
            .onAppear(perform: {

            })
            
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            .accentColor(.accent)
        }.animation(.easeInOut, value: 1.0)
        .navigationBarHidden(true)
    }
}

#Preview {
    TabManager(userManagement: UserManagement())
}
