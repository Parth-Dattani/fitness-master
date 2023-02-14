import 'dart:convert';

import 'api.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static var client = http.Client();
  static final scopes = [
//    CalendarApi.calendarScope,
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events',
    'https://www.googleapis.com/auth/calendar.readonly',
    'https://www.googleapis.com/auth/plus.login'
  ];

  static const accessToken = "ya29.a0AVvZVspH6Dhm4aL-heVX1t7PXhMv9VOSqtqaBdu6aqh8VWyEoGP_g0TWrmkisYkovGI2tYb89G8FNegA9vXxfyMJxFH4RC6yFQUj4wEyAs_k1w-DuDUXNV_htzSv9JaBpOw3utbLqFF-PN-y3zlufLeFhAgNaCgYKAQYSARMSFQGbdwaIP-npodxewQyXxGQ4FzW3sA0163";
  static const eventId = "Nm9zMzBlMWg3NHM2NGJiNDZnc2owYjlrY2hqM2diOXA2NWgzY2I5bjZrbzZhYzFsNmdzamVwYjM2Y18xOTcwMDEwMVQwMDAwMDBaIG1heXVydGhlb25ldGVjaDFAbQ";


  static void printResponse(
      Map<String, String> header, dynamic body, http.Response response) {
    print('Header: $header');
    print('Body : $body');
    print('URL: ${response.request!.url}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  static Future<http.Response> insertEvent(
      clientID, ApiKey, title, startDate, endDate
      ) async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    String postBody = json.encode({
      "apiKey": ApiKey,
      "clientID": clientID,
      "summary" : title,
      //"startDate" : startDate.toString(),
      //"endDate" : endDate.toString(),
      "start": {
        "dateTime": "2023-02-6T09:00:00.000+05:30",
        "timeZone": "Asia/Kolkata"
      },
      "end": {
        "dateTime": "2023-02-6T11:00:00.000+05:30",
        "timeZone": "Asia/Kolkata"
      },
      "scope" : scopes,
    });
    http.Response response = await http.post(
      Uri.parse("${Apis.baseAPI}${Apis.insertAPI}"),
      headers: header,
      body: postBody,
    );
    printResponse(header, postBody, response);
    return response;
  }




  static Future<http.Response> getData() async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      '-content-encoding': 'gzip',
    };

    http.Response response = await http.get(
      Uri.parse("${Apis.baseAPI}${Apis.insertAPI}"),
      headers: header,
    );
    printResponse(header, null, response);
    return response;
  }

  // static Future<http.Response> getCalData() async {
  //   Map<String, String> header = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $accessToken',
  //   };
  //   http.Response response = await http.get(
  //       //Uri.parse("https://www.google.com/calendar/events?eid=Nm9zMzBlMWg3NHM2NGJiNDZnc2owYjlrY2hqM2diOXA2NWgzY2I5bjZrbzZhYzFsNmdzamVwYjM2Y18xOTcwMDEwMVQwMDAwMDBaIG1heXVydGhlb25ldGVjaDFAbQ"),
  //       Uri.parse("${Apis.baseAPI}${Apis.insertAPI}/$eventId"),
  //       headers: header);
  //   printResponse(header, null, response);
  //   return response;
  // }
}