import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String], spm: [TargetDependency], developmentTeam: String) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) } + spm)
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        
        let setting = Settings.settings(
            base: SettingsDictionary().automaticCodeSigning(devTeam: developmentTeam),
            debug: SettingsDictionary(),
            release: SettingsDictionary(),
            defaultSettings: DefaultSettings.recommended
        )
        
        return Project(name: name,
                       organizationName: "tuist.io",
                       settings: setting,
                       targets: targets
        )
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let appclip = Target(
            name: "AppClip",
            platform: .iOS,
            product: .appClip,
            bundleId: "io.tuist.\(name).Clip",
            infoPlist: "Targets/AppClip/Configs/Info.plist",
            sources: ["Targets/AppClip/Sources/**",],
            entitlements: "Targets/AppClip/Entitlements/AppClip.entitlements",
            dependencies: [
                .sdk(name: "AppClip", type: .framework, status: .required),
            ]
        )
        
        let notificationExtension = Target(
            name: "NotificationServiceExtension",
            platform: .iOS,
            product: .appExtension,
            bundleId: "io.tuist.TuistApp.NotificationServiceExtension",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            sources: "Targets/NotificationServiceExtension/**",
            dependencies: []
        )
        
        let intent = Target(
            name: "Intent",
            platform: .iOS,
            product: .appExtension,
            bundleId: "io.tuist.TuistApp.Intent",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.intents-service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).Intent"
                ]
            ]),
            sources: "Targets/Intent/**",
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "Moya")
            ]
        )
        let intentUI = Target(
            name: "IntentUI",
            platform: .iOS,
            product: .appExtension,
            bundleId: "io.tuist.TuistApp.IntentUI",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.intents-ui-service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).IntentUI"
                ]
            ]),
            sources: "Targets/Intent/**",
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "Moya")
            ]
        )
        
        let widget = Target(
            name: "Widget",
            platform: .iOS,
            product: .appExtension,
            bundleId: "io.tuist.TuistApp.Widget",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).Widget"
                ]
            ]),
            sources: "Targets/Widget/**",
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "Moya")
            ]
        )
       
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies + [
                .target(name: "AppClip"),
                    .target(name: "NotificationServiceExtension"),
                    .target(name: "Intent"),
                    .target(name: "IntentUI"),
                    .target(name: "Widget")
            ]
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        
        var appTargets = [mainTarget, testTarget, appclip, notificationExtension, intent, intentUI, widget]
        
        for i in 0..<300 {
            let main = Target(
                name: name + "\(i)",
                platform: platform,
                product: .app,
                bundleId: "io.tuist.\(name)",
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["Targets/\(name)/Sources/**"],
                resources: ["Targets/\(name)/Resources/**"],
                dependencies: dependencies
            )

            let test = Target(
                name: "\(name)Tests\(i)",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                dependencies: [
                    .target(name: "\(name)")
            ])
            
            appTargets.append(main)
            appTargets.append(test)
        }
        
        return appTargets
    }
}
