import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

enum ToastType {
  success,
  error,
}

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  final VoidCallback? onClose;
  final Duration duration;

  const CustomToast({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            ),
            child: Icon(
              _getIcon(),
              color: AppColors.white,
              size: 16,
            ),
          ),
          
          const SizedBox(width: AppConstants.smallPadding),
          
          // Message
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getTextColor(),
                fontSize: AppConstants.defaultFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Close button
          if (onClose != null) ...[
            const SizedBox(width: AppConstants.smallPadding),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xFFF0F9F0); // Light green background
      case ToastType.error:
        return const Color(0xFFFEF2F2); // Light red background
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xFFBBF7D0); // Light green border
      case ToastType.error:
        return const Color(0xFFFECACA); // Light red border
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF166534); // Dark green text
      case ToastType.error:
        return const Color(0xFFDC2626); // Dark red text
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.success; // Green icon background
      case ToastType.error:
        return AppColors.error; // Red icon background
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check;
      case ToastType.error:
        return Icons.close;
    }
  }
}

class CustomToastOverlay extends StatefulWidget {
  final Widget child;

  const CustomToastOverlay({
    super.key,
    required this.child,
  });

  @override
  State<CustomToastOverlay> createState() => _CustomToastOverlayState();
}

class _CustomToastOverlayState extends State<CustomToastOverlay>
    with TickerProviderStateMixin {
  final List<_ToastEntry> _toasts = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addToast({
    required String message,
    required ToastType type,
    Duration? duration,
  }) {
    final entry = _ToastEntry(
      key: GlobalKey<_CustomToastState>(),
      message: message,
      type: type,
      duration: duration ?? const Duration(seconds: 3),
    );

    setState(() {
      _toasts.add(entry);
    });

    // Auto remove after duration
    Future.delayed(entry.duration, () {
      _removeToast(entry);
    });

    _animationController.forward();
  }

  void _removeToast(_ToastEntry entry) {
    if (mounted && _toasts.contains(entry)) {
      setState(() {
        _toasts.remove(entry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_toasts.isNotEmpty)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: Column(
              children: _toasts.map((entry) {
                return _CustomToast(
                  key: entry.key,
                  message: entry.message,
                  type: entry.type,
                  onClose: () => _removeToast(entry),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _CustomToast extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback? onClose;

  const _CustomToast({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
  });

  @override
  State<_CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<_CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: CustomToast(
              message: widget.message,
              type: widget.type,
              onClose: widget.onClose,
            ),
          ),
        );
      },
    );
  }
}

class _ToastEntry {
  final GlobalKey<_CustomToastState> key;
  final String message;
  final ToastType type;
  final Duration duration;

  _ToastEntry({
    required this.key,
    required this.message,
    required this.type,
    required this.duration,
  });
}
