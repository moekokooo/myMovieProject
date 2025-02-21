
import SwiftUI

struct OnboardingView: View {    
    let templates : [Template] = [
        Template(
            title: "Watch everywhere.",
            subTitle: "Stream on your phone, tablet, laptop and TV.",
            image: "img1"
        ),
        Template(
            title: "There's a plan for every fan",
            subTitle: "Small price. Big entertainment.", image: "img2"
        ),
        Template(
            title: "Cancel online anytime.",
            subTitle: "Join today, no reson to wait",
            image: "img3"
        ),
    ]
    
    @State var currentPage: Int = 0
    
    var body: some View {
        
        ZStack {
           
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<templates.count, id: \.self) { index in
                        OnboardingItem(template: templates[index])
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
        
            }
           
        }
        
        .toolbar {
            NavigationLink(destination: LoginView()) {
                Text("Sign in")
                    .font(.headline)
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .frame(height: 45)
                           .padding(.horizontal)
                           .background(Color.gray.opacity(0.5))
                           .cornerRadius(12)
                           .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            }
           
        }

    }
       
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}
