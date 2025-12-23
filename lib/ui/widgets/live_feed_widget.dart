// lib/ui/widgets/live_feed_widget.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/services/parking_service.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/parking/full_screen_live_feed.dart';

class LiveFeedWidget extends StatelessWidget {
  final bool loading;
  final String? sessionId;
  final Uint8List? annotatedImageBytes;

  const LiveFeedWidget({
    super.key,
    required this.loading,
    required this.sessionId,
    this.annotatedImageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, // ⬅️ FIXED HEIGHT (NO OVERFLOW)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (annotatedImageBytes != null && annotatedImageBytes!.isNotEmpty) {
      return _interactive(
        context,
        Image.memory(
          annotatedImageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    if (sessionId == null || sessionId!.isEmpty) {
      return _noFeed();
    }

    final imageUrl = ParkingService.getResultImageUrl(sessionId!);

    return _interactive(
      context,
      Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) => _noFeed(),
      ),
    );
  }

  Widget _interactive(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => FullScreenLiveFeed(
              imageBytes: annotatedImageBytes,
              imageUrl: sessionId != null
                  ? ParkingService.getResultImageUrl(sessionId!)
                  : null,
            ),
          ),
        );
      },
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }

  Widget _noFeed() {
    return const Center(child: Text("Live Feed Tidak Tersedia"));
  }
}
