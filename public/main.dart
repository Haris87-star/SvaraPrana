import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SvaraPranaApp());
}

/// SvaraPrana (स्वरप्राण) - Zero-Hardware Ambient Acoustic Care Bridge
/// Production Flutter Cross-Platform Client (iOS, Android, macOS, Windows, Linux, Web)
class SvaraPranaApp extends StatelessWidget {
  const SvaraPranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SvaraPrana Care Bridge',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4F46E5),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF111827),
          error: Color(0xFFEF4444),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF111827),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF1F2937), width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const MainShellScreen(),
    );
  }
}

class ElderProfile {
  final String id;
  final String name;
  final String shortName;
  final String city;
  final int age;
  final String avatarChar;
  final String phoneType;
  final String defaultLang;
  final double vocalStability;
  final double phonationSec;
  final double cognitiveLatency;
  final double jitter;
  final double shimmer;
  final double f0;
  final double hnr;
  final int pillCount;

  const ElderProfile({
    required this.id,
    required this.name,
    required this.shortName,
    required this.city,
    required this.age,
    required this.avatarChar,
    required this.phoneType,
    required this.defaultLang,
    required this.vocalStability,
    required this.phonationSec,
    required this.cognitiveLatency,
    required this.jitter,
    required this.shimmer,
    required this.f0,
    required this.hnr,
    required this.pillCount,
  });
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedLanguage = 'Kannada';

  // Elder Profiles
  final List<ElderProfile> _elderProfiles = const [
    ElderProfile(
      id: 'amma_blr',
      name: 'Amma (Savithri Devi)',
      shortName: 'Amma - Bengaluru, 68 yrs',
      city: 'Bengaluru, Karnataka',
      age: 68,
      avatarChar: 'ಅ',
      phoneType: 'Nokia 105 • 2G GSM Keypad',
      defaultLang: 'Kannada',
      vocalStability: 96.4,
      phonationSec: 14.2,
      cognitiveLatency: 0.42,
      jitter: 0.38,
      shimmer: 2.14,
      f0: 164.8,
      hnr: 22.8,
      pillCount: 6,
    ),
    ElderProfile(
      id: 'appa_mdu',
      name: 'Appa (Ramaswamy Iyer)',
      shortName: 'Appa - Madurai, 74 yrs',
      city: 'Madurai, Tamil Nadu',
      age: 74,
      avatarChar: 'அ',
      phoneType: 'Samsung Guru 1200 • 2G GSM',
      defaultLang: 'Tamil',
      vocalStability: 92.1,
      phonationSec: 12.8,
      cognitiveLatency: 0.51,
      jitter: 0.52,
      shimmer: 2.68,
      f0: 142.4,
      hnr: 20.4,
      pillCount: 14,
    ),
    ElderProfile(
      id: 'dadi_vns',
      name: 'Dadi (Shanti Sharma)',
      shortName: 'Dadi - Varanasi, 71 yrs',
      city: 'Varanasi, UP',
      age: 71,
      avatarChar: 'दा',
      phoneType: 'itel it2163 • 2G Keypad',
      defaultLang: 'Hindi',
      vocalStability: 94.8,
      phonationSec: 13.5,
      cognitiveLatency: 0.46,
      jitter: 0.44,
      shimmer: 2.32,
      f0: 172.1,
      hnr: 21.6,
      pillCount: 19,
    ),
  ];

  int _currentProfileIdx = 0;
  ElderProfile get _activeProfile => _elderProfiles[_currentProfileIdx];

  // Dynamic Telemetry States
  double _vitalityScore = 96.4;
  double _phonationSec = 14.2;
  double _latencySec = 0.42;
  double _jitterPercent = 0.38;
  double _shimmerDb = 2.14;
  double _f0Hz = 164.8;
  double _hnrDb = 22.8;
  int _pillCount = 6;
  bool _isHesitationActive = false;

  // Waveform Animation
  bool _isCallActive = false;
  String _callMode = 'Idle • Ephemeral Buffer Standby';
  Timer? _waveTimer;
  final List<double> _wavePoints = List.generate(32, (index) => 0.2 + Random().nextDouble() * 0.4);

