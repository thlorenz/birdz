import 'package:birdz/bird.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        Container,
        LeafRenderObjectWidget,
        PaintingContext,
        RenderBox,
        StatelessWidget,
        Widget,
        WidgetsBinding,
        WidgetsBindingObserver;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class BirdWidget extends StatelessWidget {
  final Bird bird;
  final Color background;

  const BirdWidget(this.bird, {this.background = Colors.transparent});

  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          border: Border.all(
            color: Colors.black,
            width: 8,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _EmbeddedBirdWidget(bird),
      ),
    );
  }
}

class _EmbeddedBirdWidget extends LeafRenderObjectWidget {
  final Bird bird;
  final Size size;

  const _EmbeddedBirdWidget(this.bird, {this.size});

  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: _BirdRenderBox(context, bird),
        additionalConstraints: BoxConstraints.expand(
          width: size?.width,
          height: size?.height,
        ));
  }

  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox) {
    renderBox
      ..child = _BirdRenderBox(context, bird)
      ..additionalConstraints =
          BoxConstraints.expand(width: size?.width, height: size?.height);
  }
}

class _BirdRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  final Bird bird;
  int _frameCallbackId;

  _BirdRenderBox(this.context, this.bird);

  bool get sizedByParent => true;

  void performResize() {
    super.performResize();
    bird.resize(constraints.smallest);
  }

  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scheduleTick();
    _bindLifecycleListener();
  }

  void detach() {
    super.detach();
    bird.onDetach();
    _unscheduleTick();
    _unbindLifecycleListener();
  }

  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    bird.render(context.canvas);
    context.canvas.restore();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _tick(Duration ts) {
    if (!attached) return;
    _scheduleTick();
    _update(ts.inMicroseconds / Duration.microsecondsPerMillisecond);
    markNeedsPaint();
  }

  void _update(double ts) {
    bird.update(ts);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
