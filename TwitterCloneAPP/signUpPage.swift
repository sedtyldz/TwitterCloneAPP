import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false
    @State private var durum : Bool = false

    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {
                // Başlık
                Text("Create Your Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40)
                
                // İsim Alanı
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
                // Soyisim Alanı
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
                // Kullanıcı Adı Alanı
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
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
                        signUp()
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
                        
                        if check(email: email, password: password) == "basarili" {
                            
                            durum = true

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
                
                // Başarı Durumu
                if isRegistered {
                    Text("Successfully Registered!")
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $durum) {
                signInPage()
            }
            .padding(.horizontal, 30)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
        
        
        // Kullanıcı Kayıt Fonksiyonu
        func signUp() {
            if let error = check(email: email, password: password)  {
                
                if error == "basarili" {
                    
                    self.errorMessage = ""
                    
                }
                self.errorMessage = error
                return
            }
            
            // Firebase Auth üzerinden kullanıcı oluşturma
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                
                guard let user = authResult?.user else {
                    self.errorMessage = "User creation failed."
                    return
                }
                
                self.isRegistered = true
                saveUserData(uid: user.uid, firstName: firstName, lastName: lastName, username: username, email: email)
            }
        }
        
        func saveUserData(uid: String, firstName: String, lastName: String, username: String, email: String) {
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "username": username,
                "email": email,
                "uid": uid
            ]) { error in
                if let error = error {
                    self.errorMessage = "Error saving user data: \(error.localizedDescription)"
                } else {
                    print("User data saved successfully.")
                }
            }
        }
        
        func check(email: String, password: String) -> String? {
            
            if username.isEmpty {
                return "Username field is required."
            }
            
            if email.isEmpty {
                return "Email field is required."
            }
            
            if password.isEmpty {
                return "Password field is required."
            }
            
            if !email.contains("@") || !email.contains(".") {
                return "Invalid email format."
            }
            
            if password.count < 6 {
                return "Password must be at least 6 characters."
            }
            
            return "basarili"
        }
    }

#Preview {
    SignUpView()
}

