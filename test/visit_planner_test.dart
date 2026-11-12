import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/visit_planner_api.dart';
import 'package:frontend_flutter/screens/visit_planner/visit_planner_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  tearDown(() {
    VisitPlannerApi.clientForTesting = null;
  });

  group('VisitPlannerApi Tests', () {
    test('Mengembalikan rekomendasi berhasil dengan 3 toko', () async {
      final mockResponse = {
        'success': true,
        'message': 'Rekomendasi rute berhasil dibuat',
        'data': {
          'title': 'Rute 1 Jam, Pedas & Hemat',
          'totalEstimatedTime': 60,
          'totalEstimatedCost': 40000,
          'stops': [
            {
              'order': 1,
              'storeId': 2,
              'storeName': 'Bakso Goreng Ayam Bangkit',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 4,
                  'name': 'Bakso Goreng Saus Pedas',
                  'price': 8000,
                  'description': 'Bakso goreng ayam renyah gurih disajikan dengan saus sambal pedas.',
                }
              ],
              'estimatedCost': 8000,
              'estimatedTime': 20,
              'reason': 'Pemberhentian awal di Bakso Goreng Ayam Bangkit di area Blok A untuk menikmati Bakso Goreng Saus Pedas dengan cita rasa Pedas favorit.'
            },
            {
              'order': 2,
              'storeId': 5,
              'storeName': 'Bagoplek Bakso Goreng',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 8,
                  'name': 'Bakso Goreng Sambal Pedas Mercon',
                  'price': 14000,
                  'description': 'Bakso goreng mekar disiram sambal pedas mercon.',
                }
              ],
              'estimatedCost': 14000,
              'estimatedTime': 20,
              'reason': 'Pemberhentian ke-2 di Bagoplek Bakso Goreng dengan pilihan Bakso Goreng Sambal Pedas Mercon bercita rasa Pedas yang lezat.'
            },
            {
              'order': 3,
              'storeId': 4,
              'storeName': 'Pangsit Mie Arema',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 6,
                  'name': 'Pangsit Mie Pedas Spesial',
                  'price': 18000,
                  'description': 'Mie kenyal ayam cincang dan sambal pedas nikmat.',
                }
              ],
              'estimatedCost': 18000,
              'estimatedTime': 20,
              'reason': 'Penutup rute yang pas di Pangsit Mie Arema untuk melengkapi petualangan rasa Pedas dengan Pangsit Mie Pedas Spesial.'
            }
          ]
        }
      };

      VisitPlannerApi.clientForTesting = MockClient((request) async {
        expect(request.url.path, '/api/visit-planner/recommendations');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['availableTime'], 60);
        expect(body['tastePreference'], 'pedas');
        expect(body['budget'], 100000);

        return http.Response(
          jsonEncode(mockResponse),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final res = await VisitPlannerApi.getRecommendations(
        availableTime: 60,
        tastePreference: 'pedas',
        budget: 100000,
      );

      expect(res.success, isTrue);
      expect(res.data, isNotNull);
      expect(res.data!.title, 'Rute 1 Jam, Pedas & Hemat');
      expect(res.data!.totalEstimatedTime, 60);
      expect(res.data!.totalEstimatedCost, 40000);
      expect(res.data!.stops.length, 3);
      expect(res.data!.stops[0].storeName, 'Bakso Goreng Ayam Bangkit');
      expect(res.data!.stops[1].storeName, 'Bagoplek Bakso Goreng');
      expect(res.data!.stops[2].storeName, 'Pangsit Mie Arema');
    });

    test('Menangani respons error 400 dari backend', () async {
      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Validasi input gagal.',
            'errors': ['Budget harus berupa angka positif.']
          }),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      expect(
        () => VisitPlannerApi.getRecommendations(
          availableTime: 60,
          tastePreference: 'pedas',
          budget: -100,
        ),
        throwsA(isA<VisitPlannerApiException>()),
      );
    });

    test('Menangani respons error 500 dari backend', () async {
      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Terjadi kesalahan di server.'
          }),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      expect(
        () => VisitPlannerApi.getRecommendations(
          availableTime: 60,
          tastePreference: 'pedas',
          budget: 100000,
        ),
        throwsA(isA<VisitPlannerApiException>()),
      );
    });
  });

  group('VisitPlannerScreen Widget Tests', () {
    testWidgets('Menampilkan form awal dan hasil rekomendasi 3 toko setelah klik tombol', (tester) async {
      final mockResponse = {
        'success': true,
        'message': 'Rekomendasi rute berhasil dibuat',
        'data': {
          'title': 'Rute 1 Jam, Pedas & Hemat',
          'totalEstimatedTime': 60,
          'totalEstimatedCost': 40000,
          'stops': [
            {
              'order': 1,
              'storeId': 2,
              'storeName': 'Bakso Goreng Ayam Bangkit',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 4,
                  'name': 'Bakso Goreng Saus Pedas',
                  'price': 8000,
                  'description': 'Bakso goreng ayam renyah gurih saus sambal pedas.',
                }
              ],
              'estimatedCost': 8000,
              'estimatedTime': 20,
              'reason': 'Pemberhentian awal di Bakso Goreng Ayam Bangkit di area Blok A.'
            },
            {
              'order': 2,
              'storeId': 5,
              'storeName': 'Bagoplek Bakso Goreng',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 8,
                  'name': 'Bakso Goreng Sambal Pedas Mercon',
                  'price': 14000,
                  'description': 'Bakso goreng mekar sambal pedas mercon.',
                }
              ],
              'estimatedCost': 14000,
              'estimatedTime': 20,
              'reason': 'Pemberhentian ke-2 di Bagoplek Bakso Goreng.'
            },
            {
              'order': 3,
              'storeId': 4,
              'storeName': 'Pangsit Mie Arema',
              'category': 'Makanan',
              'zone': 'Blok A',
              'products': [
                {
                  'id': 6,
                  'name': 'Pangsit Mie Pedas Spesial',
                  'price': 18000,
                  'description': 'Mie kenyal ayam cincang dan sambal pedas.',
                }
              ],
              'estimatedCost': 18000,
              'estimatedTime': 20,
              'reason': 'Penutup rute yang pas di Pangsit Mie Arema.'
            }
          ]
        }
      };

      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode(mockResponse),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: VisitPlannerScreen(),
        ),
      );

      // Verifikasi komponen form awal
      expect(find.text('AI Perencana Kunjungan'), findsOneWidget);
      expect(find.text('Waktu Tersedia'), findsOneWidget);
      expect(find.text('Preferensi Rasa'), findsOneWidget);
      expect(find.text('1 Jam'), findsOneWidget);
      expect(find.text('Pedas'), findsOneWidget);
      expect(find.text('Buat Rekomendasi'), findsOneWidget);

      // Tekan tombol Buat Rekomendasi
      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pump(); // Render state loading

      // Selesaikan HTTP async request
      await tester.pumpAndSettle();

      // Verifikasi Judul Rute Hasil Rekomendasi
      expect(find.text('Rute 1 Jam, Pedas & Hemat'), findsOneWidget);

      // Verifikasi Parameter Kunjungan (Waktu, Rasa, Budget tanpa total biaya/sisa budget)
      expect(find.text('Waktu: 1 Jam'), findsOneWidget);
      expect(find.text('Rasa: Pedas'), findsOneWidget);
      expect(find.text('Budget: Rp100.000'), findsWidgets); // Pada label slider & ringkasan hasil AI
      expect(find.text('Rp40.000'), findsNothing); // Total biaya tidak ditampilkan di UI sesuai instruksi

      // Verifikasi Ketiga Toko Muncul
      expect(find.text('Bakso Goreng Ayam Bangkit'), findsOneWidget);
      expect(find.text('Bagoplek Bakso Goreng'), findsOneWidget);
      expect(find.text('Pangsit Mie Arema'), findsOneWidget);

      // Verifikasi Produk & Harga
      expect(find.text('Bakso Goreng Saus Pedas'), findsOneWidget);
      expect(find.text('Rp8.000'), findsOneWidget);
      expect(find.text('Bakso Goreng Sambal Pedas Mercon'), findsOneWidget);
      expect(find.text('Rp14.000'), findsOneWidget);
      expect(find.text('Pangsit Mie Pedas Spesial'), findsOneWidget);
      expect(find.text('Rp18.000'), findsOneWidget);

      // Verifikasi Alasan Rekomendasi
      expect(
        find.text('Pemberhentian awal di Bakso Goreng Ayam Bangkit di area Blok A.'),
        findsOneWidget,
      );
      expect(
        find.text('Pemberhentian ke-2 di Bagoplek Bakso Goreng.'),
        findsOneWidget,
      );
      expect(
        find.text('Penutup rute yang pas di Pangsit Mie Arema.'),
        findsOneWidget,
      );
    });

    testWidgets('Menampilkan pesan error saat koneksi gagal', (tester) async {
      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Terjadi kesalahan pada server.',
          }),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: VisitPlannerScreen(),
        ),
      );

      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pumpAndSettle();

      expect(find.text('Terjadi kesalahan pada server.'), findsOneWidget);
    });

    testWidgets('Menampilkan pesan ketika rekomendasi kosong (budget kurang)', (tester) async {
      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'Budget belum mencukupi untuk rekomendasi produk.',
            'data': {
              'title': 'Rute 1 Jam, Pedas & Hemat',
              'totalEstimatedTime': 0,
              'totalEstimatedCost': 0,
              'stops': []
            }
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: VisitPlannerScreen(),
        ),
      );

      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pumpAndSettle();

      expect(
        find.text('Budget belum mencukupi untuk rekomendasi produk.'),
        findsOneWidget,
      );
    });

    testWidgets('Hasil rekomendasi menampilkan Budget Rp80.000 sesuai respon backend', (tester) async {
      VisitPlannerApi.clientForTesting = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'Rekomendasi rute berhasil dibuat',
            'data': {
              'title': 'Rute 1 Jam, Pedas & Hemat',
              'budget': 80000,
              'totalEstimatedCost': 62000,
              'remainingBudget': 18000,
              'totalEstimatedTime': 60,
              'stops': [
                {
                  'order': 1,
                  'storeId': 2,
                  'storeName': 'Bakso Goreng Ayam Bangkit',
                  'category': 'Makanan',
                  'zone': 'Blok A',
                  'products': [
                    {
                      'id': 4,
                      'name': 'Bakso Goreng Saus Pedas',
                      'price': 8000,
                      'description': 'Bakso goreng ayam renyah saus pedas.',
                    }
                  ],
                  'estimatedCost': 8000,
                  'estimatedTime': 15,
                  'reason': 'Pemberhentian awal menikmati rasa pedas.'
                }
              ]
            }
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: VisitPlannerScreen(),
        ),
      );

      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pumpAndSettle();

      // Verifikasi parameter pengguna tampil di bagian HASIL AI
      expect(find.text('Waktu: 1 Jam'), findsOneWidget);
      expect(find.text('Rasa: Pedas'), findsOneWidget);
      expect(find.text('Budget: Rp80.000'), findsOneWidget);

      // Verifikasi total biaya tidak ditampilkan
      expect(find.text('Rp62.000'), findsNothing);
    });

    testWidgets('Memisahkan draft input dengan submitted recommendation saat input diubah tanpa klik tombol', (tester) async {
      int requestCount = 0;

      VisitPlannerApi.clientForTesting = MockClient((request) async {
        requestCount++;
        final body = jsonDecode(request.body) as Map<String, dynamic>;

        if (requestCount == 1) {
          // Response untuk request pertama (1 Jam, Pedas, 80000)
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Rekomendasi rute 1 berhasil dibuat',
              'data': {
                'title': 'Rute 1 Jam, Pedas & Hemat',
                'budget': 80000,
                'totalEstimatedCost': 76000,
                'totalEstimatedTime': 60,
                'stops': [
                  {
                    'order': 1,
                    'storeId': 2,
                    'storeName': 'Bakso Goreng Ayam Bangkit',
                    'category': 'Makanan',
                    'zone': 'Blok A',
                    'products': [
                      {
                        'id': 4,
                        'name': 'Bakso Goreng Saus Pedas',
                        'price': 8000,
                        'description': 'Pedas sedap.',
                      }
                    ],
                    'estimatedCost': 8000,
                    'estimatedTime': 20,
                    'reason': 'Pemberhentian awal rasa pedas.'
                  }
                ]
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        } else {
          // Response untuk request kedua (30 Menit, Manis)
          expect(body['availableTime'], 30);
          expect(body['tastePreference'], 'manis');
          final reqBudget = (body['budget'] is num) ? (body['budget'] as num).toInt() : 50000;

          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Rekomendasi rute 2 berhasil dibuat',
              'data': {
                'title': 'Rute 30 Menit, Manis & Hemat',
                'budget': reqBudget,
                'totalEstimatedCost': 42000,
                'totalEstimatedTime': 30,
                'stops': [
                  {
                    'order': 1,
                    'storeId': 1,
                    'storeName': 'Lumpur Kentang 27',
                    'category': 'Makanan',
                    'zone': 'Blok A',
                    'products': [
                      {
                        'id': 1,
                        'name': 'Kue Lumpur Kismis',
                        'price': 7000,
                        'description': 'Manis legit.',
                      }
                    ],
                    'estimatedCost': 7000,
                    'estimatedTime': 15,
                    'reason': 'Pemberhentian kue manis.'
                  }
                ]
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: VisitPlannerScreen(),
        ),
      );

      // 1. Set input awal ke Pedas dan Slider ke Rp80.000 (divisi 14 dari 22 = 80000)
      await tester.tap(find.text('Pedas'));
      final sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(-50, 0)); // geser slider
      await tester.pumpAndSettle();

      // 2. Tekan Buat Rekomendasi pertama
      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pumpAndSettle();

      // Verifikasi HASIL AI pertama
      expect(find.text('Rute 1 Jam, Pedas & Hemat'), findsOneWidget);
      expect(find.text('Waktu: 1 Jam'), findsOneWidget);
      expect(find.text('Rasa: Pedas'), findsOneWidget);
      expect(find.text('Budget: Rp80.000'), findsOneWidget);
      expect(find.text('Bakso Goreng Ayam Bangkit'), findsOneWidget);

      // 3. Ubah draft input menjadi 30 Menit dan Manis TANPA menekan tombol Buat Rekomendasi
      await tester.tap(find.text('30 Menit'));
      await tester.tap(find.text('Manis'));
      await tester.pumpAndSettle();

      // 4. Pastikan HASIL AI TIDAK BERUBAH (tetap 1 Jam, Pedas, Rp80.000)
      expect(find.text('Rute 1 Jam, Pedas & Hemat'), findsOneWidget);
      expect(find.text('Waktu: 1 Jam'), findsOneWidget);
      expect(find.text('Rasa: Pedas'), findsOneWidget);
      expect(find.text('Budget: Rp80.000'), findsOneWidget);
      expect(find.text('Bakso Goreng Ayam Bangkit'), findsOneWidget);
      expect(find.text('Lumpur Kentang 27'), findsNothing);

      // 5. Sekarang tekan tombol Buat Rekomendasi untuk mengirim draft input baru
      await tester.ensureVisible(find.text('Buat Rekomendasi'));
      await tester.tap(find.text('Buat Rekomendasi'));
      await tester.pumpAndSettle();

      // 6. Verifikasi HASIL AI sekarang telah berubah sesuai response backend terbaru
      expect(find.text('Rute 30 Menit, Manis & Hemat'), findsOneWidget);
      expect(find.text('Waktu: 30 Menit'), findsOneWidget);
      expect(find.text('Rasa: Manis'), findsOneWidget);
      expect(find.text('Lumpur Kentang 27'), findsOneWidget);
      expect(find.text('Bakso Goreng Ayam Bangkit'), findsNothing);
    });
  });
}
