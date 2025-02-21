
import SwiftUI

struct OnboardingItem: View {
    let template: Template
     
     var body: some View {
         VStack(spacing: 20){
             if let imageName = template.image {
                 Image(imageName)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 200,height: 200)
             }
            
             Text(template.title)
                 .font(.largeTitle.bold())
                 .multilineTextAlignment(.center)
                 .lineLimit(2)
                 .minimumScaleFactor(0.5)
             Text(template.subTitle)
                 .font(.title3)
                 .multilineTextAlignment(.center)
                 .foregroundStyle(.secondary)
         }

     }
}

#Preview {
    OnboardingItem(template: Template(
        title: "Cancel online anytime.",
        subTitle: "Join today, no reson to wait",
        image: "img3"
    ))
}
