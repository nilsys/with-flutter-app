// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

isPresent(SerializableFinder byValueKey, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
  } catch (exception) {
    return false;
  }
}

void main() {
  group('Hello World', () {
    final heroHeaderFinder = find.byValueKey('hero_header');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('renders the "login" hero label', () async {
      final txt = await driver.getText(heroHeaderFinder);
      print(txt);
      expect(txt, "Login");
    });

    // test('renders the "story list"', () async {
    //   await Future.delayed(Duration(seconds: 3));
    //   final isExists = await isPresent(storyListFinder, driver);
    //   expect(isExists, true);
    // });
  });
}
