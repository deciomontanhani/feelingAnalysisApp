import ProjectDescription

let project = Project(name: "FeelingAnalysisApp",
                      organizationName: "Décio Montanhani",
                      targets: [
                        Target(name: "FeelingAnalysisApp",
                               platform: .iOS,
                               product: .app,
                               bundleId: "br.com.deciomontanhani.FeelingAnalysisApp",
                               infoPlist: "FeelingAnalysisApp/Info.plist",
                               sources: ["FeelingAnalysisApp/Sources/**"],
                               resources: ["FeelingAnalysisApp/Resources/**"],
                               dependencies: []),
                        Target(name: "FeelingAnalysisAppTests",
                               platform: .iOS,
                               product: .unitTests,
                               bundleId: "br.com.deciomontanhani.FeelingAnalysisAppTests",
                               infoPlist: "FeelingAnalysisAppTests/Info.plist",
                               sources: ["FeelingAnalysisAppTests/Sources/**"],
                               resources: ["FeelingAnalysisAppTests/Resources/**"],
                               dependencies: [
                                    .target(name: "FeelingAnalysisApp")
                               ])
                      ])
