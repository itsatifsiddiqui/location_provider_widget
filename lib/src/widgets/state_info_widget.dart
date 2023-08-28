import 'package:flutter/material.dart';
import 'package:location_provider_widget/src/widgets/primary_button.dart';

class StateInfoWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  const StateInfoWidget({
    Key? key,
    this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    color: Theme.of(context).primaryColor.withAlpha(30),
                    child: Icon(
                      icon ?? Icons.bluetooth_disabled,
                      size: 100,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              onTap: onTap,
              text: buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
