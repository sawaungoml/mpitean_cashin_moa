import 'package:xml/xml.dart';

class PinValidationRequest {
  final String type;
  final String msisdn;
  final String provider;
  final String mpin;
  final String language1;
  final String requestingParty;

  PinValidationRequest({
    required this.type,
    required this.msisdn,
    required this.provider,
    required this.mpin,
    required this.language1,
    required this.requestingParty,
  });

  /// Convert Dart object to XML String
  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('COMMAND', nest: () {
      builder.element('TYPE', nest: type);
      builder.element('MSISDN', nest: msisdn);
      builder.element('PROVIDER', nest: provider);
      builder.element('MPIN', nest: mpin);
      builder.element('LANGUAGE1', nest: language1);
      builder.element('REQUESTINGPARTY', nest: requestingParty);
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }

  /// Convert XML String to Dart Object
  factory PinValidationRequest.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final command = document.getElement('COMMAND');

    return PinValidationRequest(
      type: command?.getElement('TYPE')?.innerText ?? '',
      msisdn: command?.getElement('MSISDN')?.innerText ?? '',
      provider: command?.getElement('PROVIDER')?.innerText ?? '',
      mpin: command?.getElement('MPIN')?.innerText ?? '',
      language1: command?.getElement('LANGUAGE1')?.innerText ?? '',
      requestingParty: command?.getElement('REQUESTINGPARTY')?.innerText ?? '',
    );
  }
}

class PinValidationResponse {
  final String type;
  final String txnStatus;
  final String message;
  final String? trid;

  PinValidationResponse({
    required this.type,
    required this.txnStatus,
    required this.message,
    this.trid,
  });

  bool get isSuccess => txnStatus == '200';
  bool get isInvalidPin => txnStatus == '000680';

  /// Parse the XML response into a PinValidationResponse object
  factory PinValidationResponse.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final command = document.getElement('COMMAND');

    // If we can't parse the document or find the COMMAND element, return an error response
    if (command == null) {
      return PinValidationResponse(
        type: 'RVMPINRESP',
        txnStatus: 'ERROR',
        message: 'Failed to parse XML response',
      );
    }

    return PinValidationResponse(
      type: command.getElement('TYPE')?.innerText ?? '',
      txnStatus: command.getElement('TXNSTATUS')?.innerText ?? '',
      message: command.getElement('MESSAGE')?.innerText ?? '',
      trid: command.getElement('TRID')?.innerText,
    );
  }
}

class ChangePinRequest {
  final String type;
  final String msisdn;
  final String mpin;
  final String newMpin;
  final String confirmMpin;
  final String blockSms;
  final String language1;
  final String cellId;
  final String fTxnId;

  ChangePinRequest({
    required this.type,
    required this.msisdn,
    required this.mpin,
    required this.newMpin,
    required this.confirmMpin,
    required this.blockSms,
    required this.language1,
    required this.cellId,
    required this.fTxnId,
  });

  /// Convert Dart object to XML String
  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('COMMAND', nest: () {
      builder.element('TYPE', nest: type);
      builder.element('MSISDN', nest: msisdn);
      builder.element('MPIN', nest: mpin);
      builder.element('NEWMPIN', nest: newMpin);
      builder.element('CONFIRMMPIN', nest: confirmMpin);
      builder.element('BLOCKSMS', nest: blockSms);
      builder.element('LANGUAGE1', nest: language1);
      builder.element('CELLID', nest: cellId);
      builder.element('FTXNID', nest: fTxnId);
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }

  /// Convert XML String to Dart Object
  factory ChangePinRequest.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final command = document.getElement('COMMAND');

    return ChangePinRequest(
      type: command?.getElement('TYPE')?.innerText ?? '',
      msisdn: command?.getElement('MSISDN')?.innerText ?? '',
      mpin: command?.getElement('MPIN')?.innerText ?? '',
      newMpin: command?.getElement('NEWMPIN')?.innerText ?? '',
      confirmMpin: command?.getElement('CONFIRMMPIN')?.innerText ?? '',
      blockSms: command?.getElement('BLOCKSMS')?.innerText ?? '',
      language1: command?.getElement('LANGUAGE1')?.innerText ?? '',
      cellId: command?.getElement('CELLID')?.innerText ?? '',
      fTxnId: command?.getElement('FTXNID')?.innerText ?? '',
    );
  }
}

class ChangePinResponse {
  final String type;
  final String txnStatus;
  final String message;
  final String? trid;

  ChangePinResponse({
    required this.type,
    required this.txnStatus,
    required this.message,
    this.trid,
  });

  bool get isSuccess => txnStatus == '200';
  bool get isInvalidPin => txnStatus == '000680';

  /// Parse the XML response into a ChangePinResponse object
  factory ChangePinResponse.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final command = document.getElement('COMMAND');

    // If we can't parse the document or find the COMMAND element, return an error response
    if (command == null) {
      return ChangePinResponse(
        type: 'RCMPNRESP',
        txnStatus: 'ERROR',
        message: 'Failed to parse XML response',
      );
    }

    return ChangePinResponse(
      type: command.getElement('TYPE')?.innerText ?? '',
      txnStatus: command.getElement('TXNSTATUS')?.innerText ?? '',
      message: command.getElement('MESSAGE')?.innerText ?? '',
      trid: command.getElement('TRID')?.innerText,
    );
  }
}
