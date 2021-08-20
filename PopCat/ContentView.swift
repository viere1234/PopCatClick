//
//  ContentView.swift
//  PopCat
//
//  Created by 張智堯 on 2021/8/19.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var monitor = NetworkMonitor()
    
    var body: some View {
        if monitor.isConnected
        {
            WebView(request: URLRequest(url: URL(string: "https://popcat.click/")!))
        } else {
            VStack {
                LottieView(name: "36012-searching-wifi", loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                
                Text("No Internet Connection")
                    .font(.largeTitle)
                
                Text("Please restart the App")
                    .font(.title)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        let webView = WKWebView(frame: CGRect.zero, configuration: conf)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}
