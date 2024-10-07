import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpPage: View {
    
    // variables
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false
    @State private var durum : Bool = false
    @State private var kayitli : Bool = false
    
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
                        kayit(email: email, password: password, firstName: firstName, lastName: lastName, username: username)
                        
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
                        self.kayitli = true
                        
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
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $kayitli) {
                signInPage()
            }
            .navigationDestination(isPresented: $durum) {
                mainPage()
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
    
    /*
     Task:
     
     1-Check the informations for if its valid or nah
     2-Save users information for FirebaseAuth
     3-Store the data to the Firestore
     
     
     
     */
    
    
    
    
    func check(email:String,password:String,firstName:String,lastName:String,username:String) ->String {
        
        if firstName.isEmpty {
            return "Lütfen ad giriniz."
        }
        if lastName.isEmpty{
            return "Lütfen soyad giriniz"
        }
        if username.isEmpty{
            return "Lütfen kullanıcı adı giriniz"
        }
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
    
    
    func saveUserInfo(uid: String,email:String,password:String,firstName:String,lastName:String,username:String){
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
    
    
    
    
    // use this function after we check the valid inputs
    func signUp(email:String,password:String,firstName:String,lastName:String,username:String){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            guard let user = authResult?.user else {
                self.errorMessage = "User creation failed."
                return
            }
            
            saveUserInfo(uid:user.uid, email: email, password: password, firstName: firstName, lastName: lastName, username: username)
            
        }
        
        
    }
    
    // final function to use all the functions
    func kayit(email:String,password:String,firstName:String,lastName:String,username:String){
        let sonuc = check(email: email, password: password, firstName: firstName, lastName: lastName, username: username)
        if sonuc == "success" {
            signUp(email: email, password: password, firstName: firstName, lastName: lastName, username: username)
            self.isRegistered = true
            self.durum  = true
        }
        else{
            self.errorMessage = sonuc
        }
            
        
        
        
    }

        
}

#Preview {
    SignUpPage()
}

