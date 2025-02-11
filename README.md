# WRouter

Web like routing system with swipe backward forward gesture for iOS, and keyboard shortcuts for macOS.

## Usage

### Defining your routings

```swift
WRouterView { url, qparm in
    switch url {
    case "/":
        YourAwesomeView()
    case "/profile":
        MyPrettyProfile()
    default:
        // This is default 404 Page. (Not really HTTP 404)
        // You can change it whatever design you want.
        WRouter_NotFound()
    }
}
```

### Moving around urls

```swift
// like clicking <a href="/main?a=123">
WPath.shared.goto(path: "/main", qparm: "a=123")

// like location.href = "/set"
WPath.shared.set_path(path: "/set", qparm: nil)

// replacing now path without changing URL History
WPath.shared.replace(path: "/main", qparm: "a=123")

// backward & forward
WPath.shared.backward()
WPath.shared.forward()
```
