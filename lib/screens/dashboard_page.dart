import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:image/image.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:klearn/utils/detector_painters.dart';
import 'package:klearn/widgets/side_drawer.dart';
import 'package:path_provider/path_provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      // body: Container(child: Text('Dashboard')),
      body: OCRScanner(),
      drawer: SideDrawer(),
    );
  }
}

class OCRScanner extends StatefulWidget {
  @override
  _OCRScannerState createState() => _OCRScannerState();
}

class _OCRScannerState extends State<OCRScanner> {
  File _imageFile;
  Size _imageSize;
  dynamic _scanResults;
  Detector _currentDetector = Detector.text;
  final _signPadKey = GlobalKey<SignatureState>();
  ByteData _img = ByteData(0);

  final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();
  Future<void> _getAndScanImage(File imgFile) async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile = (imgFile == null)
        ? await ImagePicker.pickImage(source: ImageSource.gallery)
        : imgFile;

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    if (imageFile == null) {
      var imgData = await _signPadKey.currentState.getData();
      completer.complete(Size(
        imgData.width.toDouble(),
        imgData.height.toDouble(),
      ));
    } else {
      final Image image = Image.file(imageFile);
      // final Image image = Image.asset('img/test_text.png');
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        }),
      );
    }
    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });
    FirebaseVisionImage visionImage;
    if (imageFile != null) {
      visionImage = FirebaseVisionImage.fromFile(imageFile);
    } else {
      // final AssetBundle bundle = DefaultAssetBundle.of(context);
      // final filename = 'test_text.png';
      // var bytes = await bundle.load("assets/img/$filename");

      var imgData = await _signPadKey.currentState.getData();
      var data = await imgData.toByteData(format: ui.ImageByteFormat.rawRgba);

      final planeMetadata = FirebaseVisionImagePlaneMetadata(
        width: imgData.width,
        height: imgData.height,
        bytesPerRow: imgData.width * 4,
      );

      final metadata = FirebaseVisionImageMetadata(
        size: Size(imgData.width.toDouble(), imgData.height.toDouble()),
        planeData: List()
          ..add(planeMetadata)
          ..add(planeMetadata)
          ..add(planeMetadata)
          ..add(planeMetadata),
        // kCVPixelFormatType_32RGBA
        rawFormat: 'RGBA',
        // rawFormat: 'kCVPixelFormatType_32RGBA',
      );

      // var img = Image.memory(data.buffer.asUint8List());
      visionImage =
          FirebaseVisionImage.fromBytes(data.buffer.asUint8List(), metadata);

      // final planeMetadata = FirebaseVisionImagePlaneMetadata(
      //   width: 1920,
      //   height: 1080,
      //   bytesPerRow: 1920 * 4,
      // );

      // final metadata = FirebaseVisionImageMetadata(
      //   size: Size(1920, 1080),
      //   planeData: List()..add(planeMetadata),
      //   // kCVPixelFormatType_32RGBA
      //   rawFormat: 'RGBA',
      // );

      // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
      //     bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      //     metadata);
    }
    dynamic results;
    switch (_currentDetector) {
      case Detector.text:
        results = await _recognizer.processImage(visionImage);
        debugPrint((results as VisionText)
            .blocks
            .map((block) => block.text)
            .join(','));
        break;
      default:
        return;
    }

    setState(() {
      _scanResults = results;
    });
  }

  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter;

    switch (_currentDetector) {
      case Detector.text:
        painter = TextDetectorPainter(_imageSize, results);
        break;
      default:
        break;
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(_imageFile).image,
          fit: BoxFit.fill,
        ),
      ),
      child: _imageSize == null || _scanResults == null
          ? const Center(
              child: Text(
                'Scanning...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : _buildResults(_imageSize, _scanResults),
    );
  }

  Future<File> writeToFile(ByteData data, List<int> pngData, String path) {
    final buffer = data.buffer;
    if (pngData == null)
      return new File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          flush: true);
    else
      return new File(path).writeAsBytes(pngData, flush: true);
  }

  Future<File> createFileOfAsset(ByteData data, List<int> pngData) async {
    final AssetBundle bundle = DefaultAssetBundle.of(context);
    final filename = 'test_text.png';
    // var bytes = await bundle.load("assets/img/$filename");

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await writeToFile(data, pngData, '$dir/$filename');
    // File file = new File('$dir/$filename');
    debugPrint('${file.path}');

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile == null
        ? Center(
            child: Column(
            children: <Widget>[
              Text('No image selected.'),
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () async {
                  // final imageFile = await createFileOfAsset();
                  // if (imageFile != null) _getAndScanImage(imageFile);
                  _getAndScanImage(null);
                },
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(
                      color: Colors.black, // Color of the drawing path
                      strokeWidth: 5.0, // with
                      onSign: () {
                        final sign = _signPadKey.currentState;
                        debugPrint(
                            '${sign.points.length} points in the signature');
                      },
                      // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                      backgroundPainter: null,
                      key: _signPadKey,
                    ),
                  ),
                  color: Colors.black12,
                ),
              ),
              _img.buffer.lengthInBytes == 0
                  ? Container()
                  : LimitedBox(
                      maxHeight: 200.0,
                      child: Image.memory(_img.buffer.asUint8List())),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: Colors.green,
                          onPressed: () async {
                            final sign = _signPadKey.currentState;

                            //retrieve image data, do whatever you want with it (send to server, save locally...)
                            final image = await sign.getData();
                            var data = await image.toByteData(
                                format: ui.ImageByteFormat.rawRgba);
                            var img = prefix0.Image.fromBytes(image.width,
                                image.height, data.buffer.asUint8List());
                            var png = prefix0.encodePng(img);
                            sign.clear();
                            final File file =
                                await createFileOfAsset(data, png);
                            _getAndScanImage(file);
                            // await _getImageSize(null);
                            // await _scanImage(null);
                            final encoded =
                                base64.encode(data.buffer.asUint8List());
                            setState(() {
                              _img = data;
                            });
                            // debugPrint("onPressed " + encoded);
                          },
                          child: Text("Save")),
                      MaterialButton(
                          color: Colors.grey,
                          onPressed: () {
                            final sign = _signPadKey.currentState;
                            sign.clear();
                            setState(() {
                              _img = ByteData(0);
                            });
                            debugPrint("cleared");
                          },
                          child: Text("Clear")),
                    ],
                  ),
                ],
              ),
            ],
          ))
        : _buildImage();
  }

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
