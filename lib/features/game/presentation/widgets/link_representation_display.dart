import 'package:flutter/material.dart';
import '../../../game/domain/entities/link_node.dart';

class LinkRepresentationDisplay extends StatelessWidget {
  final LinkNode node;
  final String locale;
  final double iconSize;
  final double imageSize;
  final TextStyle? textStyle;
  final bool showLabel;

  const LinkRepresentationDisplay({
    super.key,
    required this.node,
    required this.locale,
    this.iconSize = 32,
    this.imageSize = 64,
    this.textStyle,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (node.representationType) {
      case RepresentationType.icon:
        content = _buildIcon(context);
        break;
      case RepresentationType.image:
        content = _buildImage(context);
        break;
      case RepresentationType.event:
        content = _buildEvent(context);
        break;
      case RepresentationType.text:
        content = _buildText(context);
        break;
    }
    return content;
  }

  Widget _buildText(BuildContext context) {
    return Text(
      node.getLocalizedLabel(locale),
      style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIcon(BuildContext context) {
    final icon = _mapIconName(node.iconName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          _buildText(context),
        ],
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final imagePath = node.imagePath;
    if (imagePath == null || imagePath.isEmpty) {
      return _buildText(context);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image,
              size: imageSize,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          _buildText(context),
        ],
      ],
    );
  }

  Widget _buildEvent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.event,
          size: iconSize,
          color: Theme.of(context).colorScheme.secondary,
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          _buildText(context),
        ],
      ],
    );
  }

  IconData _mapIconName(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.category;
    }
    switch (iconName.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'airplanemode_active':
        return Icons.airplanemode_active;
      case 'bolt':
        return Icons.bolt;
      case 'biotech':
        return Icons.biotech;
      case 'public':
        return Icons.public;
      case 'factory':
        return Icons.factory;
      case 'construction':
        return Icons.construction;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing;
      case 'directions_car':
        return Icons.directions_car;
      case 'store':
        return Icons.store;
      case 'agriculture':
      case 'plant':
        return Icons.agriculture;
      case 'sports':
        return Icons.sports_soccer;
      case 'health':
        return Icons.health_and_safety;
      case 'history':
        return Icons.account_balance;
      case 'geography':
        return Icons.public;
      case 'art':
      case 'culture':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'education':
      case 'school':
        return Icons.school;
      case 'friendship':
      case 'family':
        return Icons.group;
      default:
        return Icons.category;
    }
  }
}
