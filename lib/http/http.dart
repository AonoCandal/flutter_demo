import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

class WLHttp {
  static final WLHttp _http = new WLHttp._internal();
  HttpClient httpClient = new HttpClient();

  factory WLHttp(){
    return _http;
  }

  WLHttp._internal();

  get() async {
    var url = "https://httpbin.org/ip";
    var result;
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(response.statusCode == HttpStatus.ok){
        var jsonInfo = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonInfo);
        result = data['origin'];
      } else {
        var statuscode = response.statusCode;
        result = "error $statuscode";
      }
    } on HttpException catch (e){
      result = e.message;
    }
    return result;
  }
}
