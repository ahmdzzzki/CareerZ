//
//  MainTabView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            RoadmapView()
                .tabItem {
                    Label("Roadmap", systemImage: "map.fill")
                }
            
            ProfileSheetView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(.appPrimary)
    }
}

#Preview {
    MainTabView()
}

struct HomeView: View {
    var body: some View {
        Text("Home")
    }
}

struct RoadmapView: View {
    var body: some View {
        Text("Roadmap")
    }
}

struct ProfileSheetView: View {
    var body: some View {
        Text("Profile")
    }
}
