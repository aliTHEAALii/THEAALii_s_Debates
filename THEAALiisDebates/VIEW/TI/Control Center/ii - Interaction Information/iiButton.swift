//
//  iiButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/19/24.
//

import SwiftUI

struct iiButton: View {
    
//    @Binding var currentUser : UserModel?
    @Environment(CurrentUser.self) var currentUser
    @Binding var ti : TI?
    
    @State private var iiShowFSC = false
    
    var body: some View {
        
        Button {
            iiShowFSC.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.secondary)
                    .frame(width: width * 0.2, height: width * 0.17)
                
                HStack(spacing: width * 0.01) {
                    VStack(spacing: width * 0.02) {
                        Image(systemName: "circle")
                            .font(.system(size: width * 0.04, weight: .regular))
                        Rectangle().fill(Color.primary).frame(width: 2, height: 20, alignment: .center)
                    }
                    VStack(spacing: width * 0.02) {
                        Image(systemName: "circle")
                            .font(.system(size: width * 0.04, weight: .regular))
                        Rectangle().fill(Color.primary).frame(width: 2, height: 20, alignment: .center)
                    }
                }.foregroundColor(.primary)
            }
        }
        .frame(width: width * 0.3)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $iiShowFSC) {
            VStack(spacing: 0) {
                FSCHeaderSV(showFSC: $iiShowFSC, text: "Interaction Information")
                iiView(ti: $ti)
            }
        }
        

    }
    
    func iiButtonPressed() async {
        if ti == nil { return }
        Task {
            await getTi()
            iiShowFSC.toggle()
        }
    }
    
    func getTi() async {
        do {
            ti = try await TIManager.shared.fetchTI(tiID: ti!.id)
        } catch { print("❌ Couldn't fetch Ti: \(error.localizedDescription) ❌") }
    }
}
//#Preview {
//    iiButton(ti: .constant(TestingModels().testTI0), currentUser: .constant(TestingModels().user1))
//}
