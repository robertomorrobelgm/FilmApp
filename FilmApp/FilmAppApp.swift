//
//  FilmAppApp.swift
//  FilmApp
//
//  Created by Roberto Morrobel on 1/19/22.
//

import SwiftUI

@main
struct FilmAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            FilmListView()
        }
    }
}