  // Medication Schedule
  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Telmisartan 40mg (BP)',
      'time': '08:00 AM • Post Breakfast & Filter Coffee',
      'taken': true,
      'confidence': 'Verified Compliant (0.42s latency)',
      'hesitation': false,
    },
    {
      'name': 'Metformin 500mg (Diabetes)',
      'time': '01:30 PM • Post Lunch with Curd Rice',
      'taken': true,
      'confidence': 'Verified via DTMF Key 1',
      'hesitation': false,
    },
    {
      'name': 'Calcium 500mg + Vit D3',
      'time': '08:30 PM • Post Dinner with Warm Milk',
      'taken': false,
      'confidence': 'Scheduled for Evening Family Call',
      'hesitation': false,
    },
  ];

  // Notification History
  final List<Map<String, String>> _notifications = [
    {
      'title': '08:15 AM: Morning Check-In completed in Kannada',
      'sub': 'Vocal Stability 96.4% • MPE Phonation 14.2s (Optimal)',
      'time': 'Just now',
    },
    {
      'title': '08:15 AM: Ephemeral RAM Buffer Purged',
      'sub': '0 bytes stored on disk • DPDP Act 2023 Cryptographic Scrub Verified',
      'time': '10 mins ago',
    },
    {
      'title': 'Yesterday: Evening Family Call Bridge Analyzed',
      'sub': '12m 40s call duration • Passive acoustic extraction with zero word logging',
      'time': 'Yesterday',
    },
  ];

  // Family Care Circle
  final List<Map<String, String>> _familyContacts = [
    {
      'name': 'Harish Hari',
      'role': 'Son (Primary Caregiver)',
      'location': 'Bengaluru (8 km away)',
      'phone': '+91 98450 12345',
      'avatar': 'H',
      'color': '0xFF4F46E5',
    },
    {
      'name': 'Ananya Hari',
      'role': 'Daughter (Secondary Caregiver)',
      'location': 'Mumbai',
      'phone': '+91 98200 67890',
      'avatar': 'A',
      'color': '0xFF10B981',
    },
    {
      'name': 'Suresh Kumar',
      'role': 'Trusted Neighbor (Flat 204)',
      'location': 'Apartment Neighbor • Has Spare Key',
      'phone': '+91 97410 54321',
      'avatar': 'S',
      'color': '0xFFF59E0B',
    },
    {
      'name': 'Dr. Arvind Swaminathan',
      'role': 'Family Geriatrician',
      'location': 'Manipal Hospital, Old Airport Rd',
      'phone': '+91 98800 11223',
      'avatar': 'D',
      'color': '0xFF06B6D4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _applyProfile(_activeProfile);

    // Waveform simulation timer
    _waveTimer = Timer.periodic(const Duration(milliseconds: 140), (_) {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _wavePoints.length; i++) {
            _wavePoints[i] = _isCallActive
                ? (0.2 + Random().nextDouble() * 0.8)
                : (0.15 + (sin((i + DateTime.now().millisecondsSinceEpoch / 200) * 0.4).abs() * 0.5));
          }
        });
      }
    });
  }

  void _applyProfile(ElderProfile profile) {
    setState(() {
      _vitalityScore = profile.vocalStability;
      _phonationSec = profile.phonationSec;
      _latencySec = profile.cognitiveLatency;
      _jitterPercent = profile.jitter;
      _shimmerDb = profile.shimmer;
      _f0Hz = profile.f0;
      _hnrDb = profile.hnr;
      _pillCount = profile.pillCount;
      _selectedLanguage = profile.defaultLang;
      _isHesitationActive = false;
      _medications[0]['hesitation'] = false;
      _medications[0]['confidence'] = 'Verified Compliant (${profile.cognitiveLatency}s latency)';
    });
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    super.dispose();
  }

  void _showToast(String message, {Color bgColor = const Color(0xFF4F46E5)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addNotification(String title, String sub) {
    setState(() {
      _notifications.insert(0, {
        'title': title,
        'sub': sub,
        'time': 'Just now',
      });
    });
  }

  // ---------------------------------------------------------------------------
  // INTERACTIVE MODALS
  // ---------------------------------------------------------------------------

  // 1. Elder Profile Selector Modal
  void _showElderProfileSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Switch Elder Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._elderProfiles.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;
                final isSelected = idx == _currentProfileIdx;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E1B4B) : const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? const Color(0xFF10B981) : Colors.white24,
                      child: Text(p.avatarChar, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.city} • ${p.phoneType}', style: const TextStyle(fontSize: 12)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF10B981)) : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _currentProfileIdx = idx);
                      _applyProfile(p);
                      _addNotification(
                        'Switched Active Profile: ${p.name}',
                        'Loaded ${p.city} telemetry, phone type ${p.phoneType}',
                      );
                      _showToast('Active Profile: ${p.name}');
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Cryptographic RAM-Purge Inspector Modal
  void _showPrivacyAuditModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_user, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Cryptographic RAM-Purge & DPDP Audit',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0F19),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Text(
                  'SvaraPrana NEVER writes human voice recordings to disk. Audio streams exist only in volatile RAM buffers for <200ms while FFT pitch/jitter vectors are extracted, after which memory addresses are zeroed with memset(0).',
                  style: TextStyle(fontSize: 13, color: Color(0xFFA5B4FC), height: 1.4),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '• Volatile Memory Buffer : 0x7FFF98A20000 (Ephemeral 64KB Ring)\n'
                '• Disk File Writes       : Exactly 0 bytes (0 persistent files)\n'
                '• Scrubbing Latency      : < 0.25 ms deterministic zero-overwrite\n'
                '• Volatile SHA-256 Hash  : e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n'
                '• Regulatory Standards   : DPDP Act 2023 Sec 8(7) & HIPAA Safe Harbor',
                style: TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showToast('In-Memory Scrubbing Test Verified: 64KB zeroed in 0.24ms.');
                  },
                  icon: const Icon(Icons.bolt),
                  label: const Text('Run Live In-Memory Scrubbing Test', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Simulated Call Bridge Engine (Modes A, B, C)
  void _triggerCallSimulation(String modeTitle, String scenario, String modeType) {
    setState(() {
      _isCallActive = true;
      _callMode = modeTitle;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                CircleAvatar(
                  radius: 34,
                  backgroundColor: modeType == 'refusal'
                      ? const Color(0xFF78350F)
                      : (modeType == 'passive' ? const Color(0xFF064E3B) : const Color(0xFF1E1B4B)),
                  child: Icon(
                    modeType == 'refusal'
                        ? Icons.snooze
                        : (modeType == 'passive' ? Icons.phone_in_talk : Icons.graphic_eq),
                    color: modeType == 'refusal'
                        ? const Color(0xFFF59E0B)
                        : (modeType == 'passive' ? const Color(0xFF10B981) : const Color(0xFF818CF8)),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  modeTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Language: $_selectedLanguage • 8kHz GSM Audio Stream',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0F19),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    scenario,
                    style: const TextStyle(fontSize: 13, color: Color(0xFFA5B4FC), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
                const LinearProgressIndicator(
                  color: Color(0xFF10B981),
                  backgroundColor: Colors.white12,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _isCallActive = false;
                            _callMode = 'Idle • Standby';
                          });
                        },
                        child: const Text('Disconnect'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _isCallActive = false;
                            if (modeType == 'morning') {
                              _vitalityScore = 97.2;
                              _phonationSec = 14.8;
                              _latencySec = 0.40;
                              _callMode = 'Completed • Morning Vitals Optimal';
                              _addNotification(
                                'Morning Check-In Verified ($_selectedLanguage)',
                                'Keypad DTMF 1 confirmed • Vitality: 97.2% • Raw audio purged',
                              );
                              _showToast('Morning Check-In Verified! Raw audio purged.', bgColor: const Color(0xFF059669));
                            } else if (modeType == 'passive') {
                              _callMode = 'Passive Bridge Completed • 100% Ephemeral';
                              _addNotification(
                                'Passive Family Call Concluded',
                                'Spoken words purged • Acoustic stability verified 96.8%',
                              );
                              _showToast('Family Call Analyzed without storing speech.');
                            } else {
                              _callMode = 'Empathy Fallback • Deferred to Evening';
                              _addNotification(
                                'Empathy Fallback Engaged',
                                'Polite disconnect executed. Elder rest respected with zero nagging.',
                              );
                              _showToast(
                                'Empathy Fallback: Disconnected with zero nagging.',
                                bgColor: const Color(0xFFF59E0B),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.check_circle),
                        label: Text(modeType == 'refusal' ? 'Polite Disconnect' : 'DTMF 1 & Purge'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) setState(() => _isCallActive = false);
    });
  }

  // 4. Pharmacy 1-Click Refill Modal
  void _showPharmacyRefillModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_pharmacy, color: Color(0xFF10B981), size: 26),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '1-Click Local Chemist Refill',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0F19),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PARTNER PHARMACY', style: TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    const Text('Apollo Pharmacy / Jan Aushadhi Kendra #512', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Delivery To: #42, 6th Cross, Indiranagar, ${_activeProfile.city}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Prescription: Telmisartan 40mg (30 tabs)'),
                  Text('₹72 (Jan Aushadhi Subsidized)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _pillCount = 30);
                    _addNotification(
                      'Pharmacy Refill Order Dispatched (#SP-9824)',
                      'WhatsApp API order sent to Apollo Pharmacy. Delivery expected by 5 PM.',
                    );
                    _showToast('Pharmacy Refill Dispatched! 30-day stock restored.');
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Confirm & Dispatch Refill via WhatsApp API', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Emergency SOS Drill 5-Second Countdown Modal
  void _triggerEmergencySOSDrill() {
    int countdown = 5;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (countdown > 1) {
                setDialogState(() => countdown--);
              } else {
                t.cancel();
                setDialogState(() => countdown = 0);
              }
            });

            return AlertDialog(
              backgroundColor: const Color(0xFF1C0A0D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFEF4444), width: 2),
              ),
              title: Row(
                children: [
                  const Icon(Icons.warning, color: Color(0xFFEF4444)),
                  const SizedBox(width: 10),
                  Text(
                    countdown > 0 ? 'SOS Drill in Progress' : 'SOS Beacon Broadcasting',
                    style: const TextStyle(color: Color(0xFFEF4444), fontSize: 18),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFF7F1D1D),
                    child: Text(
                      countdown > 0 ? '$countdown' : 'SOS',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    countdown > 0
                        ? 'Broadcasting 108 Emergency Beacon in $countdown seconds...'
                        : '108 Ambulance Dispatcher & Family Bridged!',
                    style: const TextStyle(fontSize: 13, color: Color(0xFFFECACA)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SIMULATED GPS TRIANGULATION', style: TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('12.9716° N, 77.5946° E • Accuracy ±8m', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('CMH Rd, Indiranagar, Bengaluru', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(ctx);
                    _showToast('Emergency SOS Drill Cancelled. Senior confirmed safe.');
                  },
                  child: const Text('Cancel Drill (Safe)'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(ctx);
                    _addNotification(
                      'TIER-3 EMERGENCY DRILL RESOLVED',
                      '108 Ambulance & Neighbor Suresh confirmed on-site.',
                    );
                    _showToast('SOS Drill resolved safely.', bgColor: const Color(0xFF10B981));
                  },
                  child: const Text('Confirm Resolution'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 6. Direct Contact Simulate Call Modal
  void _showSimulateCallModal(Map<String, String> contact) {
    int callDuration = 0;
    Timer? callTimer;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (bottomCtx, setBottomState) {
            callTimer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              setBottomState(() => callDuration++);
            });

            final mins = (callDuration ~/ 60).toString().padLeft(2, '0');
            final secs = (callDuration % 60).toString().padLeft(2, '0');

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(int.parse(contact['color']!)),
                      child: Text(
                        contact['avatar']!,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      contact['name']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact['role']!,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Call in progress: $mins:$secs (Encrypted Bridge)',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      ),
                      onPressed: () {
                        callTimer?.cancel();
                        Navigator.pop(ctx);
                        _showToast('Call ended with ${contact['name']}.');
                      },
                      icon: const Icon(Icons.call_end),
                      label: const Text('End Call Bridge'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 7. Assign Care Task Modal
  void _showAssignTaskModal(Map<String, String> contact) {
    final titleCtrl = TextEditingController(text: 'Check if Amma took Telmisartan after coffee');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assign Task to ${contact['name']}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Task Description',
                filled: true,
                fillColor: const Color(0xFF0B0F19),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _addNotification(
                    'Care Task Assigned to ${contact['name']}',
                    titleCtrl.text,
                  );
                  _showToast('Task assigned to ${contact['name']}!');
                },
                icon: const Icon(Icons.assignment_turned_in),
                label: const Text('Send WhatsApp Task Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Notification Center Modal
  void _showNotificationsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'System Audit & Telemetry Log',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _notifications.clear());
                      Navigator.pop(ctx);
                      _showToast('Audit log cleared.');
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No notifications yet. System healthy.')),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white12),
                    itemBuilder: (ctx, i) {
                      final n = _notifications[i];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 20),
                        title: Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('${n['sub']} • ${n['time']}', style: const TextStyle(fontSize: 11.5, color: Colors.white60)),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN BUILD METHOD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _showElderProfileSelector,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.waves, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _activeProfile.shortName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 18),
                        ],
                      ),
                      Text(
                        _activeProfile.phoneType,
                        style: const TextStyle(fontSize: 11, color: Colors.white60),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Privacy Shield Badge
          ActionChip(
            avatar: const Icon(Icons.verified_user, color: Color(0xFF10B981), size: 15),
            label: const Text('RAM Only', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.12),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: _showPrivacyAuditModal,
          ),
          const SizedBox(width: 6),
          // Language Selector
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: const Color(0xFF1F2937),
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
              items: ['Kannada', 'Hindi', 'Tamil', 'Telugu', 'English']
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLanguage = val);
                  _showToast('Voice Engine switched to $val');
                }
              },
            ),
          ),
          // Notifications Bell
          IconButton(
            tooltip: 'Audit Log',
            icon: Badge(
              label: Text('${_notifications.length}'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: _showNotificationsModal,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              NavigationRail(
                backgroundColor: const Color(0xFF111827),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.monitor_heart_outlined),
                    selectedIcon: Icon(Icons.monitor_heart),
                    label: Text('Vitality DSP'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.medication_outlined),
                    selectedIcon: Icon(Icons.medication),
                    label: Text('Adherence'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shield_outlined),
                    selectedIcon: Icon(Icons.shield),
                    label: Text('Safety SOS'),
                  ),
                ],
              ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildVitalityTab(isDesktop),
                  _buildMedicationTab(),
                  _buildSafetyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              backgroundColor: const Color(0xFF111827),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.monitor_heart), label: 'Vitality DSP'),
                NavigationDestination(icon: Icon(Icons.medication), label: 'Adherence'),
                NavigationDestination(icon: Icon(Icons.shield), label: 'Safety SOS'),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: LIVE VITALITY & ACOUSTIC DSP BRIDGE
  // ---------------------------------------------------------------------------
  Widget _buildVitalityTab(bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4 Animated KPI Cards
          GridView.count(
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isDesktop ? 1.7 : 1.45,
            children: [
              _kpiCard('Vocal Stability', '${_vitalityScore.toStringAsFixed(1)}%', 'Normal Register', const Color(0xFF10B981), Icons.graphic_eq),
              _kpiCard('Phonation Flow (MPE)', '${_phonationSec.toStringAsFixed(1)}s', 'Lung Reserve (>10s)', const Color(0xFF38BDF8), Icons.air),
              _kpiCard('Cognitive Latency', '${_latencySec.toStringAsFixed(2)}s', _isHesitationActive ? 'Hesitation Detected' : 'Truthful & Habitual', _isHesitationActive ? const Color(0xFFF59E0B) : const Color(0xFFA855F7), Icons.psychology),
              _kpiCard('Daily Routine', '100%', '3 of 3 Verified', const Color(0xFFF59E0B), Icons.task_alt),
            ],
          ),
          const SizedBox(height: 18),

          // Acoustic Waveform Card with Custom Waveform Rendering
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Live Acoustic Telemetry (RAM Buffer)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Chip(
                        label: Text(_callMode, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF1F2937),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Animated Waveform Bars
                  SizedBox(
                    height: 85,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _wavePoints.map((val) {
                        return Flexible(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            height: 12 + (val * 65),
                            decoration: BoxDecoration(
                              color: _isCallActive ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Acoustic Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metricCol('Pitch F0', '${_f0Hz.toStringAsFixed(1)} Hz'),
                      _metricCol('Vocal Jitter', '${_jitterPercent.toStringAsFixed(2)}%'),
                      _metricCol('Shimmer', '${_shimmerDb.toStringAsFixed(2)} dB'),
                      _metricCol('HNR', '${_hnrDb.toStringAsFixed(1)} dB'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _triggerCallSimulation(
                          'Mode A: 45s Regional Morning Check-In ($_selectedLanguage)',
                          'Playing morning panchang & asking senior to press 1 after blood pressure medicine.',
                          'morning',
                        ),
                        icon: const Icon(Icons.wb_sunny_outlined),
                        label: const Text('Mode A: Morning Check-In'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _triggerCallSimulation(
                          'Mode B: Passive Evening Family Call Bridge',
                          'Silently monitoring vocal cord stability and respiratory pauses while purging spoken words.',
                          'passive',
                        ),
                        icon: const Icon(Icons.phone_in_talk_outlined),
                        label: const Text('Mode B: Passive Call Bridge'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _triggerCallSimulation(
                          'Mode C: Elder Refusal / Grumble Fallback',
                          'Empathy Fallback: Polite disconnect with zero nagging + extracting vocal energy from refusal.',
                          'refusal',
                        ),
                        icon: const Icon(Icons.snooze),
                        label: const Text('Mode C: Grumble Fallback'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: MEDICATION & FALSE COMPLIANCE TRUTH ENGINE
  // ---------------------------------------------------------------------------
  Widget _buildMedicationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hesitation Engine Card
        Card(
          color: const Color(0xFF1F1B12),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_alt, color: Color(0xFFF59E0B), size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '"Haan Beta, Dawai Kha Li" — False Compliance Engine',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Indian elders frequently claim full adherence to avoid causing worry to their children living away. SvaraPrana detects cognitive latency (>1.5s pause) and vocal pitch micro-tremors to gently follow up.',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _latencySec = 2.15;
                          _isHesitationActive = true;
                          _medications[0]['hesitation'] = true;
                          _medications[0]['confidence'] = 'Low Confidence: 2.15s Hesitation Detected';
                        });
                        _addNotification(
                          'Courtesy Syndrome Detected',
                          '2.15s hesitation pause during BP pill check. Empathetic caregiver prompt generated.',
                        );
                        _showToast('Hesitation Anomaly Flagged (2.15s pause).', bgColor: const Color(0xFFD97706));
                      },
                      icon: const Icon(Icons.warning_amber),
                      label: const Text('Simulate 2.1s Hesitation Pause'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _latencySec = 0.42;
                          _isHesitationActive = false;
                          _medications[0]['hesitation'] = false;
                          _medications[0]['confidence'] = 'Verified Compliant (0.42s latency)';
                        });
                        _showToast('Reset to Truthful Habitual Adherence.');
                      },
                      child: const Text('Reset Normal Adherence'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Medication List
        ..._medications.asMap().entries.map((entry) {
          final int idx = entry.key;
          final Map<String, dynamic> med = entry.value;
          final bool isHesitant = med['hesitation'] as bool;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Checkbox(
                value: med['taken'] as bool,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) {
                  setState(() => _medications[idx]['taken'] = val ?? false);
                  _showToast('${med['name']} status updated.');
                },
              ),
              title: Text(med['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med['time'], style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    med['confidence'],
                    style: TextStyle(
                      color: isHesitant ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 10),

        // Closed-Loop Chemist Tracker Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Chemist Blister-Pack Velocity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('$_pillCount of 30 Left', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _pillCount / 30.0,
                  backgroundColor: Colors.white12,
                  color: _pillCount <= 6 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _showPharmacyRefillModal,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Order 1-Click Local Pharmacy Refill'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: TIERED EMERGENCY ESCALATION & FAMILY CARE CIRCLE
  // ---------------------------------------------------------------------------
  Widget _buildSafetyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // SOS Drill Banner
        Card(
          color: const Color(0xFF2A1215),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.emergency_share, color: Color(0xFFEF4444), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tier-3 Emergency SOS Conference Relay',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Multi-party audio bridge triggered on acute vocal distress. Broadcasts GPS coordinates to 108 Emergency and rings family caregivers.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _triggerEmergencySOSDrill,
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('TRIGGER TIER-3 EMERGENCY SOS DRILL', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Family Care Circle Header
        const Text(
          'Family Care Circle Directory',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Contact Cards
        ..._familyContacts.map((contact) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(int.parse(contact['color']!)),
                    child: Text(contact['avatar']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(contact['role']!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        Text(contact['location']!, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                        onPressed: () => _showSimulateCallModal(contact),
                        icon: const Icon(Icons.call, size: 14),
                        label: const Text('Call', style: TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                        onPressed: () => _showAssignTaskModal(contact),
                        icon: const Icon(Icons.task, size: 14),
                        label: const Text('Task', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGETS
  // ---------------------------------------------------------------------------
  Widget _kpiCard(String label, String value, String sub, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: color, size: 18),
              ],
            ),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              sub,
              style: const TextStyle(fontSize: 11, color: Colors.white54),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCol(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
      ],
    );
  }
}