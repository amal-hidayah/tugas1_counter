import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CounterApp());
}

// ============================================================================
//  KONFIGURASI IDENTITAS  ->  GANTI BAGIAN INI SAJA
// ============================================================================
class DataMahasiswa {
  /// Nama lengkap yang tampil di AppBar dan kartu identitas.
  static const String nama = 'Amal Hidayah';

  /// Nomor Induk Mahasiswa.
  static const String nim = '20240040100';

  /// Program Studi.
  static const String prodi = 'Teknik Informatika';

  /// Kelas / golongan.
  static const String kelas = 'TI24G';

  /// Judul di depan AppBar.
  static const String judulAppBar = 'PPM Sesi 1';

  /// Ikon pada kartu identitas.
  static const IconData ikon = Icons.school_rounded;
}

// ============================================================================
//  PALET WARNA TEMA (EMERALD / HIJAU)
// ============================================================================
class TemaWarna {
  static const Color primer = Color(0xFF059669); // Emerald 600
  static const Color primerGelap = Color(0xFF065F46); // Emerald 800
  static const Color primerTerang = Color(0xFF10B981); // Emerald 500
  static const Color latar = Color(0xFFF0FDF4); // Emerald 50

  /// Warna angka saat genap.
  static const Color genap = Color(0xFF059669);

  /// Warna angka saat ganjil.
  static const Color ganjil = Color(0xFFEA580C); // Orange 600

  static const Color teksGelap = Color(0xFF064E3B);
  static const Color teksMuted = Color(0xFF6B7280);
}

// ============================================================================
//  APLIKASI
// ============================================================================
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter ${DataMahasiswa.judulAppBar}',
      debugShowCheckedModeBanner: false,

      // Ganti warna tema bawaan (hijau) dengan tema Emerald kita.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TemaWarna.primer,
          primary: TemaWarna.primer,
          secondary: TemaWarna.primerTerang,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: TemaWarna.latar,
        appBarTheme: const AppBarTheme(
          backgroundColor: TemaWarna.primer,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF7F1D1D),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),

      home: const HalamanCounter(),
    );
  }
}

// ============================================================================
//  HALAMAN COUNTER
// ============================================================================
class HalamanCounter extends StatefulWidget {
  const HalamanCounter({super.key});

  @override
  State<HalamanCounter> createState() => _HalamanCounterState();
}

class _HalamanCounterState extends State<HalamanCounter> {
  int _counter = 0;

  bool get _isGenap => _counter % 2 == 0;
  Color get _warnaAngka => _isGenap ? TemaWarna.genap : TemaWarna.ganjil;
  String get _status =>
      _isGenap ? 'Angka Genap' : 'Angka Ganjil';

  // ------------------------------------------------------------------
  //  Aksi tombol
  // ------------------------------------------------------------------
  void _tambah() {
    setState(() => _counter++);
  }

  void _kurang() {
    // Requirement: counter tidak boleh di bawah 0.
    if (_counter == 0) {
      _tampilkanSnackBar(
        pesan: 'Angka tidak boleh kurang dari 0!',
        ikon: Icons.error_outline_rounded,
      );
      return;
    }
    setState(() => _counter--);
  }

  void _reset() {
    if (_counter == 0) {
      _tampilkanSnackBar(
        pesan: 'Counter sudah bernilai 0.',
        ikon: Icons.info_outline_rounded,
      );
      return;
    }
    setState(() => _counter = 0);
    _tampilkanSnackBar(pesan: 'Counter berhasil di-reset.', ikon: Icons.refresh_rounded);
  }

  void _tampilkanSnackBar({required String pesan, required IconData ikon}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          content: Row(
            children: [
              Icon(ikon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pesan,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ------------------------------------------------------------------
  //  Build
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Judul AppBar: "PPM Sesi 1 - Nama (NIM)"
    final String judulAppBar =
        '${DataMahasiswa.judulAppBar} - ${DataMahasiswa.nama} (${DataMahasiswa.nim})';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulAppBar,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const KartuIdentitas(),

              const SizedBox(height: 20),

              // ---- Panel angka counter ----
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _warnaAngka.withValues(alpha: 0.25)),
                  boxShadow: [
                    BoxShadow(
                      color: _warnaAngka.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'NILAI COUNTER',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                        color: TemaWarna.teksMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Angka: warna berubah saat genap/ganjil.
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        fontSize: 88,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: _warnaAngka,
                      ),
                      child: Text('$_counter'),
                    ),

                    const SizedBox(height: 14),

                    // Status: "Angka Genap" / "Angka Ganjil"
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _warnaAngka.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _warnaAngka.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isGenap
                                ? Icons.check_circle_rounded
                                : Icons.bolt_rounded,
                            size: 18,
                            color: _warnaAngka,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _status,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _warnaAngka,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---- Tombol +, -, Reset ----
              Row(
                children: [
                  // Reset
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TemaWarna.primerGelap,
                          side: const BorderSide(
                            color: TemaWarna.primerTerang,
                            width: 1.5,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Tombol -
                  _TombolAksi(
                    label: '-',
                    icon: Icons.remove_rounded,
                    tooltip: 'Kurangi',
                    filled: false,
                    onPressed: _kurang,
                  ),

                  const SizedBox(width: 12),

                  // Tombol +
                  _TombolAksi(
                    label: '+',
                    icon: Icons.add_rounded,
                    tooltip: 'Tambah',
                    filled: true,
                    onPressed: _tambah,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
//  KARTU IDENTITAS
// ============================================================================
class KartuIdentitas extends StatelessWidget {
  const KartuIdentitas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TemaWarna.primerTerang, TemaWarna.primerGelap],
        ),
        boxShadow: [
          BoxShadow(
            color: TemaWarna.primer.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Ikon / avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  DataMahasiswa.ikon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KARTU IDENTITAS',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DataMahasiswa.nama,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),

          _BarisInfo(
            ikon: Icons.badge_rounded,
            label: 'NIM',
            nilai: DataMahasiswa.nim,
          ),
          const SizedBox(height: 10),
          _BarisInfo(
            ikon: Icons.menu_book_rounded,
            label: 'Prodi',
            nilai: DataMahasiswa.prodi,
          ),
          const SizedBox(height: 10),
          _BarisInfo(
            ikon: Icons.groups_rounded,
            label: 'Kelas',
            nilai: DataMahasiswa.kelas,
          ),
        ],
      ),
    );
  }
}

/// Satu baris "ikon + label: nilai" di dalam kartu identitas.
class _BarisInfo extends StatelessWidget {
  const _BarisInfo({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Text(
          ':',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            nilai,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  TOMBOL AKSI (+ / -)
// ============================================================================
class _TombolAksi extends StatelessWidget {
  const _TombolAksi({
    required this.label,
    required this.icon,
    required this.tooltip,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final String tooltip;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color latar = filled ? TemaWarna.primer : Colors.white;
    final Color garis = filled ? TemaWarna.primer : TemaWarna.primerTerang;
    final Color warnaTeks = filled ? Colors.white : TemaWarna.primerGelap;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: latar,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: garis,
                width: filled ? 0 : 1.5,
              ),
            ),
            child: Icon(icon, color: warnaTeks, size: 28),
          ),
        ),
      ),
    );
  }
}
