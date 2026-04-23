import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:new_mama/core/helper/app_toast.dart';

class FullScreenImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final bool showDownloadButton;

  const FullScreenImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.showDownloadButton = false,
  });

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      AppToast.info(context, message: 'Downloading image...');
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      
      final fileName = url.split('/').last.replaceAll(RegExp(r'[^a-zA-Z0-9.\-]'), '_').split('?').first;
      final savePath = '${dir.path}/${fileName.endsWith('.jpg') || fileName.endsWith('.png') ? fileName : '$fileName.jpg'}';
      
      await dio.download(url, savePath);
      
      if (context.mounted) {
        AppToast.success(context, message: 'Image downloaded successfully');
        OpenFile.open(savePath);
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.error(context, message: 'Failed to download image.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.showDownloadButton
            ? [
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () => _downloadImage(context, widget.images[_currentIndex]),
                ),
              ]
            : null,
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: widget.images[index],
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              placeholder: (_, _) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (_, _, _) => Center(
                child: Icon(Icons.error, color: Theme.of(context).colorScheme.primary, size: 48),
              ),
            ),
          );
        },
      ),
    );
  }
}

