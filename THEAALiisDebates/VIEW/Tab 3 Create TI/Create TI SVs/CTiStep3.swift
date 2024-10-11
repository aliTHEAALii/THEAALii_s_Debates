//
//  CTiStep3.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/25/24.
//

import SwiftUI

struct CTiStep3: View {
    
    let currentUser: UserModel?
    @Binding var tiAdminsUIDs: [String]
    
    @Binding var tiInteractionType: TIType
    @Binding var tiDescription: String
    
    @Binding var verticalListAccess: VerticalListAccess
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("TI Admins")
                .foregroundStyle(.white)
                .padding()
            
            
            EditTIAdminsSV(currentUser: currentUser, tiAdminsUIDs: $tiAdminsUIDs)
            
            
            
            //MARK: - Vertical List Access
            ChooseVerticalListAccess(verticalListAccess: $verticalListAccess, tiInteractionType: $tiInteractionType)
                .padding(.vertical, width * 0.15)
            
            
            //Description
            EnterDescriptionButton(description: $tiDescription,
                                   buttonTitle: "Enter TI Intro Description")
        }
    }
}

#Preview {
    //    CTiStep3()
    
    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 2)
        .environment(CurrentUser().self)
    
}

struct ChooseVerticalListAccess: View {
    
    @Binding var verticalListAccess: VerticalListAccess
    @Binding var tiInteractionType: TIType
    @State private var showSheet: Bool = false
    
    var body: some View {
        
        HStack(spacing: width * 0.1) {
            
            Text("Vertical List Access")
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                showSheet.toggle()
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: width * 0.001)
                        .frame(width: width * 0.12, height: width * 0.12)
                    
                    Text(verticalListAccess == .open ? "Open" : "Closed")
                        .font(.system(size: width * 0.033))
                }
                .frame(width: width * 0.15, height: width * 0.15)
                .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $showSheet) {
            
            VStack(spacing: width * 0.1) {
                
                Text("Note: You can change this at any time")
                    .foregroundStyle(.white)
                    .padding(.vertical, width * 0.15)
                
                Button {
                    verticalListAccess = .open
                    showSheet = false
                } label: {
                    ZStack {
                        
                        if verticalListAccess == .open {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ADColors.green.opacity(0.2))
                                .frame(width: width * 0.95, height: width * 0.4)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 2)
                                .fill(Color.ADColors.green.opacity(0.2))
                                .frame(width: width * 0.95, height: width * 0.4)
                        }
                        
                        //Words
                        VStack(spacing: width * 0.04) {
                            Text("OPEN")
                                .padding(.bottom, width * 0.03)
                            
                            Text("[  Anyone  ]")
                            Text("Can upload to the Vertical List ")
                            
                        }
                        .foregroundStyle(.white)
                        
                    }
                    
                }
                
                
                
                Button {
                    verticalListAccess = .closed
                    showSheet = false
                } label: {
                    ZStack {
                        if verticalListAccess == .closed {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ADColors.green.opacity(0.2))
                                .frame(width: width * 0.95, height: width * 0.4)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 2)
                                .fill(Color.ADColors.green.opacity(0.2))
                                .frame(width: width * 0.95, height: width * 0.4)
                        }
                        
                        
                        VStack(spacing: width * 0.04) {
                            Text("CLOSED")
                                .padding(.bottom, width * 0.03)
                            
                            Text(closedAccessButtonText)
                            Text("Can upload to the Vertical List ")
                            
                        }
                        .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    var closedAccessButtonText: String {
        if tiInteractionType == .d1 {
            return "[ TI Creator & Admins  ]"
            
        } else { //TIType == .d2
            return "[  TI Creator  -  Admins  -  Teams  ]"
        }
        
    }
}
