import 'package:flutter/material.dart';
import 'package:freerasp/freerasp.dart';

/// SecurityGate wraps your app or page to protect against security threats
/// using FreeRASP / Talsec. It blocks access if high severity threats are detected.
class SecurityGate extends StatefulWidget {
  final Widget child; // The real app or page

  const SecurityGate({super.key, required this.child});

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _isChecking = true;
  bool _isAllowed = true;

  @override
  void initState() {
    super.initState();
    _startSecurity();
  }

  // keytool -list -v \
  // -keystore "android/app/new-debug.keystore" \
  // -alias androiddebugkey \
  // -storepass android \
  // -keypass android


  /// Initialize FreeRASP / Talsec
  Future<void> _startSecurity() async {
    try {
      // ── Configure Talsec
      final config = TalsecConfig(
        androidConfig: AndroidConfig(
          packageName: 'com.mama.kris',
          signingCertHashes: [
            "8zRRE5DP5CHZZ1o2635/6Noc+qnEy8P6j1eruoYW9LA="
          ], // required, get from Play Console
        ),
        iosConfig: IOSConfig(
          bundleIds: ['com.mama.kris'], // Update with actual bundle ID
          teamId: 'R6HKJV8SD9', // Update with actual team ID
        ),
        watcherMail: 'security@yourdomain.com',
        isProd: false, // Set false for dev mode
        killOnBypass: true, // Stops the app if bypass is detected
      );

      // ── Start the service
      await Talsec.instance.start(config);

      // ── Subscribe to threats
      Talsec.instance.attachListener(_threatCallback);
    } catch (e, s) {
      debugPrint('⚠️ FreeRASP init error: $e\n$s');
      _isAllowed = true; // Fail open (optional)
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  late final ThreatCallback _threatCallback = ThreatCallback(
    onAppIntegrity: () => _handleLowSeverityThreat("App integrity"),
    onObfuscationIssues: () => _handleLowSeverityThreat("Obfuscation issues"),
    onDebug: () => _handleLowSeverityThreat("Debugging"),
    onDeviceBinding: () => _handleLowSeverityThreat("Device binding"),
    onDeviceID: () => _handleLowSeverityThreat("Device ID"),
    onHooks: () => _handleHighSeverityThreat("Hooks detected"),
    onPasscode: () => _handleLowSeverityThreat("Passcode not set"),
    onPrivilegedAccess: () =>
        _handleHighSeverityThreat("Privileged access (root/jailbreak)"),
    onSecureHardwareNotAvailable: () =>
        _handleLowSeverityThreat("Secure hardware not available"),
    onSimulator: () => _handleHighSeverityThreat("Running on simulator"),
    onSystemVPN: () => _handleLowSeverityThreat("System VPN"),
    onDevMode: () => _handleHighSeverityThreat("Developer mode enabled"),
    onADBEnabled: () => _handleHighSeverityThreat("USB debugging enabled"),
    onUnofficialStore: () =>
        _handleHighSeverityThreat("App installed from unofficial store"),
    onScreenshot: () => _handleLowSeverityThreat("Screenshot taken"),
    onScreenRecording: () => _handleLowSeverityThreat("Screen recording"),
    onMultiInstance: () => _handleLowSeverityThreat("Multi instance"),
    onUnsecureWiFi: () => _handleLowSeverityThreat("Unsecure WiFi"),
    onLocationSpoofing: () => _handleLowSeverityThreat("Location spoofing"),
    onTimeSpoofing: () => _handleLowSeverityThreat("Time spoofing"),
    onMalware: (suspiciousApps) =>
        _handleHighSeverityThreat("Malicious apps detected: $suspiciousApps"),
  );

  void _handleLowSeverityThreat(String threat) {
    debugPrint("⚠️ Low severity threat: $threat");
    // Log but don't block
  }

  void _handleHighSeverityThreat(String threat) {
    debugPrint("🚨 High severity threat: $threat - Blocking access");
    if (mounted) {
      setState(() => _isAllowed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) return _loadingScreen();
    if (!_isAllowed) return _blockedScreen();
    return widget.child;
  }

  Widget _loadingScreen() => const Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    ),
  );

  Widget _blockedScreen() => const Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Access Blocked\nSuspicious Activity Detected",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
