//
//  LoginView.swift
//  Hiking Trails
//
//  Created by Victor Frunza on 2021-10-21.
//

import SwiftUI
import Auth0

struct LoginView: View {
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack() {
            Button("Sign In") {
            Auth0
                .webAuth()
                .audience("https://dev-vfrunza.us.auth0.com/userinfo")
                .start { result in
                    switch result {
                    case .success(let credentials):
                        userAuth.login(credential: credentials)
                        print("Obtained credentials")
                    case .failure(let error):
                        print("Failed with \(error)")
                    }
                }
            }
        }
    }
}
