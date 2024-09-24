//
//  UserViewTabsBar.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/22/23.
//

import SwiftUI

struct UserViewTabsBar: View {
    var body: some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                ZStack {
                    Text("POSTS")
                        .font(.system(size: width * 0.045, weight: .regular))
                        .foregroundColor(.primary)
                    
//                    RoundedRectangle(cornerRadius: 15)
//                        .frame(width: width * 0.17, height: width * 0.01)
//                        .padding(.top, width * 0.1)
                }
                .frame(width: width * 0.33, height: width * 0.15)
                .foregroundColor(.primary)
            }
            
//            FutureFeatureButton()
//                .frame(width: width * 0.33)
//            
//            FutureFeatureButton()
//                .frame(width: width * 0.33)
        }
        .frame(height: width * 0.15)
    }
}

struct UserViewTabsBar_Previews: PreviewProvider {
    static var previews: some View {
        
        UserTabView()
        
        UserViewTabsBar()
            .preferredColorScheme(.dark)
    }
}
