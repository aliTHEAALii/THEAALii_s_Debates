//
//  LibraryTabView.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/21/23.
//

import SwiftUI

//MARK: - Library Tab View
struct LibraryTabView: View {
    
    ///@Binding showDebateView: Bool

    private enum TIsOrUsers { case tis, users }
    @State private var tiOrUser : TIsOrUsers = .tis
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("My Library")
                .font(.system(size: width * 0.08, weight: .light))
                .foregroundColor(.ADColors.green)
            
//            //Save Debates
//            HStack(spacing: 0) {
//
//                Text("Saved TIs")
//                    .font(.title2)
//
//                Spacer()
//
//                EditLibraryButton()
//
//            }
//            .frame(width: width * 0.85)
//            .padding(.vertical)
            //MARK: Save Debates
            HStack(spacing: 0) {
                
                Button {
                    tiOrUser = .tis
                } label: {
                    ZStack {
                        if tiOrUser == .tis {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.secondary)
                        }
                        Text("Saved TIs")
                            .font(.title2)
                    }
                    .frame(width: width * 0.4, height: width * 0.1)
                }
                
                Spacer()

                Button {
                    tiOrUser = .users
                } label: {
                    ZStack {
                        if tiOrUser == .users {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.secondary)
                        }
                        Text("Saved Users")
                            .font(.title2)
                    }
                    .frame(width: width * 0.4, height: width * 0.1)
                }

            }
            .foregroundColor(.primary)
            .frame(width: width * 0.85)
            .padding(.vertical)
            
            //MARK: Scroll
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(0..<10, id: \.self) { i in
                        
                        Button {
                            
                        } label: {
                            
                            //FIXME: - i == 100 (width)
                            
                            //0.07 + 0.4 + 0.53
                            SavedTICell(index: i, tiID:)
                        }
//                        .onTapGesture {
//                            withAnimation {
//                                visibleDebateView.toggle()
//                            }
//                        }
                        
                        Divider()
                    }
                }
                
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: width * 0.2)
            }
        }
    }
}

struct LibraryTabView_Previews: PreviewProvider {
    static var previews: some View {
        
        LibraryTabView()
            .preferredColorScheme(.dark)
    }
}

//MARK: - Edit Library Button
struct EditLibraryButton: View {
    
    @State private var showEditing = false
    
    var body: some View {
        
        Button {
            showEditing.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(lineWidth: 1)
                    .frame(width: width * 0.1, height: width * 0.1)
                
                Text("Edit")
            }
            .frame(width: width * 0.15, height: width * 0.15)
            .foregroundColor(.primary)
        }
        .fullScreenCover(isPresented: $showEditing) {
            
            ZStack(alignment: .topTrailing) {
                
                EditSavedDebatesFSC()
                
                Button {
                    showEditing = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width * 0.1, height: width * 0.1)
                            .foregroundColor(.black)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(lineWidth: 0.7)
                            .frame(width: width * 0.1, height: width * 0.1)
                            .foregroundColor(.white)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: width * 0.075, weight: .thin))
                            .foregroundColor(.primary)
                    }
                    
                    .padding(.trailing)

                }

            }
        }

    }
}


//MARK: Saved TI Cell
struct SavedTICell: View {
    
    let index: Int
    let tiID: String?
    
    @State private var showTIFSC: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(index + 1).")
                .frame(width: width * 0.07)
            
            VStack(spacing: 5) {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: width * 0.4, height: width * 0.5625 * 0.4)

                MiniIndicatorsSV(tiChainCount: 3)
            }
            
            Text("Debate Title: let's try something ")
                .multilineTextAlignment(.leading)
                .padding(.leading, width * 0.02)
                .frame(width: width * 0.53, alignment: .leading)
        }
        .foregroundColor(.primary)
        .frame(height: width * 0.5625 * 0.45)
//        .fullScreenCover(isPresented: $show) {
//            TIView(ti: ti, showTIFSC: $showTIFSC)
//        }
//        .onAppear{ Task { try await fetchTI() } }
    }
    
    private func fetchTI() async throws {
//        TITManager.shared.getTIT(TITid: tiId)
    }
}


//MARK: - Mini Indicators SV
struct MiniIndicatorsSV: View {
    
    var ti: TI? = nil
    let tiChainCount: Int
    var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack (alignment: .top) {
            
            // 1.
            ZStack {
                //Border
                TiMapRectangleShape(cornerRadius: 2 * scale )
                    .stroke(lineWidth: 1 )
                    .foregroundStyle(.primary)
//                    .frame(width: width * 0.15, height: width * 0.03)

                //Mini-Circles
                HStack(spacing: 3 * scale) {
                    ForEach(0 ..< (tiChainCount < 5 ? tiChainCount : 5), id: \.self) { i in
                            Image(systemName: "circle.fill")
                                .font(.system(size: width * 0.01 * scale))
                    }
                }
//                .frame(width: width * 0.1, height: width * 0.04)
            }
            .frame(width: width * 0.15 * scale, height: width * 0.03 * scale)


            // 2. Number & User
            HStack(spacing: 0) {
                
                //Number
                Text("\(tiChainCount)")
                    .font(.system(size: width * 0.03 * scale))
                
                Spacer()
                
                //User
                UserButton(userUID: ti?.rsUserUID, scale: 0.3 * scale, horizontalWidth: 0.0)
                
            }
            .frame(width: width * 0.4)
        }
    }
}
