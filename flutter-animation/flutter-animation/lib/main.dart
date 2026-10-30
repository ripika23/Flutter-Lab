import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationShowcaseApp());
}

class AnimationShowcaseApp extends StatelessWidget {
  const AnimationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motion Studio',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF070914),
      ),
      home: const AnimationStudio(),
    );
  }
}

enum AnimationType {
  fade,
  slide,
  scale,
  rotation,
  all,
}

class AnimationStudio extends StatefulWidget {
  const AnimationStudio({super.key});

  @override
  State<AnimationStudio> createState() => _AnimationStudioState();
}

class _AnimationStudioState extends State<AnimationStudio>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _backgroundController;

  AnimationType _selected = AnimationType.all;
  double _duration = 1.2;
  bool _autoPlay = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_duration * 1000).round()),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _updateDuration(double value) {
    setState(() {
      _duration = value;
      _controller.duration = Duration(milliseconds: (_duration * 1000).round());
    });
  }

  void _playAnimation() {
    _controller.duration = Duration(milliseconds: (_duration * 1000).round());

    _controller.forward(from: 0);
  }

  void _selectAnimation(AnimationType type) {
    setState(() {
      _selected = type;
    });
    _playAnimation();
  }

  String get _animationName {
    switch (_selected) {
      case AnimationType.fade:
        return 'Fade';
      case AnimationType.slide:
        return 'Slide';
      case AnimationType.scale:
        return 'Scale';
      case AnimationType.rotation:
        return 'Rotation';
      case AnimationType.all:
        return 'All Effects';
    }
  }

  IconData get _animationIcon {
    switch (_selected) {
      case AnimationType.fade:
        return Icons.blur_on_rounded;
      case AnimationType.slide:
        return Icons.swipe_rounded;
      case AnimationType.scale:
        return Icons.zoom_in_rounded;
      case AnimationType.rotation:
        return Icons.rotate_right_rounded;
      case AnimationType.all:
        return Icons.auto_awesome_rounded;
    }
  }

  Widget _animatedPreview() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curved = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
        ).value;

        double opacity = 1;
        double scale = 1;
        double rotation = 0;
        Offset slide = Offset.zero;

        switch (_selected) {
          case AnimationType.fade:
            opacity = curved.clamp(0.0, 1.0);
            break;

          case AnimationType.slide:
            slide = Offset(0, 1 - curved);
            break;

          case AnimationType.scale:
            scale = curved;
            break;

          case AnimationType.rotation:
            rotation = (1 - curved) * math.pi * 2;
            break;

          case AnimationType.all:
            opacity = curved.clamp(0.0, 1.0);
            scale = 0.78 + (curved * 0.22);
            rotation = (1 - curved) * 0.18;
            slide = Offset(0, (1 - curved) * 0.55);
            break;
        }

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              slide.dx * 170,
              slide.dy * 170,
            ),
            child: Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: rotation,
                child: child,
              ),
            ),
          ),
        );
      },
      child: _buildPreviewCard(),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: 310,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B1E38),
            Color(0xFF101326),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(.10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CFF).withOpacity(.25),
            blurRadius: 60,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 35,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8A6CFF).withOpacity(.12),
              ),
            ),
          ),
          Positioned(
            left: -45,
            bottom: -45,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00D9FF).withOpacity(.08),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8B5CFF),
                        Color(0xFF3C8CFF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7255FF).withOpacity(.45),
                        blurRadius: 35,
                      ),
                    ],
                  ),
                  child: Icon(
                    _animationIcon,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  _animationName,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Smooth • Modern • Interactive',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.52),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _effectButton({
    required AnimationType type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _selected == type;

    return GestureDetector(
      onTap: () => _selectAnimation(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF7C5CFF),
                    Color(0xFF496CFF),
                  ],
                )
              : null,
          color: selected ? null : Colors.white.withOpacity(.045),
          border: Border.all(
            color: selected
                ? Colors.white.withOpacity(.25)
                : Colors.white.withOpacity(.07),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF735CFF).withOpacity(.28),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(.18)
                    : Colors.white.withOpacity(.06),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(.55),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final value = _backgroundController.value;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF080A18),
                    Color(0xFF0D1023),
                    Color(0xFF070914),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -100 + (value * 180),
              top: 70,
              child: _glowOrb(
                size: 280,
                color: const Color(0xFF704CFF),
              ),
            ),
            Positioned(
              right: -100 + (value * -160),
              bottom: 80,
              child: _glowOrb(
                size: 300,
                color: const Color(0xFF00B8FF),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _glowOrb({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.055),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.13),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B5CFF),
                Color(0xFF347DFF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7655FF).withOpacity(.35),
                blurRadius: 22,
              ),
            ],
          ),
          child: const Icon(
            Icons.motion_photos_on_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOTION STUDIO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Flutter Animation Lab',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E30),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF51F3A6),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(.48),
          ),
        ),
      ],
    );
  }

  Widget _controls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.035),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                size: 20,
                color: Color(0xFF9B83FF),
              ),
              const SizedBox(width: 10),
              const Text(
                'Animation Speed',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_duration.toStringAsFixed(1)}s',
                  style: const TextStyle(
                    color: Color(0xFFB9A8FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF8062FF),
              inactiveTrackColor: Colors.white.withOpacity(.08),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF8062FF).withOpacity(.12),
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration,
              min: .4,
              max: 3,
              onChanged: _updateDuration,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.repeat_rounded,
                size: 20,
                color: Color(0xFF65DFFF),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Auto Replay',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _autoPlay,
                activeColor: const Color(0xFF8062FF),
                onChanged: (value) {
                  setState(() {
                    _autoPlay = value;
                  });

                  if (value) {
                    _controller.repeat(reverse: true);
                  } else {
                    _controller.stop();
                    _controller.forward(from: 0);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 850;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 60 : 22,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1200,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 50),
                          Text(
                            'ANIMATION',
                            style: TextStyle(
                              color: const Color(0xFF9B83FF).withOpacity(.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bring your UI\n'
                            'to life.',
                            style: TextStyle(
                              fontSize: 48,
                              height: .98,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Explore beautiful motion effects built entirely '
                            'with Flutter. Select an effect and watch the '
                            'magic happen.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.white.withOpacity(.5),
                            ),
                          ),
                          const SizedBox(height: 42),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      _sectionTitle(
                                        'Live Preview',
                                        'Your animation appears here in real time.',
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: _animatedPreview(),
                                      ),
                                      const SizedBox(height: 25),
                                      SizedBox(
                                        width: 310,
                                        height: 54,
                                        child: ElevatedButton.icon(
                                          onPressed: _playAnimation,
                                          icon: const Icon(
                                            Icons.play_arrow_rounded,
                                          ),
                                          label: const Text(
                                            'PLAY ANIMATION',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF795CFF),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 35),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _sectionTitle(
                                        'Choose Effect',
                                        'Select a motion style.',
                                      ),
                                      const SizedBox(height: 20),
                                      _effectButton(
                                        type: AnimationType.all,
                                        icon: Icons.auto_awesome_rounded,
                                        title: 'All Effects',
                                        subtitle:
                                            'Fade + Slide + Scale + Rotation',
                                      ),
                                      const SizedBox(height: 10),
                                      _effectButton(
                                        type: AnimationType.fade,
                                        icon: Icons.blur_on_rounded,
                                        title: 'Fade',
                                        subtitle: 'Elegant opacity transition',
                                      ),
                                      const SizedBox(height: 10),
                                      _effectButton(
                                        type: AnimationType.slide,
                                        icon: Icons.swipe_rounded,
                                        title: 'Slide',
                                        subtitle: 'Smooth directional movement',
                                      ),
                                      const SizedBox(height: 10),
                                      _effectButton(
                                        type: AnimationType.scale,
                                        icon: Icons.zoom_in_rounded,
                                        title: 'Scale',
                                        subtitle: 'Dynamic size transformation',
                                      ),
                                      const SizedBox(height: 10),
                                      _effectButton(
                                        type: AnimationType.rotation,
                                        icon: Icons.rotate_right_rounded,
                                        title: 'Rotation',
                                        subtitle: 'Fluid rotational motion',
                                      ),
                                      const SizedBox(height: 25),
                                      _controls(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _sectionTitle(
                                  'Live Preview',
                                  'Your animation appears here in real time.',
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: FittedBox(
                                    child: _animatedPreview(),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton.icon(
                                    onPressed: _playAnimation,
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                    ),
                                    label: const Text(
                                      'PLAY ANIMATION',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF795CFF),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 35),
                                _sectionTitle(
                                  'Choose Effect',
                                  'Select a motion style.',
                                ),
                                const SizedBox(height: 20),
                                _effectButton(
                                  type: AnimationType.all,
                                  icon: Icons.auto_awesome_rounded,
                                  title: 'All Effects',
                                  subtitle: 'Fade + Slide + Scale + Rotation',
                                ),
                                const SizedBox(height: 10),
                                _effectButton(
                                  type: AnimationType.fade,
                                  icon: Icons.blur_on_rounded,
                                  title: 'Fade',
                                  subtitle: 'Elegant opacity transition',
                                ),
                                const SizedBox(height: 10),
                                _effectButton(
                                  type: AnimationType.slide,
                                  icon: Icons.swipe_rounded,
                                  title: 'Slide',
                                  subtitle: 'Smooth directional movement',
                                ),
                                const SizedBox(height: 10),
                                _effectButton(
                                  type: AnimationType.scale,
                                  icon: Icons.zoom_in_rounded,
                                  title: 'Scale',
                                  subtitle: 'Dynamic size transformation',
                                ),
                                const SizedBox(height: 10),
                                _effectButton(
                                  type: AnimationType.rotation,
                                  icon: Icons.rotate_right_rounded,
                                  title: 'Rotation',
                                  subtitle: 'Fluid rotational motion',
                                ),
                                const SizedBox(height: 25),
                                _controls(),
                              ],
                            ),
                          const SizedBox(height: 60),
                          Center(
                            child: Text(
                              'CRAFTED WITH FLUTTER  •  MOTION BY DESIGN',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.25),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
