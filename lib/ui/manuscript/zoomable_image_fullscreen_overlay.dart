import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';
import 'package:laozi_ai/ui/manuscript/reading_guide_dialog.dart';

class ZoomableImageFullscreenOverlay extends StatefulWidget {
  const ZoomableImageFullscreenOverlay({
    required this.imageSrc,
    required this.caption,
    required this.pageNumber,
    required this.totalPages,
    required this.onPageSelected,
    required this.onToggleFullscreen,
    super.key,
  });

  final String imageSrc;
  final String caption;
  final int pageNumber;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final VoidCallback? onToggleFullscreen;

  @override
  State<ZoomableImageFullscreenOverlay> createState() =>
      _ZoomableImageFullscreenOverlayState();
}

class _ZoomableImageFullscreenOverlayState
    extends State<ZoomableImageFullscreenOverlay> {
  final TransformationController _transformationController =
      TransformationController();
  double _scale = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale + 0.25).clamp(0.75, 3.5);
      _transformationController.value = Matrix4.diagonal3Values(
        _scale,
        _scale,
        1.0,
      );
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.25).clamp(0.75, 3.5);
      _transformationController.value = Matrix4.diagonal3Values(
        _scale,
        _scale,
        1.0,
      );
    });
  }

  void _resetZoom() {
    setState(() {
      _scale = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        automaticallyImplyLeading: false,
        titleSpacing: 4,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              // Navigation
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: widget.pageNumber > kMinManuscriptPage
                    ? () => widget.onPageSelected(widget.pageNumber - 1)
                    : null,
              ),
              Text(
                '${translate('manuscript.page')} ${widget.pageNumber} '
                '${translate('manuscript.of')} ${widget.totalPages}',
                style: textTheme.bodyMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: widget.pageNumber < kMaxManuscriptPage
                    ? () => widget.onPageSelected(widget.pageNumber + 1)
                    : null,
              ),

              const SizedBox(width: 4),

              // Zoom Controls
              IconButton(
                icon: const Icon(Icons.zoom_out, size: 18),
                onPressed: _scale > 0.75 ? _zoomOut : null,
              ),
              Text(
                '${(_scale * 100).round()}%',
                style: textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in, size: 18),
                onPressed: _scale < 3.5 ? _zoomIn : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 16),
                onPressed: _scale != 1.0 ? _resetZoom : null,
              ),

              const SizedBox(width: 4),

              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  foregroundColor: colorScheme.onSecondaryContainer,
                  backgroundColor: colorScheme.secondaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => ReadingGuideDialog.show(context),
                icon: const Icon(Icons.info_outline, size: 14),
                label: Text(
                  translate('manuscript.reading_guide'),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  foregroundColor: colorScheme.onSecondaryContainer,
                  backgroundColor: colorScheme.secondaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: widget.onToggleFullscreen,
                icon: const Icon(Icons.fullscreen_exit, size: 16),
                label: Text(
                  translate('manuscript.exit'),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ClipRect(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.75,
                maxScale: 3.5,
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    _scale = _transformationController.value
                        .getMaxScaleOnAxis();
                  });
                },
                child: Center(
                  child: Image.asset(widget.imageSrc, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.black87,
            child: Text(
              widget.caption,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
