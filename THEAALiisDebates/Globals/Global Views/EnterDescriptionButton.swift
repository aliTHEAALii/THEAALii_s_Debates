//
//  EnterDescriptionButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/18/24.
//

import SwiftUI

//MARK: - Enter Description Button
struct EnterDescriptionButton: View {
    
    @Binding var description: String
    var buttonTitle: String = "Enter Video Description"
    var buttonColor: Color = .secondary

    @State private var showSheet: Bool = false
    
    var body: some View {
        
        Button {
            showSheet.toggle()
        } label: {
            
            Text(buttonTitle)
                .font(.title2)
                
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(lineWidth: 0.5)
                    .foregroundColor(buttonColor)
                    .frame(width: width * 0.12, height: width * 0.12)
                
                Image(systemName: "text.alignleft")
                    .font(.system(size: width * 0.07, weight: .light))
                    .foregroundColor(.primary)
                
            }
            .frame(width: width * 0.15, height: width * 0.15)
        }
        .foregroundColor(.secondary)
        .sheet(isPresented: $showSheet) {
            
            // - FSC Title
            VStack {
                Text(buttonTitle)
                    .font(.title)
                    .foregroundColor(.ADColors.green)
                    .frame(width: width, height: width * 0.15, alignment: .center)
                    .padding(.top, width * 0.1)

                
//                ScrollView {
                    
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: width, height: width * 0.15)
                    
                    ZStack {
                        
                        //FIXME: - BIO from database
                        if description == "" {
                            Text("Enter Post Description")
                                .foregroundColor(.secondary.opacity(0.5))
                                .frame(width: width * 0.85, height: width * 1.3, alignment: .top)
                        }
                        
                        TextEditor(text: $description)
                            .multilineTextAlignment(.leading)
                            .scrollContentBackground(.hidden)
                            .frame(width: width * 0.85, height: width * 1.5, alignment: .top)
                            .submitLabel(.done)
                    }
//                }//.padding(.top, width * 0.1)
            }
            .background(Color.black)
            .preferredColorScheme(.dark)
        }
    }
}


#Preview {
    EnterDescriptionButton(description: .constant("meaw desc"), buttonTitle: "Title of button")
}
