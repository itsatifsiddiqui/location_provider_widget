import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.enabled = true,
    this.isOutline = false,
    this.text,
    required this.onTap,
    this.elevation = 0,
    this.verticalPadding = 16,
    this.width,
    this.child,
    this.color,
    this.borderRadius = 8,
    this.isLoading = false,
  }) : super(key: key);
  final bool enabled;
  final bool isOutline;
  final String? text;
  final GestureTapCallback onTap;
  final double elevation;
  final double? width;
  final double verticalPadding;
  final Widget? child;
  final Color? color;
  final bool isLoading;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      highlightElevation: elevation,
      disabledColor: Colors.black54,
      minWidth: width ?? double.infinity,
      color:
          color ?? ((isOutline || isLoading) ? Colors.transparent : Theme.of(context).primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: (isOutline || isLoading)
            ? BorderSide(width: 1.5, color: color ?? Theme.of(context).primaryColor)
            : BorderSide(
                color: color ?? (!enabled ? Colors.black54 : Colors.transparent),
                width: enabled ? 1.5 : 0,
              ),
      ),
      onPressed: isLoading
          ? null
          : enabled
              ? onTap
              : null,
      child: isLoading
          ? _buildLoader()
          : child ??
              Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
                child: Text(
                  text ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
