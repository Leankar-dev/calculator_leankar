import 'dart:async';

import 'package:calculator_05122025/controllers/splash_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/splash_status.dart';
import 'package:calculator_05122025/widgets/splash/splash_background_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_content_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SplashPage extends StatefulWidget {
  final WidgetBuilder nextPageBuilder;
  final VoidCallback? onFirstFrame;
  final SplashController? controller;

  const SplashPage({
    super.key,
    required this.nextPageBuilder,
    this.onFirstFrame,
    this.controller,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const Animation<double> _reducedMotionAnimation =
      AlwaysStoppedAnimation<double>(AppSplashTimeline.reducedMotionFrame);

  late final AnimationController _animationController;
  late final SplashController _controller;
  late final bool _ownsController;
  Timer? _precacheTimeoutTimer;
  Timer? _reducedMotionTimer;
  Timer? _handoffTimer;
  bool _launched = false;
  bool _skipAnimationStarted = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppSplashTimeline.totalDuration,
    );
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? SplashController();
    _animationController.addListener(_handleAnimationTick);
    _animationController.addStatusListener(_handleAnimationStatus);
    _controller.addListener(_handleControllerChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFirstFrame?.call();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_launched) return;
    _launched = true;
    _launch(MediaQuery.disableAnimationsOf(context));
  }

  Future<void> _launch(bool reduceMotion) async {
    await _precacheLogo();
    if (!mounted) return;
    _controller.start(reduceMotion: reduceMotion);
    if (reduceMotion) {
      _reducedMotionTimer = Timer(
        AppSplashTimeline.nativeHandoffDelay +
            AppSplashTimeline.reducedMotionHold,
        _controller.finish,
      );
      return;
    }
    _handoffTimer = Timer(
      AppSplashTimeline.nativeHandoffDelay,
      _animationController.forward,
    );
  }

  Future<void> _precacheLogo() {
    final completer = Completer<void>();
    void complete() {
      if (!completer.isCompleted) completer.complete();
    }

    _precacheTimeoutTimer = Timer(AppSplashTimeline.precacheTimeout, complete);
    precacheImage(
      const AssetImage(AppStrings.splashLogoAssetPath),
      context,
    ).whenComplete(complete);
    return completer.future.whenComplete(() => _precacheTimeoutTimer?.cancel());
  }

  void _handleAnimationTick() {
    final reachedExit =
        _animationController.value >= AppSplashTimeline.exitStart;
    if (reachedExit && _controller.state.status == SplashStatus.running) {
      _controller.beginExit();
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.finish();
    }
  }

  void _handleControllerChange() {
    final state = _controller.state;
    if (state.isFinished) {
      _navigateToNextPage(state.reduceMotion);
      return;
    }
    if (state.skipRequested && !_skipAnimationStarted) {
      _skipAnimationStarted = true;
      _skip(state.reduceMotion);
    }
  }

  void _skip(bool reduceMotion) {
    if (reduceMotion) {
      _reducedMotionTimer?.cancel();
      _controller.finish();
      return;
    }
    _handoffTimer?.cancel();
    _animationController.animateTo(
      1.0,
      duration: AppSplashTimeline.skipDuration,
      curve: Curves.easeIn,
    );
  }

  void _navigateToNextPage(bool reduceMotion) {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: reduceMotion
            ? AppSplashTimeline.reducedMotionTransition
            : AppSplashTimeline.routeTransitionDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.nextPageBuilder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _precacheTimeoutTimer?.cancel();
    _reducedMotionTimer?.cancel();
    _handoffTimer?.cancel();
    _animationController.removeListener(_handleAnimationTick);
    _animationController.removeStatusListener(_handleAnimationStatus);
    _controller.removeListener(_handleControllerChange);
    _animationController.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final Animation<double> animation = reduceMotion
        ? _reducedMotionAnimation
        : _animationController;
    return Scaffold(
      backgroundColor: AppColors.splashNativeFlat,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Semantics(
          container: true,
          label: l10n.splashSemanticLabel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _controller.requestSkip,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SplashBackgroundWidget(animation: animation),
                SplashContentWidget(
                  animation: animation,
                  showOrbit: !reduceMotion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
