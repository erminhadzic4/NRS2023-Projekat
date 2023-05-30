import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nrs2023/auth_provider.dart';
//import 'package:mocktail/mocktai.dart';

void main() {
  test('setToken updates token and notifies listeners', () {
    final authProvider = AuthProvider();
    final listener = ListenerMock();

    // Pretplatite listener na authProvider
    authProvider.addListener(listener.onNotify);

    // Provera da li je token na početku prazan
    expect(authProvider.token, '');

    // Pozov setToken sa novom vrednošću
    final newToken = 'example_token';
    authProvider.setToken(newToken);

    // Azuriranje tokena
    expect(authProvider.token, newToken);

    // Provjera da li je listener bio obavešten o promjeni
    expect(listener.notified, true);
  });
}

// Mock klasa za testiranje listenera
class ListenerMock {
  bool notified = false;

  void onNotify() {
    notified = true;
  }
}

