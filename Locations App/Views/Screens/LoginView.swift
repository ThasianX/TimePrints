// Kevin Li - 10:46 AM - 2/28/20

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginService: ICloudLoginService

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

}

private extension LoginView {
    private var profileView: some View {
        LottieView(fileName: "profile")
            .frame(width: 150, height: 150)
    }

    private var loadingView: some View {
        LottieView(fileName: "loading")
            .frame(width: 100, height: 100)
    }

}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
