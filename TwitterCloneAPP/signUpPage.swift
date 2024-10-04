import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var firstName = ""
    @State private var deneme = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false

    var body: some View {
        VStack(spacing: 20) {
            // Başlık
            Text("Create Your Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
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
            
            
            TextField("deneme", text: $deneme)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .autocapitalization(.none)
            
            // Şifre Alanı
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            
            // Kayıt Butonu
            Button(action: {
                signUp(firstName: firstName, lastName: lastName, email: email, password: password, username: username)
            }
            
            ) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
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
        .padding(.horizontal, 30)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Arka plan rengi
    }
    
    // add a function to sign up button
    func signUp(firstName : String, lastName : String, email : String, password : String , username : String) {

            Auth.auth().createUser(withEmail: email, password: password)
        
    }
    
    
}

#Preview {
    SignUpView()
}






