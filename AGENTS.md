# Panduan kerja CareerZ

Berlaku untuk seluruh proyek dalam direktori ini. Baca `docs/PRODUCT_DIRECTION.md` dan `docs/IMPLEMENTATION_AUDIT.md` sebelum mengerjakan fitur. `START_HERE_STEP_01.md` merupakan catatan historis, bukan urutan implementasi terbaru. Ikuti cakupan permintaan pengguna; jangan melakukan redesign, refactor massal, atau menambahkan dependensi tanpa kebutuhan tugas.

## Struktur proyek

- `CareerZ.xcodeproj`: proyek Xcode, target dan scheme `CareerZ`, konfigurasi Debug/Release. Folder `CareerZ` memakai `PBXFileSystemSynchronizedRootGroup`; periksa keanggotaan target sebelum mengedit referensi proyek secara manual.
- `CareerZ/App/CareerZApp.swift`: entry point `@main`, membuka `ContentView`.
- `CareerZ/Resources/ContentView.swift`: memilih onboarding atau tab utama berdasarkan `@AppStorage("hasCompletedOnboarding")`. Jangan mengembalikan reset onboarding otomatis yang telah dihapus pada Step 01.
- Alur aktif: `CareerZApp` → `ContentView` → `Features/Journey/Views/JourneyRootView`. Tab aktif Home, Discover, Roadmap, dan Profile memakai `JourneyStore`. `Navigation/MainTabView` dan fitur Home/Roadmap/Assessment lama tetap merupakan prototype yang belum tersambung ke data nyata; jangan mengaktifkan jalur sample untuk pengguna.
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

## Catatan historis Step 01

- Engine scoring sudah ada dan tidak melakukan I/O: capability/evidence dibatasi 0–4, skor berbobot 60%/40%, gap tidak negatif, dan prioritas berdasarkan gap × importance weight. Jangan menduplikasi rumus di View.
- `rankedGaps` mengurutkan prioritas menurun dengan judul sebagai pemecah seri; hasil berulang untuk satu skill memakai timestamp terbaru tanpa crash.
- JSON PM merupakan array `SkillDefinition` berisi delapan skill. Untuk integrasi berikutnya, gunakan `LocalJSONLoader.decode([SkillDefinition].self, from: "product_management_skills")`, tangani error, dan pastikan JSON tersalin ke bundle aplikasi.
- Assessment yang ada memakai `AssessmentQuestionFactory`; UI ini belum merupakan integrasi assessment PM berbasis taxonomy/scoring Step 01.
- Step 01 belum menyertakan persistence/UI/generator roadmap. Implementasi terbaru menambahkan `JourneySchemaV1`, Compass, assessment PM, dan roadmap mission di `Features/Journey`. Metadata App Store masih merupakan pekerjaan release.
- Urutan sumber utama: foundation → Compass/Discovery → alur PM → accessibility/release. Assessment readiness lima dimensi lama ditunda; jangan dicampur dengan Compass atau proficiency skill 0–4.

## Build dan verifikasi

Jalankan dari root proyek. Gunakan Xcode dengan SDK yang mendukung deployment target iOS **26.5** dan API `.glassEffect`; proyek dibuat dengan Xcode 26.5 dan menargetkan iPhone serta iPad. `Package.swift` menguji source domain/data/store yang sama pada macOS; target iOS tidak memakai dependensi package eksternal.

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
- Jalankan `swift test --scratch-path /tmp/CareerZ-domain-build` untuk tes domain dan persistence. Target `CareerZUITests` ada pada shared scheme CareerZ; jalankan `xcodebuild test` dengan destination simulator kompatibel dari `-showdestinations`. Tes UI mereset data melalui UI; gunakan simulator khusus pengujian, bukan simulator dengan progress pribadi.
- Untuk perubahan dokumentasi saja, cukup cocokkan panduan dengan kode dan konfigurasi proyek; build aplikasi tidak wajib. Laporkan pemeriksaan yang benar-benar dijalankan dan batasannya. Error akses cache/CoreSimulator dalam sandbox tidak membuktikan error kode.
- Tinjau hanya perubahan dalam direktori proyek. Jika Git ternyata berakar di direktori induk, gunakan pathspec proyek (`git status --short -- .`) dan jangan menyertakan file pribadi di luar proyek.

## State pengguna dan integritas

