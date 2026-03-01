import 'dart:async';

import 'package:flutter/material.dart';

class AppElevatedButton extends StatefulWidget {
  final FutureOr<void> Function()? onPressed;
  final FutureOr<void> Function()? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Color? loadingColor;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.onHover,
    this.onFocusChange,
    this.statesController,
    this.isLoading = false,
    this.loadingColor,
  });

  factory AppElevatedButton.icon({
    Key? key,
    required FutureOr<void> Function()? onPressed,
    required Widget icon,
    required Widget label,
    FutureOr<void> Function()? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    WidgetStatesController? statesController,
    bool isLoading = false,
    Color? loadingColor,
  }) {
    return AppElevatedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      onHover: onHover,
      onFocusChange: onFocusChange,
      statesController: statesController,
      isLoading: isLoading,
      loadingColor: loadingColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[icon, const SizedBox(width: 8), label],
      ),
    );
  }

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onPressed!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleLongPress() async {
    if (widget.onLongPress == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onLongPress!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = widget.isLoading || _isLoading;
    final Color spinnerColor =
        widget.loadingColor ?? Theme.of(context).colorScheme.onPrimary;
    return ElevatedButton(
      onPressed: loading || widget.onPressed == null ? null : _handlePressed,
      onLongPress: loading || widget.onLongPress == null
          ? null
          : _handleLongPress,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      statesController: widget.statesController,
      child: _LoadingChild(
        isLoading: loading,
        spinnerColor: spinnerColor,
        child: widget.child,
      ),
    );
  }
}

class AppTextButton extends StatefulWidget {
  final FutureOr<void> Function()? onPressed;
  final FutureOr<void> Function()? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Color? loadingColor;

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.onHover,
    this.onFocusChange,
    this.statesController,
    this.isLoading = false,
    this.loadingColor,
  });

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onPressed!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleLongPress() async {
    if (widget.onLongPress == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onLongPress!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = widget.isLoading || _isLoading;
    final Color spinnerColor =
        widget.loadingColor ?? Theme.of(context).colorScheme.primary;
    return TextButton(
      onPressed: loading || widget.onPressed == null ? null : _handlePressed,
      onLongPress: loading || widget.onLongPress == null
          ? null
          : _handleLongPress,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      statesController: widget.statesController,
      child: _LoadingChild(
        isLoading: loading,
        spinnerColor: spinnerColor,
        child: widget.child,
      ),
    );
  }
}

class AppOutlinedButton extends StatefulWidget {
  final FutureOr<void> Function()? onPressed;
  final FutureOr<void> Function()? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Color? loadingColor;

  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.onHover,
    this.onFocusChange,
    this.statesController,
    this.isLoading = false,
    this.loadingColor,
  });

  @override
  State<AppOutlinedButton> createState() => _AppOutlinedButtonState();
}

class _AppOutlinedButtonState extends State<AppOutlinedButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onPressed!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleLongPress() async {
    if (widget.onLongPress == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onLongPress!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = widget.isLoading || _isLoading;
    final Color spinnerColor =
        widget.loadingColor ?? Theme.of(context).colorScheme.primary;
    return OutlinedButton(
      onPressed: loading || widget.onPressed == null ? null : _handlePressed,
      onLongPress: loading || widget.onLongPress == null
          ? null
          : _handleLongPress,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      statesController: widget.statesController,
      child: _LoadingChild(
        isLoading: loading,
        spinnerColor: spinnerColor,
        child: widget.child,
      ),
    );
  }
}

class AppIconButton extends StatefulWidget {
  final FutureOr<void> Function()? onPressed;
  final Widget icon;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final BoxConstraints? constraints;
  final Color? color;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final ButtonStyle? style;
  final VisualDensity? visualDensity;
  final bool? enableFeedback;
  final double? splashRadius;
  final bool isLoading;
  final Color? loadingColor;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.padding,
    this.alignment = Alignment.center,
    this.constraints,
    this.color,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
    this.visualDensity,
    this.enableFeedback,
    this.splashRadius,
    this.isLoading = false,
    this.loadingColor,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null) return;
    if (_isLoading || widget.isLoading) return;
    final result = widget.onPressed!();
    if (result is Future) {
      setState(() => _isLoading = true);
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = widget.isLoading || _isLoading;
    final Color spinnerColor =
        widget.loadingColor ?? Theme.of(context).colorScheme.primary;
    return IconButton(
      onPressed: loading || widget.onPressed == null ? null : _handlePressed,
      icon: _LoadingChild(
        isLoading: loading,
        spinnerColor: spinnerColor,
        child: widget.icon,
      ),
      iconSize: widget.iconSize,
      padding: widget.padding,
      alignment: widget.alignment,
      constraints: widget.constraints,
      color: widget.color,
      tooltip: widget.tooltip,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      style: widget.style,
      visualDensity: widget.visualDensity,
      enableFeedback: widget.enableFeedback,
      splashRadius: widget.splashRadius,
    );
  }
}

class _LoadingChild extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color spinnerColor;

  const _LoadingChild({
    required this.isLoading,
    required this.child,
    required this.spinnerColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(opacity: 0, child: child),
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
          ),
        ),
      ],
    );
  }
}
