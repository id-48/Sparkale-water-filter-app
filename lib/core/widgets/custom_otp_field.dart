import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOTPField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autoFocus;
  final TextInputType keyboardType;
  final Color? cursorColor;
  final TextStyle? textStyle;
  final Color? hintTextColor;
  final Color? fieldBorderColor;
  final Color? activeFieldBorderColor;
  final Color? filledFieldBorderColor;
  final double fieldWidth;
  final double fieldHeight;
  final double fieldBorderRadius;
  final double fieldBorderWidth;
  final String hintText;
  final bool showHintText;

  const CustomOTPField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = false,
    this.keyboardType = TextInputType.number,
    this.cursorColor,
    this.textStyle,
    this.hintTextColor,
    this.fieldBorderColor,
    this.activeFieldBorderColor,
    this.filledFieldBorderColor,
    this.fieldWidth = 40,
    this.fieldHeight = 40,
    this.fieldBorderRadius = 8,
    this.fieldBorderWidth = 1,
    this.hintText = '0',
    this.showHintText = true,
  });

  @override
  State<CustomOTPField> createState() => _CustomOTPFieldState();
}

class _CustomOTPFieldState extends State<CustomOTPField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _values;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    _values = List.filled(widget.length, '');

    // Add listeners to focus nodes
    for (int i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            // Focus changed, rebuild to update hint text display
          });
        }
      });
    }

    // Auto focus first field
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste or multiple character input
      _handlePaste(value, index);
      return;
    }

    setState(() {
      _values[index] = value;
    });

    // Move to next field if current field is filled
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Move to previous field if current field is empty and backspace is pressed
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Notify parent about the change
    final otpValue = _values.join('');
    widget.onChanged?.call(otpValue);

    // Check if OTP is complete
    if (otpValue.length == widget.length) {
      widget.onCompleted?.call(otpValue);
    }
  }

  void _handlePaste(String value, int startIndex) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    final remainingLength = widget.length - startIndex;
    final pasteLength = cleanValue.length > remainingLength ? remainingLength : cleanValue.length;

    for (int i = 0; i < pasteLength; i++) {
      if (startIndex + i < widget.length) {
        _values[startIndex + i] = cleanValue[i];
        _controllers[startIndex + i].text = cleanValue[i];
      }
    }

    // Focus the next empty field or the last field
    final nextEmptyIndex = _values.indexOf('');
    if (nextEmptyIndex != -1) {
      _focusNodes[nextEmptyIndex].requestFocus();
    } else {
      _focusNodes[widget.length - 1].requestFocus();
    }

    // Notify parent about the change
    final otpValue = _values.join('');
    widget.onChanged?.call(otpValue);

    // Check if OTP is complete
    if (otpValue.length == widget.length) {
      widget.onCompleted?.call(otpValue);
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_values[index].isEmpty && index > 0) {
          // Move to previous field and clear it
          _focusNodes[index - 1].requestFocus();
          _values[index - 1] = '';
          _controllers[index - 1].text = '';
          widget.onChanged?.call(_values.join(''));
        }
      }
    }
  }

  String _getPinDisplay(int index) {
    final value = _values[index];
    final isActive = _focusNodes[index].hasFocus;
    
    if (value.isEmpty) {
      // Show empty string when cursor is active, otherwise show hint text
      if (isActive) {
        return '';
      } else {
        return widget.showHintText ? (widget.hintText) : '';
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => _buildPinField(index),
      ),
    );
  }

  Widget _buildPinField(int index) {
    final isActive = _focusNodes[index].hasFocus;
    final hasValue = _values[index].isNotEmpty;
    
    return Container(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.fieldBorderRadius),
        border: Border.all(
          color: isActive
              ? (widget.activeFieldBorderColor ?? Colors.blue)
              : hasValue
                  ? (widget.filledFieldBorderColor ?? Colors.green)
                  : (widget.fieldBorderColor ?? Colors.grey),
          width: widget.fieldBorderWidth,
        ),
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onKeyEvent(event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: widget.keyboardType,
          maxLength: 1,
          cursorColor: widget.cursorColor,
          style: widget.textStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) => _onTextChanged(value, index),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: _getPinDisplay(index),
            hintStyle: TextStyle(
              color: widget.hintTextColor ?? Colors.grey,
              fontSize: widget.textStyle?.fontSize ?? 16,
              fontWeight: widget.textStyle?.fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
