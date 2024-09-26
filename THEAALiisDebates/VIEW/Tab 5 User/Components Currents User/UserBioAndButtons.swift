//
//  UserBioAndButtons.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/19/23.
//

import SwiftUI

struct UserBioAndButtons: View {
    
    @Binding var currentUser: UserModel?
    @Binding var userName: String
    @State var bio: String
    @Binding var imageUrlString: String?
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            DescriptionSV(descriptionTitle: "User's Bio", text: bio)

            VStack(spacing: 0) {
                
                //Edit
                EditUserInfoButton(currentUser: $currentUser, userName: $userName, bio: $bio, imageUrlString: $imageUrlString)

//                Rectangle()
//                    .frame(width: width * 0.15, height: width * 0.3)
//                    .foregroundStyle(.clear)
            }
        }
        .frame(width: width, height: width * 0.45)
        .preferredColorScheme(.dark)
    }
}

struct UserBioAndButtons_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()

//        UserBioAndButtons()
//            .previewLayout(.sizeThatFits)
    }
}
