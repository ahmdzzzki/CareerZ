import SwiftUI
import AuthenticationServices

struct AppleAccountSection: View {
    @State private var account = AppleAccount()
    @State private var sync = CloudSyncMonitor.shared
    @Environment(\.colorScheme) private var appearance
    @Environment(\.scenePhase) private var phase
    @State private var disconnect = false
    var body: some View {
        Section("Apple & iCloud") {
            if account.connected {
                Label("Connected with Apple", systemImage: "checkmark.seal")
                Button("Disconnect Apple", role: .destructive) { disconnect = true }
                    .alert("Disconnect Apple?", isPresented: $disconnect) {
                        Button("Disconnect", role: .destructive) { account.disconnect() }
                        Button("Cancel", role: .cancel) {}
                    } message: { Text("This removes the Apple connection on this device. Your progress and iCloud sync are kept. You can revoke access in Apple Account settings.") }
            } else {
                SignInWithAppleButton(.signIn, onRequest: { request in request.requestedScopes = [] }, onCompletion: account.complete)
                    .accessibilityIdentifier("apple-sign-in")
                    .signInWithAppleButtonStyle(appearance == .dark ? .white : .black)
                    .frame(height: 50).clipShape(RoundedRectangle(cornerRadius: 12))
                Text("Optional. You can keep using CareerZ without signing in.").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
            }
            Label("iCloud progress sync", systemImage: "icloud")
            Text(account.cloudMessage).font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
            if let detail = sync.detail { Text(detail).font(AppTypography.caption).foregroundStyle(Color.appTextSecondary) }
            Text("Sync uses the iCloud account in device Settings, independently of Sign in with Apple. Assessments, direction, and mission notes sync privately through Apple. Your profile name stays on this device.")
                .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
        }
        .task { await account.refresh() }
        .onChange(of: phase) { _, value in if value == .active { Task { await account.refresh() } } }
        .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { _ in Task { await account.refresh() } }
        .alert("Apple connection", isPresented: Binding(get: { account.message != nil }, set: { if !$0 { account.message = nil } })) {
            Button("OK") { account.message = nil }
        } message: { Text(account.message ?? "") }
    }
}
