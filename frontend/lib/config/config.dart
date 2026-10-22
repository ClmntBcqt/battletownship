class AppConfig {
  static const _backendUrlKey = "BACKEND_URL";
  static const backendUrl = String.fromEnvironment(_backendUrlKey);

  static void validate() {
    if (backendUrl.trim().isEmpty) {
      throw _buildValidationException(_backendUrlKey);
    }
  }

  static StateError _buildValidationException(String key) =>
      StateError("$key is not set");
}
