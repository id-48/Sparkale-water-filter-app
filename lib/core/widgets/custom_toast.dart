import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkle/core/constants/app_images.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

enum ToastType { success, error }

class CustomToast {
  static void show({
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = Get.overlayContext;
    if (context == null) return;

    _dismissCurrentToast();

    _currentToast = _showToast(context, message, type, duration);
    Overlay.of(context).insert(_currentToast!);
  }

  static OverlayEntry? _currentToast;

  static OverlayEntry _showToast(
    BuildContext context,
    String message,
    ToastType type,
    Duration duration,
  ) {
    final overlayEntry = OverlayEntry(
      builder: (context) => ToastOverlay(
        message: message,
        type: type,
        onDismiss: () {
          _dismissCurrentToast();
        },
      ),
    );

    Future.delayed(duration, () {
      if (_currentToast == overlayEntry && _currentToast != null) {
        _dismissCurrentToast();
      }
    });

    return overlayEntry;
  }

  static void _dismissCurrentToast() {
    if (_currentToast != null) {
      try {
        _currentToast?.remove();
      } catch (e) {
      }
      _currentToast = null;
    }
  }

  static void success(String message) {
    show(message: message, type: ToastType.success);
  }
  static void error(String message) {
    show(message:
    message, type: ToastType.error);
  }

}

class ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const ToastOverlay({
    super.key,
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissToast() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppConstants.defaultPadding,
      right: AppConstants.defaultPadding,
      bottom: 100 + MediaQuery.of(context).viewInsets.bottom,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: _ToastWidget(
            message: widget.message,
            type: widget.type,
            onDismiss: _dismissToast,
          ),
        ),
      ),
    );
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  Color _getToastColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.successToastText;
      case ToastType.error:
        return AppColors.error;
    }
  }

  Color _getToastBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.successToastBg;
      case ToastType.error:
        return AppColors.errorToastBg;
    }
  }

  Widget _getIcon() {
    switch (type) {
      case ToastType.success:
        return Image.asset(
          AppImages.success,
          scale: 4.0,
          height: AppConstants.defaultIconSize,
          width: AppConstants.defaultIconSize,
        );
      case ToastType.error:
        return Image.asset(
          AppImages.error,
          scale: 4.0,
          height: AppConstants.defaultIconSize,
          width: AppConstants.defaultIconSize,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: _getToastBackgroundColor(),
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          border: Border.all(color: _getToastColor(), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: AppConstants.defaultPadding),
              _getIcon(),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: _getToastColor(),
                    fontSize: AppConstants.defaultFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  color: _getToastColor(),
                  size: AppConstants.smallIconSize,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
