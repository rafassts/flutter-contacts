import 'package:local_auth/local_auth.dart';

class AuthController {
  final _auth = LocalAuthentication();

  Future<bool> _isBiometricAvailable() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      final isAvailable = await _auth.canCheckBiometrics;
      return isDeviceSupported && isAvailable;
    } catch (ex) {
      return false;
    }
  }

  Future _getListOfBiometricTypes() async {
    try {
      await _auth.getAvailableBiometrics();
    } catch (ex) {
      print(ex);
    }
  }

  Future<bool> _authenticateUser() async {
    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: "Autentique-se!",
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return isAuthenticated;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> authenticate() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      return await _authenticateUser();
    }
    return false;
  }
}
