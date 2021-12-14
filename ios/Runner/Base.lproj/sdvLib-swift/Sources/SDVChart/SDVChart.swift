    //
    //  SDVChart
    //
    //  Created by Bestiario on 30/12/2020.
    //
import Foundation
import SwiftUI
import WebKit
#if canImport(UIKit)

import UIKit
    
public struct SDVChart : UIViewRepresentable {
    
    public typealias Context = UIViewRepresentableContext<SDVChart>

    
    public var wkWebview = WKWebView()
    var loadStatusChanged: ((Bool, Error?) -> Void)? = nil
    var webViewLoaded: Bool = false
    
    var chartType: String
    var config: [String:Any]
    var data: [[Any]]

    public init(chartType: String, config:[String:Any] = [:], data:[[Any]] = [[]]) {
        self.chartType = chartType
        self.config = config
        self.data = data
    }
    
    public func getConfig() -> [String:Any] {
        return config
    }
    public mutating func setConfig(config: [String:Any]) {
        self.config = config
        self.updateChart()
    }
    
    public func getData() -> [[Any]] {
        return self.data
    }
    public mutating func setData(data: [[Any]]) {
        self.data = data
        self.updateChart()
    }
    
    public func makeCoordinator() -> SDVChartCoordinator {
        SDVChartCoordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        
        let url = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "webViewWrapper")!
        self.wkWebview.loadFileURL(url, allowingReadAccessTo: url)
        
        let request = URLRequest(url: url)
        
        self.wkWebview.navigationDelegate = context.coordinator
        self.wkWebview.scrollView.isScrollEnabled = false
        self.wkWebview.load(request)
        
        return self.wkWebview
    }
    
    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<SDVChart>) {
        
    }
    
    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }
    
    public func updateChart(){
        let dataString = self.data.description
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.config, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
            
            let js = "sdvInterface.render('"+self.chartType+"',{data:"+dataString+", config:"+jsonString+"})";
            
            self.wkWebview.evaluateJavaScript(js, completionHandler: { (object, error) in
                if error != nil {
                    print(error as Any)
                    print(object as Any)
                }
            })
        }catch{
            print("Error parsing chart configuration object: " + error.localizedDescription)
        }
    }
    
}
#endif

public class SDVChartCoordinator: NSObject, WKNavigationDelegate {
    let parent: SDVChart

    init(_ parent: SDVChart) {
        self.parent = parent
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        parent.loadStatusChanged?(true, nil)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.loadStatusChanged?(false, nil)
        parent.updateChart()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.loadStatusChanged?(false, error)
    }
}
