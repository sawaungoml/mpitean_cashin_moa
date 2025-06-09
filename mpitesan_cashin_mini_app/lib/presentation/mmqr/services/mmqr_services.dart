import 'dart:convert';
import 'dart:typed_data';

class MMQRServices {
  /// Generates MMQR text from a map of data
  String generateMMQRText({
    required double amount,
    required Map<String, dynamic> tag26Map,
    required Map<String, dynamic> tag62Map,
    required Map<String, dynamic> tag64Map,
    required String merchantName,
    required String city,
    required String postalCode,
    required String merchantCode,
  }) {
    Map<String, dynamic> mmqrData = {
      '00': '01',
      '01': amount == 0 ? '11' : '12',
      '52': merchantCode,
      '53': '104', // MMK (Myanmar Kyat)
      '58': 'MM',
      '59': merchantName,
      '60': city,
      '61': postalCode,
      '26': tag26Map,
      '62': tag62Map,
      '64': tag64Map,
    };

    if (amount > 0) {
      mmqrData['54'] = amount.toStringAsFixed(2);
    }

    String mmqrText = _buildMMQRString(mmqrData);
    return mmqrText;
  }

  /// Builds MMQR string from data map
  String _buildMMQRString(Map<String, dynamic> data) {
    String result = '';

    // Process each tag in order
    for (var tag in [
      '00',
      '01',
      '26',
      '52',
      '53',
      '54',
      '58',
      '59',
      '60',
      '61',
      '62',
      '64'
    ]) {
      if (data.containsKey(tag)) {
        if (tag == '26' || tag == '62' || tag == '64') {
          // Handle nested tags
          String nestedData = mapValueTag(Map<String, dynamic>.from(data[tag]));
          result += '$tag${countValueLength(nestedData)}$nestedData';
        } else {
          // Handle simple tags
          String value = data[tag].toString();
          result += '$tag${countValueLength(value)}$value';
        }
      }
    }

    // Add CRC
    String crc = _calculateCRC('${result}6304');
    result += '6304$crc';
    return result;
  }

  String mapValueTag(Map<String, dynamic> tagMap) {
    String tagData = '';
    for (var entry in tagMap.entries) {
      String temp =
          '${entry.key}${countValueLength(entry.value.toString())}${entry.value}';
      tagData += temp;
    }
    return tagData;
  }

  String countValueLength(String value) {
    return value.length.toString().padLeft(2, '0');
  }

  /// Parses a MMQR text string and returns a map containing all decoded tags
  Map<String, dynamic> parseMMQRText(String mmqrText) {
    Map<String, dynamic> result = {};
    int currentIndex = 0;

    while (currentIndex < mmqrText.length) {
      // Extract tag ID (2 characters)
      String tagId = mmqrText.substring(currentIndex, currentIndex + 2);
      currentIndex += 2;

      // Extract length (2 characters)
      int length =
          int.parse(mmqrText.substring(currentIndex, currentIndex + 2));
      currentIndex += 2;

      // Extract value
      String value = mmqrText.substring(currentIndex, currentIndex + length);
      currentIndex += length;

      // Special handling for nested tags (26, 62, 64)
      if (tagId == '26' || tagId == '62' || tagId == '64') {
        Map<String, String> nestedTags = {};
        int nestedIndex = 0;

        while (nestedIndex < value.length) {
          String nestedTagId = value.substring(nestedIndex, nestedIndex + 2);
          nestedIndex += 2;

          int nestedLength =
              int.parse(value.substring(nestedIndex, nestedIndex + 2));
          nestedIndex += 2;

          String nestedValue =
              value.substring(nestedIndex, nestedIndex + nestedLength);
          nestedIndex += nestedLength;

          nestedTags[nestedTagId] = nestedValue;
        }
        result[tagId] = nestedTags;
      } else {
        // Handle special cases
        switch (tagId) {
          case '00': // Payload Format Indicator
            result[tagId] = value;
            break;
          case '01': // Point of Initiation Method
            result[tagId] = value;
            break;
          case '52': // Merchant Category Code
            result[tagId] = value;
            break;
          case '53': // Transaction Currency
            result[tagId] = value;
            break;
          case '54': // Transaction Amount
            result[tagId] = double.parse(value);
            break;
          case '58': // Country Code
            result[tagId] = value;
            break;
          case '59': // Merchant Name
            result[tagId] = value;
            break;
          case '60': // Merchant City
            result[tagId] = value;
            break;
          case '61': // Postal Code
            result[tagId] = value;
            break;
          case '63': // CRC
            result[tagId] = value;
            break;
          default:
            result[tagId] = value;
        }
      }
    }

    return result;
  }

  /// Validates if the MMQR text has a valid CRC
  bool validateMMQRText(String mmqrText) {
    try {
      // Extract everything except the CRC
      String dataWithoutCRC = mmqrText.substring(0, mmqrText.length - 4);
      String providedCRC = mmqrText.substring(mmqrText.length - 4);

      // Calculate CRC for the data
      String calculatedCRC = _calculateCRC('${dataWithoutCRC}6304');

      return providedCRC == calculatedCRC;
    } catch (e) {
      return false;
    }
  }

  /// CRC-16/CCITT-FALSE implementation (polynomial 0x1021, initial value 0xFFFF)
  String _calculateCRC(String input) {
    final bytes = Uint8List.fromList(utf8.encode(input));
    int crc = 0xFFFF;

    for (var b in bytes) {
      crc ^= (b << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc <<= 1;
        }
        crc &= 0xFFFF;
      }
    }

    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
