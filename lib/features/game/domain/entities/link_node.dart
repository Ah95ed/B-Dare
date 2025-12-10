import 'package:equatable/equatable.dart';

enum RepresentationType {
  text,
  icon,
  image,
  event,
}

class LinkNode extends Equatable {
  final String id;
  final String label;
  final String? iconName;
  final String? imagePath;
  final RepresentationType representationType;
  final Map<String, String>? labels; // For i18n support

  const LinkNode({
    required this.id,
    required this.label,
    this.iconName,
    this.imagePath,
    required this.representationType,
    this.labels,
  });

  String getLocalizedLabel(String locale) {
    if (labels != null && labels!.containsKey(locale)) {
      return labels![locale]!;
    }
    return label;
  }

  @override
  List<Object?> get props => [id, label, iconName, imagePath, representationType];
}

