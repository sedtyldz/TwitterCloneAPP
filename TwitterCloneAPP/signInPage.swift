//
//  signInPage.swift
//  TwitterCloneAPP
//
//  Created by Emre Yıldırım on 8.10.2024.
//

import SwiftUI
import FirebaseAuth

struct signInPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var durum : Bool = false
    @State private var kayitli : Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 30) {
                Spacer()
                    .frame(height:100)
                // Başlık
                Text("Login to Your Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40)
                
                Spacer()
                    .frame(height:100)
                
                
                // E-posta Alanı
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                // Şifre Alanı
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
                // Butonlar Yanyana
                HStack(spacing: 20) {
                    // Kayıt Butonu
                    Button(action: {
                        self.durum = true
                        
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    
                    // Giriş Butonu
                    Button(action: {
                        var sonuc = checkValid(email: email, password: password)
                        if sonuc == "success"{
                            login(email: email, password: password)
                        }
                        else{
                            self.errorMessage = sonuc
                        }
                        
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }
                .padding(.top, 20)
                
                // Hata Mesajı Gösterimi
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            
            
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $kayitli) {
                mainPage()
            }
            .navigationDestination(isPresented: $durum) {
                SignUpPage()
            }
            .padding(.horizontal, 30)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    // functions
    
    
    func checkValid(email:String, password:String) -> String {
        if email.isEmpty {
            return "Lütfen email giriniz."
        }
        
        
        if !email.contains("@") || !email.contains(".") {
            return "Invalid email format."
        }
        if password.isEmpty {
            return "Lütfen şifre giriniz."
        }
        
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        
        return "success"
        
    }
    
    // connect to database
    
    func login(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "\(error.localizedDescription)"
            }
            else{
                self.kayitli = true
            }
            
        }
    }
   
        
}

#Preview {
    signInPage()
}
