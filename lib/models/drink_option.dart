// lib/models/drink_options.dart

enum DrinkSize { small, medium, large }

extension DrinkSizeX on DrinkSize {
  String get label {
    switch (this) {
      case DrinkSize.small:
        return '300 мл';
      case DrinkSize.medium:
        return '400 мл';
      case DrinkSize.large:
        return '500 мл';
    }
  }

  int get extraPrice {
    switch (this) {
      case DrinkSize.small:
        return 0;
      case DrinkSize.medium:
        return 30;
      case DrinkSize.large:
        return 55;
    }
  }
}

enum IceLevel { none, normal, extra }

extension IceLevelX on IceLevel {
  String get label {
    switch (this) {
      case IceLevel.none:
        return 'Без льда';
      case IceLevel.normal:
        return 'Обычный лёд';
      case IceLevel.extra:
        return 'Много льда';
    }
  }
}

enum SugarLevel { zero, quarter, half, full }

extension SugarLevelX on SugarLevel {
  String get label {
    switch (this) {
      case SugarLevel.zero:
        return '0%';
      case SugarLevel.quarter:
        return '25%';
      case SugarLevel.half:
        return '50%';
      case SugarLevel.full:
        return '100%';
    }
  }
}

class DrinkOption {
  const DrinkOption({
    this.size = DrinkSize.medium,
    this.iceLevel = IceLevel.normal,
    this.sugarLevel = SugarLevel.half,
    this.extras = const <String>[],
    this.note = '',
  });

  final DrinkSize size;
  final IceLevel iceLevel;
  final SugarLevel sugarLevel;
  final List<String> extras;
  final String note;

  DrinkOption copyWith({
    DrinkSize? size,
    IceLevel? iceLevel,
    SugarLevel? sugarLevel,
    List<String>? extras,
    String? note,
  }) {
    return DrinkOption(
      size: size ?? this.size,
      iceLevel: iceLevel ?? this.iceLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      extras: extras ?? this.extras,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size.name,
      'iceLevel': iceLevel.name,
      'sugarLevel': sugarLevel.name,
      'extras': extras,
      'note': note,
    };
  }

  factory DrinkOption.fromMap(Map<String, dynamic> map) {
    return DrinkOption(
      size: DrinkSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => DrinkSize.medium,
      ),
      iceLevel: IceLevel.values.firstWhere(
        (e) => e.name == map['iceLevel'],
        orElse: () => IceLevel.normal,
      ),
      sugarLevel: SugarLevel.values.firstWhere(
        (e) => e.name == map['sugarLevel'],
        orElse: () => SugarLevel.half,
      ),
      extras: (map['extras'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(),
      note: map['note'] as String? ?? '',
    );
  }
}
