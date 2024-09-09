import 'dart:io';
import 'dart:ui';
import 'package:clipboard/clipboard.dart';
import 'package:festival_app/colors/colors.dart';
import 'package:festival_app/utils/utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Color selFontColor = Colors.white;
  String? selImage;
  Color selBackGroundColor = primaryblack;

  List<String> fontFamilies = GoogleFonts.asMap().keys.toList();
  late String? selFont = fontFamilies.isNotEmpty ? fontFamilies.first : null;
  double textSize = 18;
  double dx = 0;
  double dy = 0;
  GlobalKey repaintKey = GlobalKey();

  TextEditingController textController = TextEditingController();
  String customText = '';

  Future<void> shareImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
    repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);

    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var fetchImage = byteData!.buffer.asUint8List();

    Directory directory = await getApplicationCacheDirectory();
    String path = directory.path;

    File file = File('$path/quote_image.png');
    await file.writeAsBytes(fetchImage);

    ShareExtend.share(file.path, "image");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        foregroundColor: Colors.white,
        title: Text(
          "Edit Screen",
          style: TextStyalling.appbar_title,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(customText).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    content: Text("Copied successfully..."),
                  ),
                );
              });
            },
            style: IconButton.styleFrom(
              hoverColor: Colors.greenAccent,
            ),
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splace_screen.webp.webp',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(
                  key: repaintKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 420,
                    width: double.infinity,
                    alignment: Alignment(dx, dy),
                    decoration: BoxDecoration(
                      color: selBackGroundColor,
                      borderRadius: BorderRadius.circular(20),
                      image: selImage != null
                          ? DecorationImage(
                        image: NetworkImage(selImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: SelectableText(
                      textAlign: TextAlign.center,
                      customText.isNotEmpty
                          ? customText
                          : "Enter your text here...",
                      style: GoogleFonts.getFont(
                        selFont!,
                        textStyle: TextStyle(
                          fontSize: textSize,
                          color: selFontColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Enter Your Text:",
                                style: TextStyalling.fontsize,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: textController,
                                onChanged: (text) {
                                  setState(() {
                                    customText = text;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Type your text here...',
                                  helperStyle: TextStyalling.fontsize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Image:",
                                style: TextStyalling.fontsize,
                              ),
                              const SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                  data['f_image'].map<Widget>((imagePath) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selImage = imagePath;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.purple,
                                          image: DecorationImage(
                                            image: NetworkImage(imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Fonts:",
                                style: TextStyalling.fontsize,
                              ),
                              const SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: fontFamilies.take(20).map((font) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selFont = font;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Aa",
                                          style: GoogleFonts.getFont(
                                            font,
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Font Colors:",
                                style: TextStyalling.fontsize,
                              ),
                              const SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                  Colors.primaries.map<Widget>((color) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selFontColor = color;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Horizontal Alignment:",
                                style: TextStyalling.fontsize,
                              ),
                              Slider(
                                value: dx,
                                min: -1.0,
                                max: 1.0,
                                onChanged: (val) {
                                  setState(() {
                                    dx = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Vertical Alignment:",
                                style: TextStyalling.fontsize,
                              ),
                              Slider(
                                value: dy,
                                min: -0.95,
                                max: 0.95,
                                onChanged: (val) {
                                  setState(() {
                                    dy = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Font Size:",
                                style: TextStyalling.fontsize,
                              ),
                              Slider(
                                value: textSize,
                                min: 10,
                                max: 50,
                                onChanged: (val) {
                                  setState(() {
                                    textSize = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await shareImage();
        },
        child: const Icon(Icons.share_rounded),
      ),
    );
  }
}