- Compass memakai 40 pertanyaan bundled JSON, delapan trait, reverse scoring 1–5, dan enam match yang dijelaskan melalui kontribusi berbobot. Match bukan probabilitas sukses atau diagnosis.
- Assessment PM memakai delapan skill, capability/evidence 0–4, bobot 60/40, dan target portfolio. Tampilkan proficiency, bukan klaim employability.
- `JourneyStore` adalah state `@MainActor @Observable`, dengan `ModelContext` yang disuntikkan. Selalu `save()` secara eksplisit; jika gagal, rollback dan tampilkan error. Jangan mengganti storage gagal dengan store in-memory kosong.
- `JourneySchemaV1/V2` dan `JourneyMigrationPlan` menyimpan snapshot versioned, arah terpilih, bukti/refleksi, serta tanggal completion. Perubahan schema berikutnya memerlukan migration stage. Jangan mengganti identifier mission/skill tanpa strategi migrasi.
- `JourneyEngine.roadmap` memakai topological ordering dan prioritas gap. Skill yang mencapai target menjadi Optional Validation; completion tetap membutuhkan tindakan pengguna. Undo harus menjaga prasyarat, dan reset permanen memerlukan dialog konfirmasi di aplikasi.
- Pertanyaan/content harus direview dengan target users sebelum release. Jangan menyebut Compass sebagai assessment ilmiah. UI dan copy v1 menggunakan bahasa Inggris.


## Identitas visual CareerZ

- Pertahankan palet biru brand dari asset, latar grouped abu-abu, kartu putih adaptif beradius besar, heading tebal, ikon pastel, dan tombol utama kapsul.
- Gunakan aset asli `OnboardingIntro`, `Assessment`, dan `productManager`; gunakan `JourneyVisuals` untuk kartu, ring, dan tile lintas layar journey.
- Home berisi snapshot, arah terpilih, carousel skill, Next Step, dan ringkasan roadmap. Pengguna baru tetap mendapat konten yang bisa ditindaklanjuti tanpa skor atau progress palsu.
- Assessment PM memiliki 16 langkah: capability lalu evidence untuk masing-masing delapan skill. CTA tetap di safe-area bawah. Compass tetap 40 pertanyaan.
- Ring proficiency adalah rata-rata berbobot skor skill dibagi empat, bukan kesiapan diterima kerja. Tren hanya ditampilkan bila ada dua assessment yang dapat dibandingkan.


## Apple dan interaksi native

- Permintaan pengguna 16 Oktober mengizinkan Sign in with Apple dan CloudKit; baca `docs/APPLE_SERVICES.md`. Simpan identifier Apple di Keychain, jangan meminta email/nama tanpa kebutuhan.
- Schema aktif V2 kompatibel CloudKit, V1 tetap untuk migrasi. Jangan mengubah V1. Simulator memakai `.none`; build perangkat memakai private iCloud container.
- Jangan menyamakan credential Apple dengan akun iCloud perangkat. Jangan menampilkan account availability sebagai bukti sync berhasil.
- Toolbar iOS sudah memiliki glass native: jangan menambah `.buttonStyle(.glass)` atau `.glassEffect` lagi di dalam toolbar. AppButton memakai kapsul solid brand.
- Gunakan alert native untuk konfirmasi penting agar berada di tengah pada iPhone/iPad, dengan Cancel eksplisit. Reset progress juga menghapus record cloud; jelaskan konsekuensinya.


## Enam domain — 19 Oktober 2026

- Semua enam domain memiliki konten aktif: delapan skill dan sepuluh mission per domain. `CareerKnowledgeCatalog` memvalidasi dan memuat pasangan `<domain>_skills.json` / `<domain>_missions.json`; jangan menambahkan cabang layar per-role.
- `JourneyStore.skillHistory`, `skills`, `missions`, `evidenceRecords`, `roadmap`, dan progress hanya untuk domain terpilih. `allSkillHistory` untuk hitungan global. Pergantian arah mempertahankan semua data di disk/cloud; jangan membandingkan skor antar-domain sebagai improvement.
- Pertahankan ID skill/mission PM lama. Domain baru memiliki prefix sendiri. Schema SwiftData V2 tidak berubah untuk perluasan konten ini.
- Urutan roadmap mengutamakan tahap Foundation/Practice/Portfolio, kemudian gap di antara mission yang memenuhi prasyarat. Skill matang menjadi Optional Validation, bukan auto-complete.
- Assessment menangkap domain awal dan menolak save bila arah berubah, termasuk perubahan yang diimpor dari CloudKit. Jangan menerima mission dari domain lain.
- Instruksi, evidence, refleksi tersedia offline. Link bacaan eksternal opsional dan diberi keterangan membutuhkan internet.
