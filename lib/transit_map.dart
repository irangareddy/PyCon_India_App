import 'package:flutter/material.dart';
import 'package:pycon_india_app/path_painter.dart';

class TransitMap extends StatefulWidget {
  const TransitMap({super.key});

  @override
  State<TransitMap> createState() => _TransitMapState();
}

class _TransitMapState extends State<TransitMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double x;
  late double y;
  bool _isAnimating = false;

// a function to update mouse pointer position (location)
  void updatePosition(TapDownDetails details) {
    setState(() {
      x = details.globalPosition.dx;
      y = details.globalPosition.dy;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
          });
        }
      });
  }

  void _startAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reset();
    }
    if (!_animationController.isAnimating) {
      _animationController.forward();
      setState(() {
        _isAnimating = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = <Offset>[
      const Offset(161, 270),
      const Offset(165, 298),
      const Offset(170, 296),
      const Offset(210, 293),
      const Offset(234, 290),
      const Offset(262, 287),
      const Offset(288, 284),
      const Offset(317, 280),
      const Offset(333, 277),
      const Offset(342, 275),
      const Offset(350, 273),
      const Offset(365, 270),
      const Offset(354, 215),
      const Offset(347, 165),
      const Offset(315, 170),
      const Offset(312, 157),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transit Map'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text('X: $x'),
                const Spacer(),
                Text('Y: $y'),
                const Spacer(),
              ],
            ),
          ),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTapDown: updatePosition,
                  child: Image.asset(
                    'assets/street.png', // Replace with your PNG asset path
                    // width: MediaQuery.of(context).size.width,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: PathPainter(
                        points: coordinates,
                        controller: _animationController,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startAnimation,
        backgroundColor: Colors.orangeAccent,
        child: Icon(
          _isAnimating ? Icons.replay : Icons.play_arrow,
        ),
      ),
    );
  }
}
