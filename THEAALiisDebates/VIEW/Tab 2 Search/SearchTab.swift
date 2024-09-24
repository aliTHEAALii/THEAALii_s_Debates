//
//  SearchTab.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/5/24.
//

import SwiftUI
import Firebase
//import FirebaseFirestoreSwift


//struct SearchTab: View {
//    
//    @State private var searchedTIs: [TI] = []
//    @State private var searchedUsers: [UserModel] = []
//    @State private var searchText = ""
//    @State private var searchUsers = false
//    
//    //Pagination Properties
//    @State private var lastDocument: DocumentSnapshot? = nil
//    @State private var isFetching = false
//    let pageSize = 5 // Number of documents per page
//    
//    var body: some View {
//        
//        NavigationView {
//            
//            VStack(spacing: 0) {
//                
//                PickSearchTypeBar(searchUsers: $searchUsers)
////                    .navigationTitle("Search TIs")
//                    .searchable(text: $searchText, prompt: "Search THEAALii's Interactions by title")
//                    .onChange(of: searchText) { _, newValue in
//                        if searchUsers == false {
//                            TIManager.shared.searchTIs(query: searchText.lowercased()) { tis,<#arg#>  in
//                                searchedTIs = tis
//                            }
//                        } else if searchUsers == true {
//                            UserManager.shared.searchUsers(query: searchText) { users in
//                                searchedUsers = users
//                            }
//                        }
//                    }
//                
//                if searchUsers == false {
//                    List(searchedTIs) { ti in
//                        
//                        SearchTiCell(ti: ti)
//                        //.listRowSeparator(.hidden) // Hide separators between rows
//                        //.padding(.vertical, 0) // Remove vertical padding
//                    }
//                    .listStyle(PlainListStyle())
//                    .navigationTitle("Search TIs")
//                    .searchable(text: $searchText, prompt: "Search THEAALii's Interactions by title")
//                    .onChange(of: searchText) { _, newValue in
//                        if searchUsers == false {
//                            TIManager.shared.searchTIs(query: searchText.lowercased()) { tis in
//                                searchedTIs = tis
//                            }
//                        } else if searchUsers == true {
//                            UserManager.shared.searchUsers(query: searchText) { users in
//                                searchedUsers = users
//                            }
//                        }
//                    }
//                    
//                    //MARK: - Search Users
//                } else if searchUsers == true {
//                    
//                    List(searchedUsers, id: \.userUID ) { user in
//                        HStack {
//                            UserButton(user: user, horizontalName: true)
//                        }
//                        .frame(width: width, alignment: .trailing)
////                        SearchTiCell(ti: ti)
//                        //                    .listRowSeparator(.hidden) // Hide separators between rows
//                        //                    .padding(.vertical, 0) // Remove vertical padding
//                    }
//                    .listStyle(PlainListStyle())
//                    .navigationTitle("Search Users")
//                    .onAppear {
//                        UserManager.shared.searchUsers(query: searchText) { users in
//                            searchedUsers = users
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            TIManager.shared.searchTIs(query: searchText.lowercased()) { tis in
//                searchedTIs = tis
//            }
//        }
//    }
//}

//MARK: - from chat GPT
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SearchTab: View {
    
    @State private var searchedTIs: [TI] = []
    @State private var searchedUsers: [UserModel] = []
    @State private var searchText = ""
    @State private var searchForUsers = false
    
    // Pagination Properties
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var isFetching = false
    let pageSize = 5 // Number of documents per page
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                PickSearchTypeBar(searchUsers: $searchForUsers)
                    .searchable(text: $searchText, prompt: searchForUsers ? "Search Users": "Search THEAALii's Interactions by title")
                    .onChange(of: searchText) { _, newValue in
                        if searchForUsers == false {
                            resetSearch()
                            fetchTIs()
                        } else if searchForUsers == true {
                            UserManager.shared.searchUsers(query: searchText) { users in
                                searchedUsers = users
                            }
                        }
                    }
                
                //Search For TIs
                if searchForUsers == false {
                    List {
                        ForEach(searchedTIs) { ti in
                            SearchTiCell(ti: ti)
                                .onAppear {
                                    if ti == searchedTIs.last {
                                        fetchTIs()
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Search TIs")
                    
                    //Search for users
                } else if searchForUsers == true {
                    
                    List(searchedUsers, id: \.userUID) { user in
                        HStack {
                            UserButton(user: user, horizontalName: true)
                        }
                        .frame(width: width, alignment: .trailing)
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Search Users")
                }
            }
        }
        .onAppear {
            if !searchText.isEmpty && searchForUsers == false {
                resetSearch()
                fetchTIs()
            }
        }
    }
    
    // Function to fetch TIs with pagination
    private func fetchTIs() {
        guard !isFetching else { return }
        isFetching = true
        
        TIManager.shared.searchTIs(query: searchText.lowercased(), lastDocument: lastDocument, pageSize: pageSize) { tis, lastDoc in
            searchedTIs.append(contentsOf: tis)
            lastDocument = lastDoc
            isFetching = false
        }
    }
    
    // Function to reset search results and pagination
    private func resetSearch() {
        searchedTIs.removeAll()
        lastDocument = nil
        isFetching = false
    }
}


#Preview {
    SearchTab()
}

//MARK: - Pick Search Type Bar
struct PickSearchTypeBar: View {
    
    @Binding var searchUsers: Bool
    var body: some View {
        
        HStack(spacing: 0) {
            
            Button {
                searchUsers = false
            } label: {
                ZStack {
                    if searchUsers == false {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.secondary)
                    }
                    Text("Search TIs")
                        .font(.title2)
                }
                .frame(width: width * 0.4, height: width * 0.1)
            }
            
            Spacer()

            Button {
                searchUsers = true
            } label: {
                ZStack {
                    if searchUsers == true {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.secondary)
                    }
                    Text("Search Users")
                        .font(.title2)
                }
                .frame(width: width * 0.4, height: width * 0.1)
            }

        }
        .foregroundColor(.primary)
        .frame(width: width * 0.85)
        .padding(.vertical)
    }
}


