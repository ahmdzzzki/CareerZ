# Panduan kerja CareerZ

Berlaku untuk seluruh proyek dalam direktori ini. Baca `START_HERE_STEP_01.md` sebelum mengerjakan fitur. Ikuti cakupan permintaan pengguna; jangan melakukan redesign, refactor massal, atau menambahkan dependensi tanpa kebutuhan tugas.

## Struktur proyek

- `CareerZ.xcodeproj`: proyek Xcode, target dan scheme `CareerZ`, konfigurasi Debug/Release. Folder `CareerZ` memakai `PBXFileSystemSynchronizedRootGroup`; periksa keanggotaan target sebelum mengedit referensi proyek secara manual.
- `CareerZ/App/CareerZApp.swift`: entry point `@main`, membuka `ContentView`.
- `CareerZ/Resources/ContentView.swift`: memilih onboarding atau tab utama berdasarkan `@AppStorage("hasCompletedOnboarding")`. Jangan mengembalikan reset onboarding otomatis yang telah dihapus pada Step 01.
- `CareerZ/Navigation/MainTabView.swift`: tab Home dan Roadmap; Profile dibuka sebagai sheet dari fitur.
- `CareerZ/Features/{Onboarding,Assessment,Home,Roadmap,Profile}`: layar di `Views`, komponen khusus fitur di `Components`, state/logika presentasi di `ViewModels`, dan model khusus fitur di `Models` bila tersedia. Folder ViewModel onboarding saat ini bernama `VIewModels`; gunakan path yang ada dan hindari penggantian nama di luar cakupan tugas.
- `CareerZ/Core/Models`: model UI lintas fitur, termasuk `HomeRoute`, `FocusArea`, `NextStep`, dan `AssessmentQuestion`.
- `CareerZ/Core/Domain`: kontrak domain bersama seperti `CareerDomainID`, `SkillLevel`, `SkillDefinition`, `SkillAssessmentResult`, dan `MissionDefinition`.
- `CareerZ/Core/Services`: perhitungan domain, saat ini `SkillAssessmentEngine`.
- `CareerZ/Core/Data`: pemuatan data lokal lewat `LocalJSONLoader`.
- `CareerZ/Core/Theme` dan `CareerZ/Core/Components`: token visual dan komponen bersama.
- `CareerZ/Resources`: asset catalog dan `CareerKnowledge/product_management_skills.json`.

## Pola SwiftUI dan state

- Ikuti pola yang ada: `struct …: View`, ViewModel `@Observable final class` dengan `import Observation`, dimiliki layar lewat `@State private var viewModel`. Jangan memperkenalkan `ObservableObject`/`@StateObject` sebagai pola baru tanpa alasan.
- Simpan state UI lokal di `@State`/`@FocusState`; gunakan `@Binding` dan closure untuk komunikasi komponen. Letakkan perhitungan dan perubahan state fitur di ViewModel, serta scoring domain di service.
- Pertahankan initializer yang dapat menerima data dan default sample agar preview mudah dibuat. Banyak layar masih menggunakan data sample; jangan menyebutnya data tersimpan atau hasil assessment nyata.
- Home menggunakan `NavigationStack(path:)`, `NavigationPath`, dan `HomeRoute`; Roadmap memakai destination berbasis item. Ikuti pola navigasi fitur yang disentuh, termasuk sheet Profile/Next Step dan full-screen assessment dari Next Step.
- Onboarding memakai enum langkah dan callback `onFinished`. Pertahankan alur back, skip, pemilihan goal, assessment, completion, lalu Home.
- Pecah body besar menjadi subview/properti privat atau komponen fitur. Pindahkan ke `Core/Components` jika benar-benar dipakai lintas fitur.
- Pengaturan target memakai Swift language mode `5.0`, default actor isolation `MainActor`, dan approachable concurrency. Periksa isolasi saat menambah pekerjaan asynchronous; jangan mengubah pengaturan concurrency untuk menghindari error tanpa memahami sebabnya.

## Tema dan komponen bersama

- Gunakan warna semantik dari `AppColor.swift`: `.appPrimary`, `.appGroupedBackground`, `.appCardBackground`, `.appTextPrimary`, `.appTextSecondary`, dan warna status. Warna brand bersumber dari asset catalog. Hindari warna hex baru jika token yang sesuai sudah tersedia.
- Gunakan `AppTypography` untuk font, `AppSpacing` untuk jarak/padding, dan `AppRadius` untuk radius. Contoh: `.font(AppTypography.headline)`, `.padding(AppSpacing.cardPadding)`, dan `.cardBackground()`.
- Pakai `AppButton(title:action:systemImage:isEnabled:)` untuk tombol utama, `AppSearchField` untuk pencarian dengan binding teks/fokus, dan `ExpandableInfoRow` untuk informasi yang dibuka/tutup di tempat.
- Kartu konten memakai `.cardBackground(cornerRadius:)`: permukaan solid adaptif, radius default `AppRadius.lg`, tanpa shadow default. Pertahankan pemisahan visual ini; Liquid Glass digunakan pada kontrol seperti tombol/pencarian dan chrome navigasi.
- Ikuti aksesibilitas yang sudah ada: label/hint tombol, ikon dekoratif `accessibilityHidden`, teks yang dapat membungkus, serta Reduce Motion untuk animasi komponen. Periksa light/dark mode dan ukuran teks besar saat mengubah UI.
- Pertahankan `#Preview` yang relevan dan gunakan sample atau wrapper state lokal untuk preview komponen interaktif.

