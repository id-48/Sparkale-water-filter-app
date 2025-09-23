import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_toast.dart';

class ToastService extends GetxService {
  static ToastService get to => Get.find<ToastService>();
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void onInit() {
    super.onInit();
  }

  /// Show success toast
  void showSuccess(String message, {Duration? duration}) {
    _showToast(
      message: message,
      type: ToastType.success,
      duration: duration,
    );
  }

  /// Show error toast
  void showError(String message, {Duration? duration}) {
    _showToast(
      message: message,
      type: ToastType.error,
      duration: duration,
    );
  }

  /// Show custom toast
  void _showToast({
    required String message,
    required ToastType type,
    Duration? duration,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      _showOverlayToast(
        context: context,
        message: message,
        type: type,
        duration: duration,
      );
    }
  }

  void _showOverlayToast({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration? duration,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastOverlayWidget(
        message: message,
        type: type,
        duration: duration ?? const Duration(seconds: 3),
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration ?? const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlayWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlayWidget> createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Positioned(
      top: topPadding + 20,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomToast(
            message: widget.message,
            type: widget.type,
            onClose: _dismiss,
            duration: widget.duration,
          ),
        ),
      ),
    );
  }
}
