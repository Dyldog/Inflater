//
//  InflaterApp.swift
//  Inflater
//
//  Created by Dylan Elliott on 27/6/2024.
//

import SwiftUI

@main
struct InflaterApp: App {
    @State var inflationDataManager: InflationDataManager = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: inflationDataManager)
        }
    }
}
