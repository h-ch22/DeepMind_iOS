//
//  PDFViewer.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/14/23.
//

import Foundation
import PDFKit
import SwiftUI

struct PDFViewController: UIViewRepresentable{
    typealias UIViewType = PDFView
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: url)
    }
}

struct PDFViewer: View{
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    
    var body: some View{
        NavigationView{
            VStack{
                PDFViewController(url: url)
            }.navigationTitle(Text("PDF 뷰어"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItemGroup(placement: .topBarLeading, content: {
                        Button("닫기"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
