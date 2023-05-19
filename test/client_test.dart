import 'package:test/test.dart';
import 'package:versionary/src/about/about.dart';
import 'package:versionary/src/client/client.dart';
import 'package:versionary/src/client/exception.dart';
import 'package:versionary/src/client/tuid.dart';

void main() {
  // Create an API Client for testing
  final client = ApiClient(
    hostName: 'api-staging.versionary.net',
  );

  // Test the API Client
  group('ApiClient', () {
    test('should create an ApiClient', () {
      expect(client, isNotNull);
    });
  });

  // Test the About API calls
  group('About', () {
    test('should get the About info', () async {
      About a = await client.about();
      expect(a.name, contains('Versionary'));
      expect(a.baseDomain, equals('versionary.net'));
      expect(a.gitHash, isNotEmpty);
      expect(a.buildTime, isNotNull);
      expect(a.language, contains('go'));
      expect(a.environment, equals('staging'));
      expect(a.description, contains('Versionary API'));
    });
  });

  // Test TUID API calls
  group('TUIDs', () {
    test('should create a TUID', () async {
      TUIDInfo t = await client.createTUID();
      expect(t.id, isNotEmpty);
      expect(t.timestamp, isNotNull);
      expect(t.entropy, isNotNull);
      expect(t.entropy, isPositive);
    });
    test('should create multiple TUIDs', () async {
      List<TUIDInfo> t = await client.createTUIDs(5);
      expect(t.length, equals(5));
      for (var i = 0; i < t.length; i++) {
        expect(t[i].id, isNotEmpty);
        expect(t[i].timestamp, isNotNull);
        expect(t[i].entropy, isNotNull);
        expect(t[i].entropy, isPositive);
      }
    });
    test('should parse a TUID', () async {
      TUIDInfo info = TUIDInfo(
        id: '9OdW21Xy3gNiynPw',
        timestamp: DateTime.parse('2023-04-24T21:39:20.935158442Z'),
        entropy: 552061708,
      );
      TUIDInfo t = await client.parseTUID(info.id);
      expect(t.id, equals(info.id));
      expect(t.timestamp, equals(info.timestamp));
      expect(t.entropy, equals(info.entropy));
    });
    test('should fail to parse an invalid TUID', () async {
      try {
        await client.parseTUID('invalid');
      } catch (e) {
        expect(e, isNotNull);
        expect(e, isA<ApiException>());
        ApiException apiException = e as ApiException;
        expect(apiException.code, equals(400));
        expect(apiException.message, isNotEmpty);
      }
    });
  });

  // Close the API Client
  client.close();
}
