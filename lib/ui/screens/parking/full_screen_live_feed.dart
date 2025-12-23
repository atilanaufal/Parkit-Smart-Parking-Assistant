// lib/ui/widgets/full_screen_live_feed.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Fullscreen live feed viewer
/// - pinch zoom & pan
/// - swipe down to dismiss
class FullScreenLiveFeed extends StatefulWidget {
  final Uint8List? imageBytes;

  /// URL sudah ABSOLUTE (dibentuk di ParkingService / LiveFeedWidget)
  final String? imageUrl;

  const FullScreenLiveFeed({super.key, this.imageBytes, this.imageUrl});

  @override
  State<FullScreenLiveFeed> createState() => _FullScreenLiveFeedState();
}

class _FullScreenLiveFeedState extends State<FullScreenLiveFeed>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;

  late final AnimationController _animController;
  Animation<Offset>? _animOffset;

  double get _backgroundOpacity {
    final dy = _dragOffset.dy.abs();
    return (1.0 - (dy / 400.0)).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          if (_animOffset != null) {
            setState(() {
              _dragOffset = _animOffset!.value;
            });
          }
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // =============================
  // GESTURE
  // =============================
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += Offset(0, details.delta.dy);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _animOffset = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController
      ..reset()
      ..forward();
  }

  // =============================
  // IMAGE BUILDER
  // =============================
  Widget _buildImage() {
    if (widget.imageBytes != null && widget.imageBytes!.isNotEmpty) {
      return Image.memory(
        widget.imageBytes!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) =>
            const Center(child: Text("Gagal memuat gambar")),
      );
    }

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return const Center(child: Text("Tidak ada gambar"));
    }

    return Image.network(
      widget.imageUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (_, __, ___) =>
          const Center(child: Text("Gagal memuat gambar")),
    );
  }

  // =============================
  // BUILD
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Stack(
          children: [
            /// Background dim
            Opacity(
              opacity: _backgroundOpacity,
              child: Container(color: Colors.black),
            ),

            /// Image
            SafeArea(
              child: Center(
                child: Transform.translate(
                  offset: _dragOffset,
                  child: InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    boundaryMargin: const EdgeInsets.all(40),
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: _buildImage(),
                  ),
                ),
              ),
            ),

            /// Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
