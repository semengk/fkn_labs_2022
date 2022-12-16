import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'marvel_ hero.dart';

class ApiMarvel {
  final String publicKey = "63f09b59ea40ae31b9ddff0c0e4e454b";
  final String privateKey = "7ead6aed7c4aa99bd7bcafcd54b724a537486c86";

  Future<List<int>> getHeroesId() async {
    String url = "https://gateway.marvel.com:443/v1/public/characters?";
    List<int> heroesId = [];
    var ts = 1;

    try {
      Response response = await Dio().request(url, queryParameters: {
        'ts': ts,
        'apikey': publicKey,
        'hash': md5
            .convert(utf8.encode(ts.toString() + privateKey + publicKey))
            .toString()
      });

      for (var element in response.data["data"]["results"]) {
        heroesId.add(element["id"]);
      }

      return heroesId;
    } catch (error) {
      throw Exception("Ошибка при попытке получить id героев");
    }
  }

  Future<MarvelHero> getHeroInfo(int id) async {
    String characterUrl =
        "https://gateway.marvel.com:443/v1/public/characters/$id";
    var ts = 1;

    try {
      Response response = await Dio().request(characterUrl, queryParameters: {
        'ts': ts,
        'apikey': publicKey,
        'hash': md5
            .convert(utf8.encode(ts.toString() + privateKey + publicKey))
            .toString()
      });

      return MarvelHero.fromJson(response.data["data"]["results"][0]);
    } catch (error) {
      throw Exception(
          "Ошибка при попытке получить информацию о герое c id: $id");
    }
  }
}
