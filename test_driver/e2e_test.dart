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
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final fetchingTextFinder = find.byValueKey('fetching');
    final storyListFinder = find.byValueKey('story_list');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    // test('renders the "fechting" text', () async {
    //   final txt = await driver.getText(fetchingTextFinder);
    //   print(txt);
    //   expect(txt, "fetching");
    // });

    // test('renders the "story list"', () async {
    //   await Future.delayed(Duration(seconds: 3));
    //   final isExists = await isPresent(storyListFinder, driver);
    //   expect(isExists, true);
    // });
  });
}
