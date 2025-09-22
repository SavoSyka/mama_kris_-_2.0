class VersionUtils {
  VersionUtils._();

  /// first we Converts version string (e.g., "1.2.3") to an integer (e.g., 10203)
  static int normalizeVersion(String version) {
    final parts = version.split('.');

    // secondly Ensure exactly 3 segments: major.minor.patch
    while (parts.length < 3) {
      parts.add("0");
    }

    final major = int.tryParse(parts[0]) ?? 0;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = int.tryParse(parts[2]) ?? 0;

    // Example: 1.2.3 -> 10203 (1*10000 + 2*100 + 3)
    return major * 10000 + minor * 100 + patch;
  }

  /// 3.  Returns true if server version is greater than app version
  static bool isUpdateRequired(String appVersion, String serverVersion) {
    final app = normalizeVersion(appVersion);
    final server = normalizeVersion(serverVersion);
    return server > app;
  }
}
