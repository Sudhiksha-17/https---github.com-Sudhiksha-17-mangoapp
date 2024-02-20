import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'pdfmaps.dart'; // Import the PdfMapsPage

class VideosPage extends StatelessWidget {
  final String farmId;

  const VideosPage({Key? key, required this.farmId}) : super(key: key);

  Future<List<String>> fetchVideoUrls() async {
    try {
      // Construct the Firebase Storage path for videos
      String storagePath =
          'users/${FirebaseAuth.instance.currentUser?.uid}/$farmId/videos/';

      print('Farm ID: $farmId'); // Print the farmId

      // Reference to the Firebase Storage folder for videos
      Reference storageRef = FirebaseStorage.instance.ref().child(storagePath);

      // List all items (videos) in the folder
      ListResult result = await storageRef.listAll();

      // Get the download URLs for each item (video)
      List<String> urls = await Future.wait(
          result.items.map((item) => item.getDownloadURL()).toList());

      return urls;
    } catch (e) {
      print('Error fetching video URLs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        backgroundColor: Color(0xffffc900),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff054500),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchVideoUrls(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> videoUrls = snapshot.data ?? [];
            if (videoUrls.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No videos found.'),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to PdfMapsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfMapsPage(farmId: farmId)),
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Videos Display Area',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(videoUrls.length, (index) {
                      return VideoPreviewWidget(videoUrl: videoUrls[index]);
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Add space between video area and the button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to PdfMapsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfMapsPage(farmId: farmId)),
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class VideoPreviewWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPreviewWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoPreviewWidgetState createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FullScreenVideoPlayer(videoUrl: widget.videoUrl),
          ),
        );
      },
      child: Container(
        width: 300,
        height: 300,
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        backgroundColor: Color(0xff054500),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: VideosPage(farmId: 'exampleFarmId'), // Pass your farmId here
  ));
}
