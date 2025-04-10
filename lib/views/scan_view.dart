import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tup/widgets/result_widgets.dart';

class ScanView extends StatefulWidget {
  final int subscritpionId;
  const ScanView({super.key, required this.subscritpionId});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _enableFlashLight = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('SCAN'),
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon:
                        _enableFlashLight
                            ? Icon(Icons.flash_off)
                            : Icon(Icons.flash_on),
                    onPressed: () {
                      if (_enableFlashLight == false) {
                        _cameraController?.setFlashMode(FlashMode.torch);
                        setState(() {
                          _enableFlashLight = true;
                        });
                      } else {
                        _cameraController?.setFlashMode(FlashMode.off);
                        setState(() {
                          _enableFlashLight = false;
                        });
                      }
                    },
                  ),
                ],
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body:
                  _isPermissionGranted
                      ? Column(
                        children: [
                          Expanded(child: Container()),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.4,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  _scanImage();
                                  _cameraController!.setFlashMode(
                                    FlashMode.off,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      SizedBox(
                                        height: 21,
                                        width: 21,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.57,
                                        ),
                                      ),
                                    if (isLoading) SizedBox(width: 20),
                                    Text(
                                      "Scan Pin",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: const Text(
                            'Camera permission denied',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  /// Asks permission to access the camera. Uses the PermissionHandler plugin
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    /// Selects the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  /// Handles the scanning and text transfer to ResultView.
  /// Displays a Snackbar of an error occured.
  Future<void> _scanImage() async {
    setState(() {
      isLoading = true;
    });
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      file.delete();
      // await navigator.push(
      //   MaterialPageRoute(
      //     builder:
      //         (BuildContext context) => ResultView(
      //           text: recognizedText.text,
      //           subscriptionId: widget.subscritpionId,
      //         ),
      //   ),
      // );
      await resultWidget(context, widget.subscritpionId, recognizedText.text);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred when scanning text')),
        );
      }
    }
  }
}
