HStack(spacing: 0) {
                    //Left Team
                    VStack {
                        
                        if (ti!.lsLevel1UsersUIDs ?? []).isEmpty {
                            Text("No Left Team")
                                .foregroundStyle(.gray)
                            
                        } else {
                            
                            Text("Left Team")
                            
                            ForEach((ti!.lsLevel1UsersUIDs ?? []).indices, id: \.self) { i in
                                UserButton(userUID: ti!.lsLevel1UsersUIDs?[i], leftOrRightName: .right, scale: 0.8)
                            }
                        }
                    }
                    .frame(width: width * 0.5)
                    
                    //Divider()
                    
                    //Right Team
                    VStack {
                        
                        if (ti!.rsLevel1UsersUIDs ?? []).isEmpty {
                            Text("No Right Team")
                                .foregroundStyle(.gray)
                        } else {
                            
                            Text("Right Team")
                            
                            ForEach((ti!.rsLevel1UsersUIDs ?? []).indices, id: \.self) { i in
                                UserButton(userUID: ti!.rsLevel1UsersUIDs?[i], leftOrRightName: .left, scale: 0.8)
                            }
                        }
                    }
                    .frame(width: width * 0.5)
                }
                .frame(height: width * 0.25, alignment: .top)