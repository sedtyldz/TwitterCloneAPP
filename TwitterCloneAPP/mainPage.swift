
import SwiftUI

struct mainPage: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    mainPage()
}
