import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:puzzle_app/constants/constants.dart';
import 'package:puzzle_app/controllers/animation_status_controller.dart';
import 'package:puzzle_app/controllers/hint_controller.dart';
import 'package:puzzle_app/controllers/order_controller.dart';
import 'package:puzzle_app/controllers/puzzle_controller.dart';
import 'package:puzzle_app/models/puzzle.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class PuzzleDraggableTile extends StatefulWidget {
  final Puzzle currentChild;
  final Widget child;
  final bool isActiveChild;
  final Alignment currentChildAlignment;
  final Alignment destinationChildAlignment;
  final int index;
  final int endingCardValue;

  const PuzzleDraggableTile({
    Key? key,
    required this.currentChild,
    required this.child,
    required this.isActiveChild,
    required this.currentChildAlignment,
    required this.destinationChildAlignment,
    required this.index,
    required this.endingCardValue,
  }) : super(key: key);

  @override
  _PuzzleDraggableTileState createState() => _PuzzleDraggableTileState();
}

class _PuzzleDraggableTileState extends State<PuzzleDraggableTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment>? _animation;

  late bool isHorizontal;

  Alignment oldAlign = const Alignment(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _controller.addListener(_listener);
    _animation = _controller.drive(AlignmentTween(begin: oldAlign, end: widget.currentChildAlignment));
    _controller.forward();
    oldAlign = _dragAlignment = widget.currentChildAlignment;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<HintController>(context, listen: true).addListener(() {
      if (mounted) {
        var pro = context.read<HintController>();
        Puzzle puzzle = pro.puzzle!;
        if(puzzle.cardValue == widget.currentChild.cardValue) {
          _controller.reset();
          _animation = _controller.drive(AlignmentTween(begin: widget.currentChildAlignment, end: widget.destinationChildAlignment));
          _controller.forward().then((value) {
            _dragAlignment = widget.currentChildAlignment;
            Provider.of<PuzzleController>(context, listen: false).swapChildren(widget.currentChild);
          });
        }
      }
    });

    Provider.of<OrderController>(context, listen: true).addListener(() {
      if (mounted) {
        var pro = context.read<OrderController>();
        var puzzlePro = context.read<PuzzleController>();
        bool isOrdering = pro.isOrdering;
        
        if(isOrdering) {
          int firstCardValue = puzzlePro.endingCardValue - 8;
          Alignment dest = d3Aligns[widget.currentChild.cardValue - firstCardValue];
          _controller.reset();
          _animation = _controller.drive(AlignmentTween(begin: widget.currentChildAlignment, end: dest));
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isHorizontal = widget.currentChildAlignment.y == widget.destinationChildAlignment.y;
    final size = MediaQuery.of(context).size;
    bool isHolder = widget.currentChild.cardValue == widget.endingCardValue;
    //double minVerticalBound = min(widget.currentChildAlignment.y, widget.destinationChildAlignment.y);
    //double maxVerticalBound = max(widget.currentChildAlignment.y, widget.destinationChildAlignment.y);
    //double minHorizontalBound = min(widget.currentChildAlignment.x, widget.destinationChildAlignment.x);
    //double maxHorizontalBound = max(widget.currentChildAlignment.x, widget.destinationChildAlignment.x);
    return Consumer<AnimationStatusController>(builder: (context, controller, child) {
      return GestureDetector(
        onPanDown: (details) => _onPanDown(details, isHolder, size, controller.isSomeoneAnimating),
        // onVerticalDragUpdate:
        //     isHorizontal ? null : (details) => _onVerticalDragUpdate(details, size, isHolder, minVerticalBound, maxVerticalBound),
        // onHorizontalDragUpdate:
        //     !isHorizontal ? null : (details) => _onHorizontalDragUpdate(details, size, isHolder, minHorizontalBound, maxHorizontalBound),
        // onHorizontalDragEnd:
        //     !isHorizontal ? null : (details) => _onHorizontalDragEnd(details, minHorizontalBound, maxHorizontalBound, size, isHolder),
        // onVerticalDragEnd: isHorizontal ? null : (details) => _onVerticalDragEnd(details, minVerticalBound, maxVerticalBound, size, isHolder),
        child: Align(
          alignment: _dragAlignment,
          child: widget.child,
        ),
      );
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, Size size, bool isHolder, double min, double max) {
    developer.log("_onVerticalDragUpdate " + widget.currentChild.cardValue.toString());
    if (!isHolder) {
      if (widget.isActiveChild) {
        double dx = details.delta.dx / (size.height / 2);
        double dy = details.delta.dy / (size.height / 2);

        var alignment = _dragAlignment + Alignment(dx, dy);

        if (alignment.y <= max && alignment.y >= min) {
          setState(() {
            _dragAlignment += Alignment(dx, dy);
          });
        }
      }
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, Size size, bool isHolder, double min, double max) {
    developer.log("_onHorizontalDragUpdate " + widget.currentChild.cardValue.toString());
    if (!isHolder) {
      if (widget.isActiveChild) {
        double dx = details.delta.dx / (size.height / 2);
        double dy = details.delta.dy / (size.height / 2);

        var alignment = _dragAlignment + Alignment(dx, dy);

        if (alignment.x <= max && alignment.x >= min) {
          setState(() {
            _dragAlignment += Alignment(dx, dy);
          });
        }
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details, double min, double max, Size size, bool isHolder) {
    developer.log("_onHorizontalDragEnd " + widget.currentChild.cardValue.toString());
    if (!isHolder && widget.isActiveChild) {
      bool wasValueMin = _getValueXMin(min, max);
      Alignment destAlign;
      if (wasValueMin) {
        destAlign = widget.currentChildAlignment;
      } else {
        destAlign = widget.destinationChildAlignment;
      }
      _animation = _controller.drive(AlignmentTween(begin: _dragAlignment, end: destAlign));
      _animate(details.velocity.pixelsPerSecond, size);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details, double min, double max, Size size, bool isHolder) {
    developer.log("_onVerticalDragEnd " + widget.currentChild.cardValue.toString());
    if (!isHolder && widget.isActiveChild) {
      bool wasValueMin = _getValueYMin(min, max);
      Alignment destAlign;
      if (wasValueMin) {
        destAlign = widget.currentChildAlignment;
      } else {
        destAlign = widget.destinationChildAlignment;
      }
      _animation = _controller.drive(AlignmentTween(begin: _dragAlignment, end: destAlign));
      _animate(details.velocity.pixelsPerSecond, size);
    }
  }

  bool _getValueXMin(double min, double max) {
    double bound = (min + max) / 2;

    bool isLTR = min == widget.currentChildAlignment.x;

    if (isLTR) {
      return _dragAlignment.x < bound;
    } else {
      return _dragAlignment.x > bound;
    }
  }

  bool _getValueYMin(double min, double max) {
    double bound = (min + max) / 2;

    bool isTTB = min == widget.currentChildAlignment.y;

    if (isTTB) {
      return _dragAlignment.y < bound;
    } else {
      return _dragAlignment.y > bound;
    }
  }

  void _animate(Offset pixelsPerSecond, size) {
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 100,
      stiffness: 1,
      damping: 1,
    );
    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation).then((value) {
      _dragAlignment = widget.currentChildAlignment;
      Provider.of<PuzzleController>(context, listen: false).swapChildren(widget.currentChild);
    });
  }

  void _listener() {
    setState(() {
      _dragAlignment = _animation!.value;
      Provider.of<AnimationStatusController>(context, listen: false).updateStatus(_controller.isAnimating);
    });
  }

  void _onPanDown(DragDownDetails details, bool isHolder, Size size, bool isSomeoneAnimating) {
    developer.log("_onPanDown " + widget.currentChild.cardValue.toString());
    if (isSomeoneAnimating) return;
    if (!isHolder && widget.isActiveChild) {
      _animation = _controller.drive(AlignmentTween(begin: _dragAlignment, end: widget.destinationChildAlignment));
      _animate(details.globalPosition, size);
    }
  }
}
