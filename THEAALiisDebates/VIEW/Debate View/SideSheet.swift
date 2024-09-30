//
//  SideSheet.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 3/2/23.
//

import SwiftUI

struct SideSheet: View {
    
    @State var showSideSheet: Bool = false
    
    var body: some View {
        
        ZStack() {
            
            
            // - Expand Button
            Button {
                withAnimation(.spring()){
                    showSideSheet.toggle()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .frame(width: width * 0.15, height: width * 0.15)
                
            }
            .offset(x: width * 0.427, y: width * 0.151)
            
            ZStack {
                
                // - Black Background
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: width * 0.35, height: width * 0.45, alignment: .leading)
                
                // - Border
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 0.2)
                    .foregroundColor(.primary)
                    .frame(width: width * 0.35, height: width * 0.45, alignment: .leading)
                
                
                HStack(spacing: 0) {
                    
                    //MARK: - Left Column
                    VStack(spacing: 0) {
                        
                        // -LC top B
                        Button {
                            
                        } label: {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.15)
                            //                            FutureFeatureButton()
                        }
                        
                        // - LC middle B
                        Button {
                            
                        } label: {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.15)
                        }
                        
                        // -LC bottom B
                        Button {
                            
                        } label: {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.15)
                        }
                        
                    }
                    .frame(width: width * 0.15, height: width * 0.15)
                    .foregroundStyle(.gray)
                    
                    //MARK: - Right Column
                    VStack(spacing: 0) {
                        
                        // -RC top B
                        Button {
                            
                        } label: {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.15)
                        }
                        
                        // -RC middle B
                        Button {
                            
                        } label: {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.15)
                            
                        }
                        
                        // -RC bottom B
                        Button {
                            withAnimation(.spring()) {
                                showSideSheet.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .fontWeight(.thin)
                                .frame(width: width * 0.15, height: width * 0.15)
                        }
                        
                    }
                    .frame(width: width * 0.15, height: width * 0.15)
                    .foregroundStyle(.gray)
                    
                }
                .foregroundColor(.primary)
                .frame(width: width * 0.35, height: width * 0.45, alignment: .leading)
            }
            .offset(x: showSideSheet ? width * 0.375 : width * 0.68)
            
        }//outer z stack
        .frame(width: width, height: width * 0.45)
    }
}

//struct SideSheet_Previews: PreviewProvider {
//    static var previews: some View {
//
//        TITView(TIT: TestingComponents().testingTIT, showDebateView: .constant(true), isMiniPlayer : .constant(false))
//
//        SideSheet()
//            .preferredColorScheme(.dark)
//    }
//}


//MARK: - Preview
#Preview {
    TiView(ti: TestingModels().testTI0, showTiView: .constant(true))
}
