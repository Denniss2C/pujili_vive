import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/error/exceptions.dart';
import '../models/festival_event_model.dart';

abstract class CalendarLocalDataSource {
  Future<List<FestivalEventModel>> getFestivalEvents();
}

class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  static const _assetPath = 'assets/data/festival_events.json';

  @override
  Future<List<FestivalEventModel>> getFestivalEvents() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => FestivalEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('No se pudo cargar $_assetPath: $e');
    }
  }
}
