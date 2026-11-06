# Pasar Oro-Oro Dowo

Flutter/Dart implementation of the existing React interface. The app keeps the
mobile layout at a maximum width of 402 px, reuses the source images and SVG
icons, and maps the existing page routes to Flutter screens.

## Run and verify

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

Android emulator memakai `10.0.2.2:4000` secara default; platform lain memakai
`localhost:4000`. Untuk perangkat fisik, berikan alamat komputer Backend saat
menjalankan aplikasi:

```sh
flutter run --dart-define=API_BASE_URL=http://ALAMAT-LAN-KOMPUTER:4000
```

Ganti `ALAMAT-LAN-KOMPUTER` dengan alamat yang dapat dijangkau perangkat.
Konfigurasi hanya berlaku saat aplikasi dijalankan dan tidak disimpan di kode.

## Screens

- Splash and introductory landing page
- Home, store list, and store detail
- Market map, facilities, and visit information
- Promotions, recommendations, and AI visit planner
- Market reviews and market/store review forms

## Data toko

Beranda, daftar toko, dan detail toko membaca data dari Backend melalui
`GET /api/stores` dan `GET /api/stores/:slug`. Endpoint publik hanya
menampilkan toko berstatus `buka` atau `tutup`; toko yang menunggu verifikasi
baru terlihat di Mobile setelah diverifikasi Admin. Jika data belum tersedia,
aplikasi menampilkan status kosong atau pesan gagal dan menyediakan tombol
untuk mencoba kembali. Foto Mobile hanya dipakai jika slug dan nama toko cocok
dengan data Backend; foto tidak diunggah saat sinkronisasi.

Ulasan toko tetap memakai endpoint yang sudah ada, dengan URL dasar yang sama.
