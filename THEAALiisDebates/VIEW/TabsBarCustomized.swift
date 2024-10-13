//
//  TabsBarCustomized.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 1/9/23.
//

import SwiftUI

struct TabsBarCustomized: View {
    
    @StateObject private var vmTIT = TITViewModel()
    @AppStorage("tit_id") var TITid : String = "10A47E3F-5659-40C9-B14F-A0428390BDFA"
    //get Current User
    @AppStorage("current_user_uid"  ) private var currentUserId: String = ""
    @State private var currentUser: UserModel? = nil
    
    let icons = ["triangle", "magnifyingglass", "plus", "line.3.horizontal", "person"]
    
    @State private var selectedIndex = 0
    
//    @State var presentedAddDebateView = false
//    @EnvironmentObject var TIT: TITModel
    @State var showDebateView = false
    @State var isMiniPlayer = false

    
    var body: some View {
        
        VStack(spacing: 0){
            
            //MARK: Views for each tab
            ZStack(alignment: .bottom) {
                
                switch selectedIndex {
                case 0 :
//                    FeedTabView(showTITView: $showDebateView)
//                    FeedTab()
                    Text("feed old")
                    
                case 1 :
//                    TITView(showDebateView: $showDebateView, isMiniPlayer: $isMiniPlayer)
                    VStack {
                        Spacer()
                        Text("search")
                        Spacer()
                    }
                    
                    ///case 2 :
                    
                case 3 :
                    LibraryTabView()
                    
                case 4 :
                    UserTabView()
                    
                default :
//                    FeedTabView()
                    Text("Default View")
                }
                
                //MARK: - Debate View (& mini Player)
//                if showDebateView {
                if showDebateView {
                    TITView( showDebateView: $showDebateView, isMiniPlayer: $isMiniPlayer)
                }
            }
            
            
            Divider()
            
            //MARK: Tabs Bar
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    
                    Spacer()
                    
                    Button {
                        selectedIndex = index
                    } label: {
                        
                        if index == 4 {
                            
                            PersonTITIconSV(color: (selectedIndex == 4 ? .ADColors.green : .secondary))
                            
                        } else if index == 2 {
                            CreateDebateButton(selectedTabIndex: $selectedIndex)
                        } else {
                            //Buttons(home[0], saved[3], user[4])
                            Image(systemName: icons[index])
                                .font(.system(size: width * 0.075, weight: .thin))
                                .frame(width: width * 0.1)
                                .foregroundColor(selectedIndex == index ? .ADColors.green : .secondary)
                            
                        }
                    }
                    
                    Spacer()
                    
                }//ForEach
            }//HStack
            .background(.black)
//            .padding(.top, 5)
            .padding(.top, width * 0.04)
            
        }//VStack
        .preferredColorScheme(.dark)
        .onAppear { Task { try await fetchCurrentUser(currentUserId: currentUserId) }  }
//        .task { try fetchCurrentUser(currentUserId: currentUserId) }
        //MARK: Full Screen Cover
//        .fullScreenCover(isPresented: $presentedAddDebateView) {
//            DebateView(showDebateView: $showDebateView, isMiniPlayer: $isMiniPlayer) //FIXME: kk
//        }
    }
    
    private func fetchCurrentUser(currentUserId: String) async throws {
        currentUser = try await UserManager.shared.getUser(userId: currentUserId)
    }
}

//struct TabsBarCustomized_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsBarCustomized()
//    }
//}
//#Preview {
//    TabsBarCustomized(showDebateView: false)
//}
