//
//  ContentView.swift
//  KidsVIdeoSuggest
//
//  Created by Rafael Neres Lima on 10/05/24.
//

import SwiftUI
import Combine
import GoogleGenerativeAI

let backgroundGradient = LinearGradient(colors: [.blue, .pink], startPoint: .top, endPoint: .center)

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput = ""
    @State var aiResponse = "Os melhores videos para as crianças!"
    @State var aiBaseSearch = "Me mostre links de canais do Youtube disponiveis para uma criança de "
    @State var aiBaseAge = " idade. Os links devem ser compativeis com o app do Youtube para iPhone."
    @State var logoAnimating = false
    @State private var imageLogo = "kidsTvLogo"
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            VStack {
                // MARK: Animating logo
                
                Image(imageLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .opacity(logoAnimating ? 0.5 : 1)
                    .animation(.easeInOut, value: logoAnimating)
                
                // MARK: Input fields
                HStack {
                    TextField("Digite a idade da criança", text: $textInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.plain)
                        .foregroundStyle(.white)
                    Button(action: sendMessage, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }.padding(10)
                
                // MARK: AI response
                ScrollView {
                    Text(LocalizedStringKey(aiResponse))
                        .font(.system(size: 20))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background {
                // MARK: Background
                ZStack {
                    backgroundGradient.edgesIgnoringSafeArea(.all)
                }
                .ignoresSafeArea()
            }
        }
    }
    
    // MARK: Fetch response
    func sendMessage() {
        hideKeyboard()
        aiResponse = ""
        startLoadingAnimation()
        
        Task {
            do {
                let response = try await model.generateContent(aiBaseSearch + textInput + aiBaseAge)
                
                stopLoadingAnimation()
                
                guard let text = response.text else  {
                    textInput = "Não foi possível comunicação com o servidor.\nTente novamente."
                    return
                }
                
                textInput = ""
                aiResponse = text
                
            } catch {
                stopLoadingAnimation()
                aiResponse = "Erro!\n\(error.localizedDescription)"
            }
        }
    }
    
    // MARK: Response loading animation
    func startLoadingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation() {
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
