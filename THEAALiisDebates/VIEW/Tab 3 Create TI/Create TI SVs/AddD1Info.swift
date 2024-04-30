////
////  AddD1Info.swift
////  THEAALiisDebates
////
////  Created by Ali Kadhum on 4/10/24.
////
//
//import SwiftUI
//
//struct AddD1Info: View {
//    
//    let currentUser: UserModel?
//    
//    let tiID: String
//    @Binding var tiInteractionType: TIType
//    
//    @Binding var tiThumbnailData: Data?
//    let thumbnailForTypeID: String
//
//    @Binding var tiTitle: String
//    enum Field {
//        case debateTitle, debateDescription, videoTitle, videoDescription
//    }
//    @FocusState private var focusField: Field?
//
//    @Binding var rightUser: UserModel?
//    
//    var body: some View {
//        
//        VStack(spacing: 10) {
//            ZStack(alignment: .bottom) {
//                
//                VStack(spacing: 0) {
//                    
//                    PickThumbnailButton(thumbnailFor: .TI, thumbnailForTypeID: tiID, imageData: $tiThumbnailData, buttonText: "TI \nThumbnail")
//                    
//                    Spacer()
//                }
//                
//                TIIconD1(scale: 0.8)
//
//                ZStack {
//                    if let profileImageURLString = currentUser?.profileImageURLString {
//                        
//                        AsyncImage(url: URL(string: profileImageURLString), scale: 0.5) { image in
//                            
//                            image
//                                .resizable()
//                                .clipShape( Circle() )
//                                .scaledToFit()
//                                .frame(width: width * 0.125)
//                            
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        //User with Nil image
//                    } else { PersonTITIconSV(scale: 1.3) }
//                }
//                .frame(width: width, height: width * 0.68, alignment: .bottomTrailing)
//            }
//            .frame(width: width, height: width * 0.68)
//            
//            
//            //MARK: TI Title
//            ZStack {
//                //Border
//                RoundedRectangle(cornerRadius: 8)
//                    .strokeBorder(lineWidth: 0.5)
//                    .foregroundColor(tiTitle != "" ? .primary : .red)
//                    .frame(width: width * 0.9, height: width * 0.2)
//                
//                if tiTitle == "" {
//                    Text("TI Title")
//                }
//                
//                TextField("", text: $tiTitle, axis: .vertical)
//                    .multilineTextAlignment(.center)
//                    .frame(width: width * 0.88, height: width * 0.2, alignment: .center)
//                    .submitLabel(.done)
//                    .focused($focusField, equals: .debateTitle)
//                    .onSubmit { focusField = .debateDescription }
//            }
//            .padding(.top, width * 0.01)
//            
//        }
//
//        
//    }
//}
//
//#Preview {
////    AddD1Info(tiID: "", tiInteractionType: .constant(.d1),
////              tiThumbnailData: .constant(nil),
////              thumbnailForTypeID: "",
////              leftUser: .constant(nil), rightUser: .constant(nil)
////    )
//    
//    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 1)
//}
