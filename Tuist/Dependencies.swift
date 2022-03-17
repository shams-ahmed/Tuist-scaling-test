import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.5.0")),
        .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.5.0")),
        .remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "15.0.0")),
        .remote(url: "https://github.com/google/promises", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/roberthein/TinyConstraints", requirement: .upToNextMajor(from: "4.0.2")),
        .remote(url: "https://github.com/sindresorhus/Defaults", requirement: .upToNextMajor(from: "6.2.1")),
        .remote(url: "https://github.com/CombineCommunity/CombineExt", requirement: .upToNextMajor(from: "1.5.1")),
        .remote(url: "https://github.com/CombineCommunity/CombineCocoa", requirement: .upToNextMajor(from: "0.4.0")),
        .remote(url: "https://github.com/Peter-Schorn/SpotifyAPI", requirement: .upToNextMajor(from: "2.0.3"))
    ],
    platforms: [.iOS]
)




  