## Fondasi produk Step 01

- Engine scoring sudah ada dan tidak melakukan I/O: capability/evidence dibatasi 0–4, skor berbobot 60%/40%, gap tidak negatif, dan prioritas berdasarkan gap × importance weight. Jangan menduplikasi rumus di View.
- `rankedGaps` mengurutkan prioritas menurun dengan judul sebagai pemecah seri; input hasil harus memiliki `skillID` unik karena memakai `Dictionary(uniqueKeysWithValues:)`.
- JSON PM merupakan array `SkillDefinition` berisi delapan skill. Untuk integrasi berikutnya, gunakan `LocalJSONLoader.decode([SkillDefinition].self, from: "product_management_skills")`, tangani error, dan pastikan JSON tersalin ke bundle aplikasi.
- Assessment yang ada memakai `AssessmentQuestionFactory`; UI ini belum merupakan integrasi assessment PM berbasis taxonomy/scoring Step 01.
- SwiftData persistence, Compass assessment UI, integrasi PM assessment UI, UI generasi roadmap, dan metadata App Store belum ditambahkan oleh Step 01. Model mission tidak berarti generator roadmap sudah tersedia.
- Langkah berikutnya dalam dokumen awal: muat taxonomy PM, tampilkan delapan skill melalui ViewModel assessment PM, lalu tambahkan target unit test engine. Kerjakan hanya bila diminta.

## Build dan verifikasi

Jalankan dari root proyek. Gunakan Xcode dengan SDK yang mendukung deployment target iOS **26.5** dan API `.glassEffect`; proyek dibuat dengan Xcode 26.5 dan menargetkan iPhone serta iPad. Tidak ada `Package.swift` maupun dependensi package target saat ini.

```sh
xcodebuild -version
xcodebuild -list -project CareerZ.xcodeproj
xcodebuild -showdestinations -project CareerZ.xcodeproj -scheme CareerZ
xcodebuild -project CareerZ.xcodeproj -scheme CareerZ -configuration Debug \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/CareerZ-DerivedData CODE_SIGNING_ALLOWED=NO build
```

- Alternatif GUI: buka `CareerZ.xcodeproj`, pilih scheme CareerZ dan simulator yang kompatibel, lalu Build/Run. Build device membutuhkan signing yang sesuai; jangan mengubah team/bundle identifier untuk verifikasi simulator.
- Build generik hanya memverifikasi kompilasi; jalankan aplikasi pada simulator tertentu untuk pemeriksaan perilaku. Gunakan destination yang tersedia dari `-showdestinations`, bukan nama perangkat yang diasumsikan.
- Saat mengubah UI, periksa alur yang terdampak: onboarding baru (back/skip/continue dan pilihan jawaban), masuk Home setelah completion, relaunch tanpa reset onboarding, tab Roadmap, detail Home/Roadmap, sheet Profile/Next Step, serta penutupan assessment.
- Untuk menguji onboarding ulang, gunakan instalasi simulator yang bersih atau reset data simulator khusus pengujian; jangan menambahkan reset ke kode aplikasi.
- Saat mengubah resource, verifikasi decode JSON dan keberadaannya di bundle, bukan hanya validitas sintaks JSON.
- Saat ini hanya ada target aplikasi; tidak ada target unit/UI test. Jangan mengklaim `xcodebuild test` atau `swift test` sudah dapat digunakan. Jika target tes ditambahkan untuk engine, cakup clamp 0–4, bobot skor, gap, prioritas, hasil kosong, dan pengurutan seri; gunakan tanggal tetap untuk hasil deterministik.
- Untuk perubahan dokumentasi saja, cukup cocokkan panduan dengan kode dan konfigurasi proyek; build aplikasi tidak wajib. Laporkan pemeriksaan yang benar-benar dijalankan dan batasannya. Error akses cache/CoreSimulator dalam sandbox tidak membuktikan error kode.
- Tinjau hanya perubahan dalam direktori proyek. Jika Git ternyata berakar di direktori induk, gunakan pathspec proyek (`git status --short -- .`) dan jangan menyertakan file pribadi di luar proyek.
