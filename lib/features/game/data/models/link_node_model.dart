import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/link_node.dart';

class RepresentationTypeConverter implements JsonConverter<RepresentationType, String> {
  const RepresentationTypeConverter();

  @override
  RepresentationType fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'text':
        return RepresentationType.text;
      case 'icon':
        return RepresentationType.icon;
      case 'image':
        return RepresentationType.image;
      case 'event':
        return RepresentationType.event;
      default:
        return RepresentationType.text;
    }
  }

  @override
  String toJson(RepresentationType object) {
    switch (object) {
      case RepresentationType.text:
        return 'text';
      case RepresentationType.icon:
        return 'icon';
      case RepresentationType.image:
        return 'image';
      case RepresentationType.event:
        return 'event';
    }
  }
}

class LinkNodeModel extends LinkNode {
  const LinkNodeModel({
    required super.id,
    required super.label,
    super.iconName,
    super.imagePath,
    @RepresentationTypeConverter() required super.representationType,
    super.labels,
  });

  factory LinkNodeModel.fromJson(Map<String, dynamic> json) {
    return LinkNodeModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconName: json['iconName'] as String?,
      imagePath: json['imagePath'] as String?,
      representationType: const RepresentationTypeConverter().fromJson(
        json['representationType'] as String? ?? 'text',
      ),
      labels: json['labels'] != null
          ? Map<String, String>.from(json['labels'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'iconName': iconName,
      'imagePath': imagePath,
      'representationType': const RepresentationTypeConverter().toJson(representationType),
      'labels': labels,
    };
  }

  factory LinkNodeModel.fromEntity(LinkNode entity) {
    return LinkNodeModel(
      id: entity.id,
      label: entity.label,
      iconName: entity.iconName,
      imagePath: entity.imagePath,
      representationType: entity.representationType,
      labels: entity.labels,
    );
  }
}

