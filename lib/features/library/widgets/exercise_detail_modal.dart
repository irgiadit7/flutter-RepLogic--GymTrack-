import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/local/database.dart';

class ExerciseDetailModal extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailModal({super.key, required this.exercise});

  @override
  State<ExerciseDetailModal> createState() => _ExerciseDetailModalState();
}

class _ExerciseDetailModalState extends State<ExerciseDetailModal> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.youtubeUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(widget.exercise.youtubeUrl!);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            controlsVisibleAtStart: true,
            
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return _buildContent(isFullScreen: false);
    }

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFF00FF00),
        topActions: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.exercise.name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      builder: (context, player) {
        return Column(
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Player Video
            player,
            // Sisa Konten (Deskripsi dll)
            Expanded(child: _buildContent(isFullScreen: false)),
          ],
        );
      },
    );
  }

  Widget _buildContent({required bool isFullScreen}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_controller == null) ...[
            const Center(
              child: Icon(Icons.videocam_off, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],

          Text(
            widget.exercise.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(widget.exercise.bodyPart ?? 'General', Colors.blue),
              _buildTag(widget.exercise.category, Colors.orange),
              if (widget.exercise.targetMuscle != null)
                _buildTag(widget.exercise.targetMuscle!, Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            "EXECUTION CUES",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.exercise.instructions ?? "No instructions provided.",
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
