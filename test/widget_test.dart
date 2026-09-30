import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tugas1_counter/main.dart';

void main() {
  /// Set ukuran layar sesuai HP Redmi Note 9 (1080x2400, density 2.75)
  /// supaya seluruh tombol terlihat tanpa perlu scroll.
  void gunakanLayarHp(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('Counter naik, turun, dan tidak boleh di bawah 0', (
    WidgetTester tester,
  ) async {
    gunakanLayarHp(tester);
    await tester.pumpWidget(const CounterApp());

    // Nilai awal 0 dan berstatus genap.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Angka Genap'), findsOneWidget);

    // Tekan "+" tiga kali -> 3 (ganjil).
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
    }
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Angka Ganjil'), findsOneWidget);

    // Tekan "-" -> 2 (genap).
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Angka Genap'), findsOneWidget);

    // Tekan "-" lagi -> 1 (ganjil).
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Angka Ganjil'), findsOneWidget);

    // Turun lagi sampai 0.
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);

    // Tekan "-" lagi saat 0 -> SnackBar muncul, angka tetap 0.
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(find.text('Angka tidak boleh kurang dari 0!'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Tombol Reset mengembalikan counter ke 0', (
    WidgetTester tester,
  ) async {
    gunakanLayarHp(tester);
    await tester.pumpWidget(const CounterApp());

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('AppBar menampilkan judul, nama, dan NIM', (
    WidgetTester tester,
  ) async {
    gunakanLayarHp(tester);
    await tester.pumpWidget(const CounterApp());

    expect(
      find.text('PPM Sesi 1 - ${DataMahasiswa.nama} (${DataMahasiswa.nim})'),
      findsOneWidget,
    );
    // Kartu identitas memuat data mahasiswa.
    expect(find.byIcon(DataMahasiswa.ikon), findsOneWidget);
    expect(find.text(DataMahasiswa.nim), findsWidgets);
    expect(find.text(DataMahasiswa.prodi), findsOneWidget);
    expect(find.text(DataMahasiswa.kelas), findsOneWidget);
  });

  testWidgets('Tampilan tidak overflow di layar sempit', (
    WidgetTester tester,
  ) async {
    // Layar kecil (mis. Redmi Note 9 dalam mode font besar).
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CounterApp());
    await tester.pump();

    // Tidak boleh ada error RenderFlex overflow.
    expect(tester.takeException(), isNull);

    // Seluruh konten harus bisa digulir sampai bawah.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
