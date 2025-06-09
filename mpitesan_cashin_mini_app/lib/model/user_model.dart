import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class UserInfoRequest {
  final String type;
  final String identification;
  final String level;
  final String inputType;
  final String userRole;

  UserInfoRequest({
    required this.type,
    required this.identification,
    required this.level,
    required this.inputType,
    required this.userRole,
  });

  /// Convert Dart object to XML String
  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('COMMAND', nest: () {
      builder.element('TYPE', nest: type);
      builder.element('IDENTIFICATION', nest: identification);
      builder.element('LEVEL', nest: level);
      builder.element('INPUTTYPE', nest: inputType);
      builder.element('USERROLE', nest: userRole);
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }

  /// Convert XML String to Dart Object
  factory UserInfoRequest.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final command = document.getElement('COMMAND');

    return UserInfoRequest(
      type: command?.getElement('TYPE')?.innerText ?? '',
      identification: command?.getElement('IDENTIFICATION')?.innerText ?? '',
      level: command?.getElement('LEVEL')?.innerText ?? '',
      inputType: command?.getElement('INPUTTYPE')?.innerText ?? '',
      userRole: command?.getElement('USERROLE')?.innerText ?? '',
    );
  }
}

class UserInfoResponse {
  final String type;
  final String txnStatus;
  final String message;
  final String? trid;

  // User details in case of success
  final String? fname;
  final String? lname;
  final String? dob;
  final String? address;
  final String? name;
  final String? agentCode;
  final String? msisdn;
  final String? merchantType;
  final String? idNumber;
  final String? language;
  final String? status;
  final String? barDescription;
  final String? email;
  final String? isMMQRReg;
  final String? terminalId;
  final String? institutionId;
  final String? agentId;

  // Company details in case of success
  final String? companyShortName;
  final String? companyFullName;
  final String? companyShortNameMmr;
  final String? companyFullNameMmr;

  // Merchant details in case of success
  final String? merchantId;
  final String? merchantName;
  final String? merchantLabel;
  final String? merchantLabelMmr;
  final String? mcc;
  final String? country;
  final String? city;
  final String? postalCode;
  final String? mmqrIdType1;
  final String? mmqrIdValue1;
  final String? mmqrIdType2;
  final String? mmqrIdValue2;
  final String? approvalStatus;
  final String? level;
  final String? tncFlag;

  // Detail information
  final String? categoryCode;
  final String? providerId;
  final String? userId;
  final String? userType;
  final String? paymentInstrumentId;
  final String? gradeCode;
  final String? defaultCurrency;

  UserInfoResponse({
    required this.type,
    required this.txnStatus,
    required this.message,
    this.trid,
    this.fname,
    this.lname,
    this.dob,
    this.address,
    this.name,
    this.agentCode,
    this.msisdn,
    this.merchantType,
    this.idNumber,
    this.language,
    this.status,
    this.barDescription,
    this.email,
    this.isMMQRReg,
    this.terminalId,
    this.institutionId,
    this.agentId,
    this.companyShortName,
    this.companyFullName,
    this.companyShortNameMmr,
    this.companyFullNameMmr,
    this.merchantId,
    this.merchantName,
    this.merchantLabel,
    this.merchantLabelMmr,
    this.mcc,
    this.country,
    this.city,
    this.postalCode,
    this.mmqrIdType1,
    this.mmqrIdValue1,
    this.mmqrIdType2,
    this.mmqrIdValue2,
    this.approvalStatus,
    this.level,
    this.tncFlag,
    this.categoryCode,
    this.providerId,
    this.userId,
    this.userType,
    this.paymentInstrumentId,
    this.gradeCode,
    this.defaultCurrency,
  });

