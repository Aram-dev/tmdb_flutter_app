import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final double speed;
  const AutoScrollText({
    super.key,
    required this.text,
    this.textStyle,
    this.speed = 50.0,
  });
  @override
  _AutoScrollTextState createState() => _AutoScrollTextState();
}
class _AutoScrollTextState extends State<AutoScrollText>
    with SingleTickerProviderStateMixin {
  late double textWidth;
  late double screenWidth;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateDimensions();
    });
  }
  void _calculateDimensions() {
    final textSpan = TextSpan(text: widget.text, style: widget.textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    textWidth = textPainter.size.width;
    screenWidth = MediaQuery.of(context).size.width;
    _controller = AnimationController(
      duration: Duration(
        milliseconds: ((textWidth + screenWidth) / widget.speed * 1000).toInt(),
      ),
      vsync: this,
    )..repeat();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const SizedBox.shrink();
    }
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-_controller.value * (textWidth + screenWidth), 0),
            child: child,
          );
        },
        child: Row(
          children: [
            Text(widget.text, style: widget.textStyle),
            SizedBox(width: screenWidth),
            Text(widget.text, style: widget.textStyle),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
