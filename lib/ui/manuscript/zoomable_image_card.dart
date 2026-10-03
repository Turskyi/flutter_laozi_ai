import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/reading_guide_dialog.dart';
import 'package:laozi_ai/ui/manuscript/zoomable_image_fullscreen_overlay.dart';

class ZoomableImageCard extends StatefulWidget {
  const ZoomableImageCard({
    required this.imageSrc,
    required this.caption,
    required this.pageNumber,
    required this.totalPages,
    required this.onPageSelected,
    this.isFullscreen = false,
    this.onToggleFullscreen,
    super.key,
  });

  final String imageSrc;
  final String caption;
  final int pageNumber;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final bool isFullscreen;
  final VoidCallback? onToggleFullscreen;

  @override
  State<ZoomableImageCard> createState() => _ZoomableImageCardState();
}

class _ZoomableImageCardState extends State<ZoomableImageCard> {
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

    if (widget.isFullscreen) {
      return ZoomableImageFullscreenOverlay(
        imageSrc: widget.imageSrc,
        caption: widget.caption,
        pageNumber: widget.pageNumber,
        totalPages: widget.totalPages,
        onPageSelected: widget.onPageSelected,
        onToggleFullscreen: widget.onToggleFullscreen,
      );
    } else {
      return Card(
        margin: const EdgeInsets.all(6),
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        child: Column(
          children: <Widget>[
            // Header Controls Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Zoom Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.zoom_out, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: _scale > 0.75 ? _zoomOut : null,
                        tooltip: 'Zoom Out',
                      ),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${(_scale * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_in, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: _scale < 3.5 ? _zoomIn : null,
                        tooltip: 'Zoom In',
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: _scale != 1.0 ? _resetZoom : null,
                        tooltip: 'Reset Zoom',
                      ),
                    ],
                  ),

                  // Hint & Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext ctx, BoxConstraints constraints) {
                              if (MediaQuery.of(context).size.width > 600) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    translate('manuscript.drag_to_pan'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                      ),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => ReadingGuideDialog.show(context),
                        icon: const Icon(Icons.info_outline, size: 14),
                        label: Text(
                          translate('manuscript.reading_guide'),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: widget.onToggleFullscreen,
                        icon: const Icon(Icons.fullscreen, size: 14),
                        label: Text(
                          translate('manuscript.fullscreen'),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Interactive Image Area
            Expanded(
              child: Container(
                color: Colors.black87,
                width: double.infinity,
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
                      child: Image.asset(
                        widget.imageSrc,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (
                              BuildContext _,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Caption Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Text(
                widget.caption,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
