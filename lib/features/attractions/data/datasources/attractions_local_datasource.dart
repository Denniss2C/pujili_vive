import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/error/exceptions.dart';
import '../models/attraction_model.dart';

abstract class AttractionsLocalDataSource {
  Future<List<AttractionModel>> getAttractions();
}

class AttractionsLocalDataSourceImpl implements AttractionsLocalDataSource {
  static const _assetPath = 'assets/data/attractions.json';

  @override
  Future<List<AttractionModel>> getAttractions() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => AttractionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('No se pudo cargar $_assetPath: $e');
    }
  }
}