//MARK: - Search Ti Cell
struct SearchTiCell: View {
    
    let ti: TI
    @State private var showTi = false
    
    var body: some View {
        
        Button {
            showTi = true
        } label: {
            
            HStack {
                
                Text(ti.title)
                    .frame(width: width * 0.54, alignment: .leading)
                
                
                VStack(spacing: 0) {
                    ImageView(imageUrlString: ti.thumbnailURL,scale: 0.3)
                    //                D2IconBarNew(ti: ti, scale: 0.3)
                    
                    if ti.tiType == .d2 {
                        HStack {
                            UserButton(userUID: ti.lsUserUID, scale: 0.3)
                            
                            Spacer()
                            
                            Text("\(ti.leftSideChain?.count ?? 0)")
                                .font(.system(size: width * 0.03))
                            
                            Spacer()
                            
                            TiCircleIcon(scale: 0.3)
                            
                            Spacer()
                            
                            Text("\(ti.rightSideChain.count)")
                                .font(.system(size: width * 0.03))
                            
                            Spacer()
                            
                            UserButton(userUID: ti.rsUserUID, scale: 0.3)
                            
                        }
                        .frame(width: width * 0.3, height: width * 0.05)
                        
                    } else if ti.tiType == .d1 {
                        
                        SearchTabD1BottomBar(tiChainCount: ti.rightSideChain.count)
                    }
                }
            }
            .frame(width: width * 0.85, alignment: .leading)
//            .background(Color.gray.opacity(0.2))
        }
        .fullScreenCover(isPresented: $showTi) {
            TiView(ti: ti, showTiView: $showTi)
        }
    }
}


//MARK: - Search Tab D1 Bottom Bar
struct SearchTabD1BottomBar: View {
    
    var ti: TI? = nil
    let tiChainCount: Int
    var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack (alignment: .top) {
            
            // 1.
            ZStack {
                //Border
                TiMapRectangleShape(cornerRadius: 2)
                    .stroke(lineWidth: 1 )
                    .foregroundStyle(.primary)

                //Mini-Circles
                HStack(spacing: 3 * scale) {
                    ForEach(0 ..< (tiChainCount < 5 ? tiChainCount : 5), id: \.self) { i in
                            Image(systemName: "circle.fill")
                                .font(.system(size: width * 0.01 * scale))
                    }
                }
            }
            .frame(width: width * 0.15, height: width * 0.04)


            // 2. Number & User
            HStack(spacing: 0) {
                
                //Number
                Text("\(tiChainCount)")
                    .font(.system(size: width * 0.03))
                
                Spacer()
                
                //User
                UserButton(userUID: ti?.rsUserUID, scale: 0.3, horizontalWidth: 0.0)
                
            }
            .frame(width: width * 0.3)
        }
    }
}
