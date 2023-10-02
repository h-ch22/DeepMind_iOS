//
//  ConsultingHospitalSelectionView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import SwiftUI

struct loadHospitalSelectionView: UIViewControllerRepresentable{
    typealias UIViewControllerType = ConsultingHospitalSelectionViewController
    
    var receiver: HospitalLocationReceiver
    var dragListener: HospitalSelectionMapDragListener
    
    func makeUIViewController(context: Context) -> ConsultingHospitalSelectionViewController {
        return ConsultingHospitalSelectionViewController(receiver: receiver, dragListener: dragListener)
    }
    
    func updateUIViewController(_ uiViewController: ConsultingHospitalSelectionViewController, context: Context) {
        
    }
}

struct ConsultingHospitalSelectionView: View {
    @ObservedObject var receiver = HospitalLocationReceiver()
    
    @StateObject var dragListener = HospitalSelectionMapDragListener()
    @StateObject var helper: ConsultingHelper
    @StateObject var userManagement: UserManagement
    
    @State private var showProgress = false
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                loadHospitalSelectionView(receiver: receiver, dragListener: dragListener)
                
                VStack{

                }.toolbar{
                    ToolbarItemGroup(placement: .topBarLeading, content: {
                        Button("닫기"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                    
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                        if showProgress{
                            ProgressView()
                        } else{
                            Button("완료"){
                                showProgress = true
                                helper.uploadHospitalInformation(uid: userManagement.userInfo?.UID ?? "", location: receiver.location, address: receiver.address){ result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else{
                                        showAlert = true
                                    }
                                    
                                    showProgress = false
                                }
                            }
                        }

                    })
                }
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                })
                .navigationTitle(Text("병원 정보 등록"))
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    receiver.address.removeAll()
                    receiver.location.removeAll()
                }
            }
        }
    }
}

#Preview {
    ConsultingHospitalSelectionView(helper: ConsultingHelper(), userManagement: UserManagement())
}
