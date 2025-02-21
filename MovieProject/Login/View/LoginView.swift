
import SwiftUI

enum TextFieldType {
    case email
    case password
}

struct LoginView: View {
    @AppStorage("isShowOnboarding") private var isShowOnboarding: Bool = false
    @StateObject var viewModel = LoginViewModel()
    @FocusState private var focusedField: TextFieldType?
    
    var body: some View {
        VStack(spacing: 20){
            
                TextField("Email", text: $viewModel.username)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .padding()
                    .keyboardType(.emailAddress)
                    .background(focusedField == .email ? Color.gray.opacity(0.7) : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                   
                    
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .password)
                    .textContentType(.password)
                    .padding()
                    .background(focusedField == .password ? Color.gray.opacity(0.7) : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
        
            Button {
                
                Task {
                    await viewModel.login()
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red)
            )
        }
        .onAppear() {
            isShowOnboarding = true
            Task {
                await viewModel.getRequestToken()
            }
        }
        .padding()
        .alert(viewModel.errorMessage ?? "Error", isPresented: $viewModel.isErrorOccured, actions: {
            Button {
                viewModel.errorMessage = nil
            } label: {
                Text("Ok")
            }
        })
    
    }
        
    

}
    



#Preview {
    LoginView()
}
