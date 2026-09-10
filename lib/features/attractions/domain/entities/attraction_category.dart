enum AttractionCategory {
  cultural,
  religious,
  nature,
  crafts;

  static AttractionCategory fromString(String value) {
    return AttractionCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => AttractionCategory.cultural,
    );
  }
}
