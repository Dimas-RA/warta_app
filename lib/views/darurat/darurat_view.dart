import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/top_notification.dart';
import '../../models/darurat_model.dart';
import '../../services/darurat_service.dart';

class DaruratView extends StatefulWidget {
  const DaruratView({super.key});

  @override
  State<DaruratView> createState() => _DaruratViewState();
}

class _DaruratViewState extends State<DaruratView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  int _countdown = 7;
  bool _isCancelled = false;
  bool _isSent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _triggerEmergency();
      }
    });
  }

  void _triggerEmergency() {
    if (_isCancelled || _isSent) return;
    setState(() {
      _isSent = true;
      _controller.stop(); // Berhenti berdetak
    });
    TopNotification.show(
      context: context,
      message: "Sinyal Darurat TRACE Dikirim!",
      isError: true,
    );
  }

  void _cancelEmergency() {
    _timer?.cancel();
    setState(() {
      _isCancelled = true;
      _controller.stop();
    });
    TopNotification.show(
      context: context,
      message: "Sinyal Darurat Dibatalkan",
      isSuccess: true,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 0, 0), // Merah pekat
      body: SafeArea(
        child: Column(
          children: [
            // TOMBOL KEMBALI
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ), // Memberikan jarak dari tombol back
                  const Text(
                    "TOMBOL DARURAT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tekan ini jika Anda dalam bahaya!",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // PANIC BUTTON DENGAN ANIMASI PULSE
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isSent || _isCancelled ? 1.0 : _animation.value,
                        child: GestureDetector(
                          onTap: () {
                            if (_isCancelled || _isSent) return;
                            _timer?.cancel();
                            _triggerEmergency();
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Colors.redAccent,
                                  Color.fromARGB(255, 170, 0, 0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  blurRadius: 30 * _animation.value,
                                  spreadRadius: 10 * _animation.value,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isSent
                                  ? Icons.check_circle
                                  : (_isCancelled
                                        ? Icons.cancel
                                        : Icons.warning_rounded),
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // CANCEL BUTTON
                  if (!_isCancelled && !_isSent)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 100, 0, 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _cancelEmergency,
                      child: Text(
                        "BATALKAN ($_countdown detik)",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  if (_isSent)
                    const Text(
                      "Darurat telah aktif.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (_isCancelled)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Darurat dibatalkan.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                  // LIST KONTAK DARURAT
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kontak Instansi Penting",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: FutureBuilder<List<KontakDaruratModel>>(
                              future: DaruratService().getKontakDarurat(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 100, 0, 0)));
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text("Tidak ada data kontak darurat."));
                                }
                                
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final kontak = snapshot.data![index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey[200]!),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        leading: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 100, 0, 0).withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            IconData(kontak.iconCodePoint, fontFamily: kontak.iconFontFamily),
                                            color: const Color.fromARGB(255, 100, 0, 0),
                                          ),
                                        ),
                                        title: Text(
                                          kontak.namaInstansi,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(kontak.jenisLayanan, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
                                                const SizedBox(width: 4),
                                                Text(kontak.jarak, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.call, color: Colors.green),
                                          onPressed: () {
                                            TopNotification.show(
                                              context: context,
                                              message: "Memanggil ${kontak.nomorTelepon}...",
                                              isSuccess: true,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