  factory UserInfoResponse.fromXml(String xmlString) {
    debugPrint("parse xml");
    final document = XmlDocument.parse(xmlString);
    debugPrint("document $document");
    final command = document.getElement('COMMAND');
    debugPrint("command $command");
    final detail = command?.getElement('DETAIL');
    debugPrint("detail $detail");

    final userInfo = UserInfoResponse(
      type: command?.getElement('TYPE')?.innerText ?? '',
      txnStatus: command?.getElement('TXNSTATUS')?.innerText ?? '',
      message: command?.getElement('MESSAGE')?.innerText ?? '',
      trid: command?.getElement('TRID')?.innerText,

      // User details
      fname: command?.getElement('FNAME')?.innerText,
      lname: command?.getElement('LNAME')?.innerText,
      dob: command?.getElement('DOB')?.innerText,
      address: command?.getElement('ADDRESS')?.innerText,
      name: command?.getElement('NAME')?.innerText,
      agentCode: command?.getElement('AGENT_CODE')?.innerText,
      msisdn: command?.getElement('MSISDN')?.innerText,
      merchantType: command?.getElement('MERCHANT_TYPE')?.innerText,
      idNumber: command?.getElement('ID_NUMBER')?.innerText,
      language: command?.getElement('LANGUAGE')?.innerText,
      status: command?.getElement('STATUS')?.innerText,
      barDescription: command?.getElement('BAR_DESCRIPTION')?.innerText,
      email: command?.getElement('EMAIL')?.innerText,
      isMMQRReg: command?.getElement('ISMMQRREG')?.innerText,
      terminalId: command?.getElement('TERMINAL_ID')?.innerText,
      institutionId: command?.getElement('INSTITUTION_ID')?.innerText,
      agentId: command?.getElement('AGENT_ID')?.innerText,

      // Company details
      companyShortName: command?.getElement('COMPANY_SHORT_NAME')?.innerText,
      companyFullName: command?.getElement('COMPANY_FULL_NAME')?.innerText,
      companyShortNameMmr:
          command?.getElement('COMPANY_SHORT_NAME_MMR')?.innerText,
      companyFullNameMmr:
          command?.getElement('COMPANY_FULL_NAME_MMR')?.innerText,

      // Merchant details
      merchantId: command?.getElement('MERCHANT_ID')?.innerText,
      merchantName: command?.getElement('MERCHANT_NAME')?.innerText,
      merchantLabel: command?.getElement('MERCHANT_LABEL')?.innerText,
      merchantLabelMmr: command?.getElement('MERCHANT_LABEL_MMR')?.innerText,
      mcc: command?.getElement('MCC')?.innerText,
      country: command?.getElement('COUNTRY')?.innerText,
      city: command?.getElement('CITY')?.innerText,
      postalCode: command?.getElement('POSTAL_CODE')?.innerText,
      mmqrIdType1: command?.getElement('MMQR_IDTYPE1')?.innerText,
      mmqrIdValue1: command?.getElement('MMQR_IDVALUE1')?.innerText,
      mmqrIdType2: command?.getElement('MMQR_IDTYPE2')?.innerText,
      mmqrIdValue2: command?.getElement('MMQR_IDVALUE2')?.innerText,
      approvalStatus: command?.getElement('APPROVAL_STATUS')?.innerText,
      level: command?.getElement('LEVEL')?.innerText,
      tncFlag: command?.getElement('TNCFLAG')?.innerText,

      // Detail information
      categoryCode: detail?.getElement('CATEGORY_CODE')?.innerText,
      providerId: detail?.getElement('PROVIDER_ID')?.innerText,
      userId: detail?.getElement('USER_ID')?.innerText,
      userType: detail?.getElement('USER_TYPE')?.innerText,
      paymentInstrumentId:
          detail?.getElement('PAYMENT_INSTRUMENT_ID')?.innerText,
      gradeCode: detail?.getElement('GRADE_CODE')?.innerText,
      defaultCurrency: detail?.getElement('DEFAULT_CURRENCY')?.innerText,
    );
    
    return userInfo;
  }

  // Helper methods
  bool get isSuccess => txnStatus == '200';
  bool get isUserNotFound => txnStatus == '00066';
  bool get isActive => status == 'Y';
  bool get isMMQRRegistered => isMMQRReg == 'Y';
  bool get isApproved => approvalStatus == 'Approved';
  bool get hasTncAccepted => tncFlag == 'Y';

  // Get full name
  String get fullName => name ?? '$fname $lname'.trim();
}
