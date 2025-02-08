import WebKit

struct Cookie {
    var name: String
    var value: String
}

let rootUrl = URL(string: "https://account.mythblade.com")!
let allowedOrigins: [String] = ["account.mythblade.com"]
let authOrigins: [String] = []
let displayMode = "standalone"
let adaptiveUIStyle = true
let overrideStatusBar = false
let statusBarTheme = "dark"
let pullToRefresh = false
