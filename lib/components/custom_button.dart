import 'package:flutter/material.dart';



class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;




  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.95),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.95, end: 1.0),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });


  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    final primaryColor = theme.colorScheme.primary;
    final primaryContainerColor= theme.colorScheme.primaryContainer;
    final onPrimaryContainerColor= theme.colorScheme.onPrimaryContainer;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _controller.forward(from: 0);
              widget.onPressed();
            },
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      onPrimaryContainerColor,
                      primaryContainerColor,
                      primaryColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(1, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
