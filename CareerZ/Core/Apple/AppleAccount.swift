import AuthenticationServices
import CloudKit
import Observation
import Security

@MainActor @Observable final class AppleAccount {
    var connected = false
    var message: String?
    var cloudMessage = "Checking iCloud availability…"
    private let service = "com.academy.CareerZ.apple-identity"

    private var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: "apple-user"]
    }
    private func userID() -> String? {
        var request = query
        request[kSecReturnData as String] = true
        request[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        guard SecItemCopyMatching(request as CFDictionary, &result) == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func complete(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            let data = Data(credential.user.utf8)
            var values = query
            values[kSecValueData as String] = data
            values[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            let existing = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
            let status = existing == errSecItemNotFound ? SecItemAdd(values as CFDictionary, nil) : existing
            guard status == errSecSuccess else { message = "Your Apple connection couldn’t be saved securely. Please try again."; return }
            connected = true
        case .failure(let error):
            if (error as? ASAuthorizationError)?.code != .canceled { message = "Sign in with Apple couldn’t finish. Please try again. Your local progress is safe." }
        }
    }
    func disconnect() {
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { message = "Couldn’t disconnect. Please try again."; return }
        connected = false
    }
    func refresh() async {
        if let id = userID() {
            do {
                let state = try await ASAuthorizationAppleIDProvider().credentialState(forUserID: id)
                if state == .revoked || state == .notFound { disconnect() }
                else { connected = state == .authorized }
            } catch { message = "Your Apple connection couldn’t be checked. Try again when online." }
        }
        #if targetEnvironment(simulator)
        cloudMessage = "Sync is available in a signed device build. Simulator progress stays local."
        #else
        do {
            switch try await CKContainer(identifier: "iCloud.com.academy.CareerZ").accountStatus() {
            case .available: cloudMessage = "iCloud is available. Changes sync automatically when connectivity allows."
            case .noAccount: cloudMessage = "Sign in to iCloud in device Settings to sync. Progress stays on this device meanwhile."
            case .restricted: cloudMessage = "iCloud access is restricted on this device."
            case .temporarilyUnavailable: cloudMessage = "iCloud is temporarily unavailable. Your changes stay saved locally."
            default: cloudMessage = "iCloud availability couldn’t be determined. Your changes stay saved locally."
            }
        } catch { cloudMessage = "iCloud couldn’t be reached. Your progress is still saved locally." }
        #endif
    }
}

// Event status reflects actual CloudKit activity, not an inferred "synced" flag.
@MainActor @Observable final class CloudSyncMonitor {
    static let shared = CloudSyncMonitor()
    var detail: String?
}
