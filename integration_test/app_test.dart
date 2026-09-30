// Uji end-to-end yang berjalan di HP asli (bukan emulator).
// Jalankan:  flutter test integration_test -d aaa9909e0503
//
// Dipakai karena MIUI memblokir `adb shell input tap`
// (INJECT_EVENTS permission), jadi verifikasi harus lewat
// Flutter test binding, bukan injeksi event Android.
//
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tugas1_counter/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SEMUA REQUIREMENT terpenuhi di HP asli', (tester) async {
    await tester.pumpWidget(const CounterApp());
    await tester.pumpAndSettle();

    // ---------- 1. AppBar: "PPM Sesi 1 - Nama (NIM)" ----------
    expect(
      find.text('PPM Sesi 1 - ${DataMahasiswa.nama} (${DataMahasiswa.nim})'),
      findsOneWidget,
    );
    print('OK 1  AppBar = "PPM Sesi 1 - ${DataMahasiswa.nama} (${DataMahasiswa.nim})"');

    // ---------- 2. Kartu identitas (nama, NIM, prodi/kelas, ikon) ----------
    expect(find.byIcon(DataMahasiswa.ikon), findsOneWidget);
    expect(find.text(DataMahasiswa.nama), findsOneWidget);
    expect(find.text(DataMahasiswa.nim), findsWidgets); // AppBar + kartu
    expect(find.text(DataMahasiswa.prodi), findsOneWidget);
    expect(find.text(DataMahasiswa.kelas), findsOneWidget);
    print('OK 2  Kartu identitas = ${DataMahasiswa.nama} | ${DataMahasiswa.nim}'
        ' | ${DataMahasiswa.prodi} | ${DataMahasiswa.kelas}');

    // ---------- 3. Tema hijau (bukan warna bawaan) ----------
    // Context harus diambil dari dalam MaterialApp, karena Theme bekerja ke bawah.
    final tema = Theme.of(tester.element(find.byType(Scaffold)));
    expect(tema.colorScheme.primary, TemaWarna.primer);
    expect(tema.appBarTheme.backgroundColor, TemaWarna.primer);
    print('OK 3  Warna tema = ${_hex(tema.colorScheme.primary)} (hijau Emerald)');

    // ---------- 4. Tombol +, -, Reset tersedia ----------
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    print('OK 4  Tombol +, -, dan Reset tersedia');

    // ---------- 5. Nilai awal 0 dan status genap ----------
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Angka Genap'), findsOneWidget);
    print('OK 5  Awal: angka 0, status "Angka Genap"');

    // ---------- 6. "+" 3x -> 3, status ganjil, warna oranye ----------
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
    }
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Angka Ganjil'), findsOneWidget);
    expect(find.text('Angka Genap'), findsNothing);

    final warnaGanjil = _warnaAngka(tester, '3');
    expect(warnaGanjil, TemaWarna.ganjil);
    print('OK 6  +3x -> angka 3, status "Angka Ganjil", warna ${_hex(warnaGanjil)}');

    // ---------- 7. "-" -> 2, status genap, warna berubah ----------
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Angka Genap'), findsOneWidget);

    final warnaGenap = _warnaAngka(tester, '2');
    expect(warnaGenap, TemaWarna.genap);
    expect(warnaGenap, isNot(warnaGanjil));
    print('OK 7  -1x -> angka 2, status "Angka Genap", '
        'warna ${_hex(warnaGenap)} (beda dari ganjil)');

    // ---------- 8. Turun ke 0, lalu guard anti-negatif ----------
    await tester.tap(find.byIcon(Icons.remove_rounded)); // 2 -> 1
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Angka Ganjil'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_rounded)); // 1 -> 0
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    print('OK 8a Turun ke 0, status "Angka Genap"');

    // Tekan "-" saat 0 -> SnackBar muncul, angka TETAP 0.
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Angka tidak boleh kurang dari 0!'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('-1'), findsNothing);
    print('OK 8b Tekan "-" saat 0 -> SnackBar muncul, angka tetap 0');

    // ---------- 9. Reset ----------
    await tester.pumpAndSettle(); // biarkan SnackBar hilang
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Angka Genap'), findsOneWidget);
    print('OK 9  Reset -> angka 0, status "Angka Genap"');

    // ---------- 10. Tidak ada overflow di layar HP ----------
    expect(tester.takeException(), isNull);
    print('OK 10 Tidak ada overflow / error di layar HP');
  });
}

/// Warna teks angka counter. Angka diwarnai lewat [AnimatedDefaultTextStyle],
/// jadi warnanya dibaca dari ancestor DefaultTextStyle, bukan dari Text.style.
Color _warnaAngka(WidgetTester tester, String angka) {
  final BuildContext ctx = tester.element(find.text(angka));
  return DefaultTextStyle.of(ctx).style.color ?? Colors.transparent;
}

String _hex(Color c) =>
    '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
