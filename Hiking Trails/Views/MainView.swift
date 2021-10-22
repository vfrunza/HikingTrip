//
//  MainView.swift
//  Custom_Side_Menu (iOS)
//
//  Created by Balaji on 03/04/21.
//

import SwiftUI
import Auth0

struct MainView: View {
    // selected Tab...
    @State var selectedTab = "Home"
    @State var showMenu = false
    
    @ObservedObject var userAuth: UserAuth = UserAuth()


    @ViewBuilder              
    var body: some View {
        if !userAuth.isLoggedin {
            LoginView().environmentObject(userAuth)
        }
        else {
        ZStack{
            
            Color("green")
                .ignoresSafeArea()
            
            // Side Menu...
            ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: false, content: {
                
                SideMenu(selectedTab: $selectedTab)
            })

            ZStack{
                
                // two background Cards...
                
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    // Shadow...
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical,30)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    // Shadow...
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical,60)
                
                Home(selectedTab: $selectedTab)
                    .cornerRadius(showMenu ? 15 : 0)
                    .disabled(showMenu ? true : false)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring()){
                            showMenu.toggle()
                        }
                        print("Tapping the main view...")
                    }
            }
            // Scaling And Moving The View...
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ? getRect().width - 120 : 0)
            .ignoresSafeArea()
            .overlay(
            
                // Menu Button...
                Button(action: {
                    withAnimation(.spring()){
                        showMenu.toggle()
                    }
                }, label: {
                    
                    // Animted Drawer Button..
                    VStack(spacing: 5){
                        
                        Capsule()
                            .fill(showMenu ? Color.white : Color.primary)
                            .frame(width: 30, height: 3)
                        // Rotating...
                            .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                            .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)

                        VStack(spacing: 5){
                            
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                            // Moving Up when clicked...
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                                .offset(y: showMenu ? -8 : 0)
                        }
                        .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                    }
                    .contentShape(Rectangle())
                })
                .padding()
                
                ,alignment: .topLeading
            )
        }}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

// Extending View To get Screen Size...
extension View{
    
    func getRect()->CGRect{
        
        return UIScreen.main.bounds
    }
}


class UserAuth: ObservableObject {
    @Published var isLoggedin = false     // published property to update view
    @Published var credential: Auth0.Credentials?
    

    func login(credential: Credentials) {
        // login request... on success:
        self.credential = credential
        self.isLoggedin = true
    }

    func logout() {
        // login request... on success:
        self.isLoggedin = false
    }
}
