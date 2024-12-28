import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/HeatDataInfo.dart';
import '../../data/models/HeatSequence.dart';
import '../../data/models/ImageCarousel.dart';
import '../../data/models/JobPanelData.dart';
import '../../data/models/TimeInfo.dart';
import '../../data/models/config/DeviceConfig.dart';
import '../../data/models/config/HeatSequenceConfig.dart';
import '../../data/models/config/Global5Config.dart';
import '../../data/models/config/ImageCarouselConfig.dart';
import '../../data/models/ws/EntryData.dart';
import '../../views/screens/change_device_mode.dart';
import '../../utils/JobPanelDataProcess.dart';
import '../../utils/LoadHeats.dart';
import '../../utils/LoadJobPanel.dart';
import '../../data/models/ws/carousel.dart';
import '../../data/models/ws/heats.dart';
import 'package:intl/intl.dart';
import '../../utils/HeatDataProcess.dart';
import '../../utils/LoadContent.dart';
import '../../data/models/config/EventConfig.dart';
import '../../utils/Preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../utils/WebSocketUtil.dart';
import '../../data/models/ws/WebSocketListener.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../data/dao/TimeInfoDao.dart';
import '../../data/models/HeatData.dart';

class Mode2 extends StatefulWidget {
  @override
  _Mode2State createState() => new _Mode2State();
}

class _Mode2State extends State<Mode2> with SingleTickerProviderStateMixin {
  String? labelTime;
  DateTime? dateTime, _lastActiveTime;
  Timer? timer;
  var doneSlide = 0;
  var heatSlide = 0;
  var deckSlide = 1;
  // var heatDescStarted;
  // var heatDescNext;
  //List<dynamic> heatDescDone = [];
  String? descName;

  bool animate = false;
  var initData;
  double percent = 0;
  List doneData = [];
  var genUrl;
  var toRemove = [];
  List<Heats> _heats = [];
  List<Carousel> _carousel = [];
  List<Widget> rightSlides = [];
  List<Widget> leftSlides = [];
  int? danceLength;

  // int nextHeatId = 0;
  int doneHeatId = 0;
  String? doneHeatName;
  String? heatDescDone;
  int heatId = 0;
  String? heatName;
  String? heatDescStarted;
  int? nextHeatId;
  String? nextHeatName;
  String? heatDescNext;
  bool isFormation = false;
  List<ImageCarousel>? _imageCarousel;

  List<JobPanelData>? _jobPanels;
  List<HeatData>? _heatDataList;
  var _jobPanelData = JobPanelDataProcess();
  var _heatDataProcess = HeatDataProcess();

  bool heatStarted = false;
  bool isAnimationRunning = false;

  double _width = 50.0;
  double _pgWidth = 0.0;
  int pgDuration = 0;

  int dur = 0;
  double carouselBar = 1.0;

  String deviceNumber = "";
  bool isRPIFail = false;
  String recallStatus = 'recallDisabled';

  int maxContain = 16;
  int pageMax = 1;
  int pageNum = 1;

  List<ParticipantInfo> participants = [];

  final GlobalKey containerKey = GlobalKey();
  double? containerSize;

  OverlayEntry? overlayEntry;

  HeatSequence? heatStatus;

  // String _storedValue = Preferences.getSharedValue("recall");

  // @override
  // void initState() {
  //   super.initState();
  //   _getSharedValue();
  // }

  // void _getSharedValue() async {
  //   setState(() {
  //     _storedValue = Preferences.getSharedValue("recall");
  //   });
  // }

  get resp => null;

  void _updateState({bool stats = false, double defWidth = 50.0}) {
    if (!stats) {
      setState(() {
        _width = defWidth;
        dur = 0;
      });
    } else {
      setState(() {
        dur = 6000;
        _width = double.infinity;
      });
    }
  }

  Future<List<Heats>> getHeats() async {
    var url = "http://${genUrl}/uberPlatform/cache/heats";
    var response = await http.get(Uri.parse(url));
    List<Heats> heats = [];
    print(response);
    try {
      if (response.statusCode == 200) {
        var heatsJson = json.decode(response.body);

        for (var heatJson in heatsJson) {
          heats.add(Heats.fromJson(heatJson));
        }
      }
      return heats;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  getCarousel(List<ImageCarousel>? imgCarousels) async {
    // var url = "http://${genUrl}/uberPlatform/uberdisplay/image/info/all";
    // var response = await http.get(Uri.parse(url));
    // List<Carousel> carousel = [];
    // try {
    //   if (response.statusCode == 200) {
    //     var carouselsJson = json.decode(response.body);

    //     for (var carouselJson in carouselsJson) {
    //       carousel.add(Carousel.fromJson(carouselJson));
    //     }
    //   }
    //   return carousel;
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }

    if (imgCarousels != null && imgCarousels.length > 0) {
      for (var i = 0; i < imgCarousels.length; i++) {
        switch (imgCarousels[i].displayPos) {
          case 1:
            leftSlides.add(Container(
              width: double.infinity,
              child: (imgCarousels[i].imgBinary != null)
                  ? Image.memory(
                      imgCarousels[i].imgBinary!,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ));
            break;
          case 2:
            rightSlides.add(Container(
              width: double.infinity,
              child: (imgCarousels[i].imgBinary != null)
                  ? Image.memory(
                      imgCarousels[i].imgBinary!,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ));
            break;
          default:
        }
      }
    }
  }

  @override
  void initState() {
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Preferences.getSharedValue("rpiFail").then((value) {
      if (value == "true") {
        isRPIFail = true;
      } else {
        isRPIFail = false;
      }
    });

    Preferences.getSharedValue('recall').then((value) {
      if (value == 'recallDisabled') {
        recallStatus = 'recallDisabled';
      } else {
        recallStatus = 'recallEnabled';
      }
    });
    Preferences.setSharedValue("displayMode", "Mode2");
    print('Recall : ${Preferences.getSharedValue("recall")}');
    _heats = [];
    _carousel = [];
    genUrl = LoadContent.baseUri;
    _jobPanels = LoadJobPanel.jobPanels;
    _heatDataList = LoadHeats.heats;
    print(genUrl);
    // getHeats().then((value) {
    //   doneData = [value[0].heatId, value[0].heatDesc];
    //   heatDescDone.add(doneData);
    //   setState(() {
    //     _heats.addAll(value);
    //     heatId = value[0].heatId ?? 0;
    //     heatDescStarted = Text(value[0].heatDesc ?? '',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 76.0, fontFamily: "Times new roman"));
    //     nextHeatId = value[1].heatId ?? 0;
    //     heatDescNext = Text(value[1].heatDesc ?? '',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 26.0, fontFamily: "Times new roman"));
    //     animate = false;
    //   });
    // });

    // getCarousel().then((value) {
    //   setState(() {
    //     _carousel.addAll(value);
    //   });
    // });

    getCarousel(ImageCarouselConfig.settings);

    //game.playerId = '1';
    WebSocketUtil.addListener(WebSocketListener('wsMode', _onMessageRecieved));

    //game.playerId = '2';
    WebSocketUtil.addListener(
        WebSocketListener('wsMode2', _onMessageRecieved2));

    _initTime(); // initialize time value
    if (dateTime != null) {
      _updateTime();
    }
    getDanceLength();
    setState(() {
      getHeatSequence();
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      RenderBox? box =
          containerKey.currentContext!.findRenderObject() as RenderBox?;
      setState(() {
        containerSize = box!.size.width;
        print("Width of Container: [$containerSize]");
        //_showOverlay(context, "$containerSize");
      });
    });

    super.initState();
  }

  void _showOverlay(BuildContext context, bool isOn) {
    if (isOn) {
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 10.0, // position from top
          left: 10.0, // position from left
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200, // width of the pop-up
              height: 100, // height of the pop-up
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black, width: 1.5)),
              child: Center(
                  child: Text('${DeviceConfig.deviceName}',
                      style: const TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times new roman"))),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry!);
    } else {
      if (overlayEntry != null) {
        overlayEntry!.remove();
      }
    }

    // Remove the overlay after 3 seconds
    /*Future.delayed(Duration(seconds: 3), () {
      overlayEntry!.remove();
    });*/
  }

  _initTime() async {
    TimeInfo timeInfo = await TimeInfoDao.getTimeInfo();
    setState(() {
      if (timeInfo.toDateTime() != null) {
        dateTime = timeInfo.toDateTime();
        labelTime = DateFormat('h:mm a').format(dateTime!);
      } else {
        labelTime = "";
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (dateTime != null) {
        _updateTime();
      }
    });
  }

  _updateTime() {
    if (dateTime != null) {
      setState(() {
        dateTime = dateTime!.add(const Duration(seconds: 1));
        labelTime = DateFormat('h:mm a').format(dateTime!);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _onMessageRecieved2(EntryData e) {
    setState(() {
      if (e.global5 != null) {
        Global5Config.settings!.danceLength = e.global5!.danceLength;
      }
      // Global5Config.settings!.danceLength = e.global5!.danceLength;
      getDanceLength();
      print(e);
    });
  }

  void _onMessageRecieved(e) {
    setState(() {
      if (e.onDeckFloor != null) {
        //print("ON DECK!!!");
        print("ON DECK: ${e.onDeckFloor.toMap()}");
      }
      if (e.scratch != null) {
        print("SCRATCH: ${e.scratch.toMap()}");
        for (var ent in e.scratch.entries) {
          print("scratching: $ent");
          if (ent.runtimeType == int) {
            ent = "$ent";
          }
          //_jobPanelData.updateCoupleScratchEntryId(ent, e.scratch.status);
          HeatDataProcess.updateScratchByEntryId(ent, e.scratch.status);
        }
      }
      if (e.manageEntry != null) {
        print("MANAGE ENTRY: ${e.manageEntry.toMap()}");
        _jobPanelData.updateManageEntryResponse(e.manageEntry).then((value) {
          setState(() {
            print("setting heat sequence");
            getHeatSequence();
          });
        });
      }
      if (e.deviceIdentify != null) {
        print("DEVICE IDENTIFY[${e.deviceIdentify!.set}]");
        bool isOn =
            (e.deviceIdentify!.set != null && e.deviceIdentify!.set == "on")
                ? true
                : false;
        _showOverlay(context, isOn);
      }
      getHeatSequence();
      print(e);
    });

    // print("Mess ${e.toMap()}");
    // if (e.started.heatId != doneData[0]) {
    //   print('SAME HEAT ID : ${e.started.heatId}');

    // setState(() {
    //   heatId = e.started.heatId;
    //   nextHeatId = e.started.nextHeatId;

    //   for (var item in _heats) {
    //     if (e.started.heatId == item.heatId) {
    //       descName = item.heatDesc;
    //       heatDescStarted = Text(item.heatDesc ?? '',
    //           textAlign: TextAlign.center,
    //           style:
    //               TextStyle(fontSize: 76.0, fontFamily: "Times new roman"));
    //     }

    //     if (e.started.nextHeatId == item.heatId) {
    //       heatDescNext = Text(item.heatDesc ?? '',
    //           textAlign: TextAlign.center,
    //           style:
    //               TextStyle(fontSize: 26.0, fontFamily: "Times new roman"));
    //     }
    //   }
    //   doneData = [heatId, descName];

    //   // if (heatDescDone[0].contains(doneData[0])) {
    //   //   print('Done Data : ${heatDescDone.contains(doneData)}');
    //   //   return heatDescDone;
    //   // } else {
    //   // print(doneData[0]);

    //   // }
    //   // print('Current Heat : $heatId');

    //   // print('Done Heat : ${heatDescDone[doneSlide][0]}');

    //   // if (heatDescDone[doneSlide][0] != heatId) {
    //   // for (var hdone in heatDescDone) {
    //   //   print('Loop Done : $hdone');
    //   //   if (hdone[0] == doneData[0]) {
    //   //     continue;
    //   //   } else {}
    //   // }
    //   // heatDescDone.removeWhere((value) => value == doneData);
    //   //heatDescDone.add(doneData);

    //   // var distinctIds = heatDescDone.toSet().toList();
    //   // print('DISTINCT : $distinctIds');
    //   // heatDescDone.forEach((e) {
    //   //   if (e == doneData) toRemove.add(e);
    //   //   print('E DATA : $e');
    //   // });
    //   // heatDescDone.removeWhere((e) => toRemove.contains(e));
    //   // print('TO REMOVE : $toRemove');
    //   // print('Done desk $doneData');
    //   print('Heat desk $heatDescDone');

    //   // }
    //   // print(heatDescDone);
    //   // }
    //   // heatDescDone.forEach((element) {
    //   //   print(element[0]);
    //   // });
    //   // heatDescDone.addAll(doneData
    //   //     .where((a) => heatDescDone.every((b) => a.heatId != b.heatId)));

    //   // if (heatDescDone.length > 2) {
    //   //   doneSlide = doneSlide + 1;
    //   // }
    // });
    //}
  }

  // void nextButton() {
  //   setState(() {
  //     doneSlide = doneSlide + 1;
  //     heatSlide = heatSlide + 1;
  //     deckSlide = deckSlide + 1;
  //     percent = 0;
  //     if (doneSlide == _heats.length) {
  //       doneSlide = 1;
  //     }
  //     if (heatSlide == _heats.length) {
  //       heatSlide = 0;
  //     }
  //     if (deckSlide == _heats.length) {
  //       deckSlide = 0;
  //     }
  //   });
  // }

  ///will be called once HeatSequence data from RPI has been updated
  ///
  ///will get Heat's id and desc only
  void getHeatSequence() {
    heatStatus = HeatSequenceConfig.settings!;
    try {
      if (_jobPanels != null) {
        //current heat
        if (HeatSequenceConfig.settings!.currentHeat != null &&
            HeatSequenceConfig.settings!.currentHeat != 0) {
          heatId = HeatSequenceConfig.settings?.currentHeat ?? 0;
          //var heatData = _jobPanelData.getHeatData(HeatSequenceConfig.settings?.currentHeat);
          //heatDescStarted = heatData.heatDance;
          heatDescStarted = heatStatus?.currentDanceName;
          //heatName = heatData.heatName?.toUpperCase().replaceAll("HEAT ", "");
          heatName = heatStatus?.currentHeatNameL1
              ?.toUpperCase()
              .replaceAll("HEAT ", "");
        } else {
          heatId = 0;
          heatDescStarted = null;
        }
        //heat status
        bool isStarted = (HeatSequenceConfig.settings!.currentHeatStatus == 2)
            ? true
            : false;
        heatStarted = HeatSequenceConfig.settings!.start ?? false;
        if (!isStarted) {
          _jobPanelData.updateHeatStatus(heatId, isStarted);
        }
        //heat next
        if (HeatSequenceConfig.settings?.nextHeat != null &&
            HeatSequenceConfig.settings?.nextHeat != 0) {
          nextHeatId = HeatSequenceConfig.settings?.nextHeat ?? 0;
          print("NextHeatID: [${nextHeatId}]");
          var heatData = HeatDataProcess.getHeatData(
              HeatSequenceConfig.settings!.nextHeat!);
          heatDescNext = HeatSequenceConfig.settings!.nextDanceName;
          //var nextHeatDescription = heatData.desc;
          isFormation = heatData.isFormation ?? false;
          nextHeatName = HeatSequenceConfig.settings!.nextHeatNameL1;
          //nextHeatName = nextHeatName?.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
          //nextHeatName = nextHeatName?.replaceAll(" ", "\n");
          if (heatData.participants != null &&
              !heatData.participants!.isEmpty) {
            //participants = heatData.participants!;
            participants = [];
            heatData?.participants?.forEach((k, v) {
              print("$k List: $v");
              participants.addAll(v);
            });
            // sort should be under participants.participant
            //participants.sort();
            participants
                .sort((a, b) => a.participant!.compareTo(b.participant!));
            // fill in dummy list
            /*for(int heatId = 0; heatId <= 15 ;heatId++) {
              participants.add("${heatId}-00|Test participant");
            }*/
          }
        } else {
          nextHeatId = 0;
          participants = [];
          heatDescNext = null;
        }
        //heat done
        if (HeatSequenceConfig.settings?.doneHeat != null &&
            HeatSequenceConfig.settings?.doneHeat != 0) {
          doneHeatId = HeatSequenceConfig.settings?.doneHeat ?? 0;
          //var heatData = _jobPanelData.getHeatData(HeatSequenceConfig.settings?.doneHeat);
          heatDescDone = HeatSequenceConfig.settings!.doneDanceName;
          doneHeatName =
              heatStatus?.doneHeatNameL1?.toUpperCase().replaceAll("HEAT ", "");
        }
        //prevent animation trigger if greenbar is in progress
        if (heatStarted && !isAnimationRunning) {
          //startAnimation();
        }
      }

      print("PARTICIPANTS: ${participants.length}");
      for (var p in participants) {
        print(p);
      }
    } catch (e) {
      print("TRY CATCH ERROR: " + e.toString());
    }
  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m").format(now);
  }

  void loadImagesURL() {
    for (var item in _carousel) {
      String imgUrl =
          'http://${genUrl}/uberPlatform/uberdisplay/image/${item.imageId}';
      if (item.enabled) {
        if (item.displayPos != 1) {
          rightSlides.add(Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ));
        } else {
          leftSlides.add(Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ));
        } //item.displayPos end
      } //item.enabled end
    }
  }

  void getDanceLength() {
    try {
      danceLength = Global5Config.settings!.danceLength;
      print(danceLength);
    } catch (e) {
      print(e.toString());
    }
  }

  List<TableRow> participantGenerate(List items) {
    // filter scratched
    items = items.where((elem) => !elem.isScratched).toList();

    return List.generate(items.length, (idx) {
      var pt = items[idx].participant;
      var cpl = pt.split("|")[1];
      var currentSH = items[idx].subHeatId;
      var nextSH = ((idx + 1) < items.length) ? items[idx + 1].subHeatId : null;
      //print("currentSH: ${currentSH} nextSH: ${nextSH}");
      //print("couple: $cpl isScratched: ${items[idx].isScratched}");
      String cpnum = pt.split("|")[0];
      bool isSeparator = false;
      if (cpnum.contains("-")) {
        cpnum = cpnum.substring(0, cpnum.indexOf('-'));
      }
      if (nextSH != null) {
        if (currentSH != nextSH) {
          isSeparator = true;
        }
      }
      /*if(cpl.length > 30) {
        cpl = cpl.substring(0, 32);
      }*/

      /*TableRow row = TableRow(
        children: [
          (!isFormation) ? _dottedBorderCell(isSeparator, Container(
            color: Colors.lightGreenAccent,
            height: 60.0,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            alignment: Alignment.topCenter,
            child: Text(
              "${cpnum}",
              style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          )) : _dottedBorderCell(isSeparator, Container(padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0))),
          _dottedBorderCell(
              isSeparator,
              Container(
                color: Colors.amber,
                alignment: Alignment.topLeft,
                height: 60.0,
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                child: Text(
                  "${cpl}",
                  style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              )
          )
        ],
      );*/
      //print("[${cpl}] cpl length: ${cpl.length}");
      TableRow row = TableRow(
        children: [
          (!isFormation)
              ? Stack(
                  children: [
                    Container(
                      //color: Colors.lightGreenAccent,
                      height: isNewline(cpl) ? 62.0 : null,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                        "${cpnum}",
                        style: new TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: _dottedBottomBorder(isSeparator)),
                    ),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0)),
          Stack(
            children: [
              Container(
                //color: Colors.amber,
                alignment: Alignment.topLeft,
                padding:
                    const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                child: Text(
                  "${cpl}",
                  style: new TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _dottedBottomBorder(isSeparator)),
              ),
            ],
          )
        ],
      );

      return row;
    });
  }

  bool isNewline(String cpl) {
    double widthSize = MediaQuery.of(context).size.width;
    //print("widthSize: $widthSize");
    //print("ContainerSize: [${containerSize}]");
    //print("cplSize: $cplSize");
    //print("$cpl [${cpl.length}]");

    if (containerSize == null) {
      return false;
    } else {
      if (containerSize! > 400.0) {
        if (containerSize! > 450.0) {
          //if (containerSize! > 480.0) {
          return false;
          /*}
          return (cpl.length > 42);*/
        }
        return (cpl.length > 32);
      }
      return (cpl.length > 22);
    }
  }

  Widget _dottedBottomBorder(isSeparator) {
    return (isSeparator)
        ? DottedBorder(
            strokeWidth: 1.0,
            dashPattern: const [6, 3],
            customPath: (size) => Path()
              ..moveTo(0, 0)
              ..lineTo(size.width, 0),
            padding: EdgeInsets.zero,
            child: const SizedBox(height: 1), // Just to give it a height
          )
        : Container();
  }

  Widget getParticipantList() {
    Widget retWidget;
    if (participants.length <= maxContain) {
      /*retWidget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        /*children: [
        Padding(
          padding: const EdgeInsets.all(
              10.0),
          child: Text(
              '0-First Name Last Name A / First Name Last Name B'),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        // Add more text widgets here
      ],*/
        children: participantGenerate(participants),
      );*/
      retWidget = Table(
          //border: TableBorder(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: participantGenerate(participants));
    } else {
      retWidget = CarouselSlider(
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.78,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  if (pageNum < pageMax) {
                    pageNum += 1;
                  } else {
                    pageNum = 1;
                  }
                  //print("index:$index pageNum: $pageNum");
                  if (_pgWidth == 0.0) {
                    _pgWidth = 100.0;
                    pgDuration = 9400;
                  } else {
                    _pgWidth = 0.0;
                    pgDuration = 0;
                  }
                });
              }),
          items: generateCarousel());

      //print("Setting State of page duration..........");
      setState(() {
        _pgWidth = 100.0;
        pgDuration = 9400;
      });
    }

    return retWidget;
  }

  List<Widget> generateCarousel() {
    List<Widget> retVal = [];
    int floor = 0;
    pageMax = 1;
    int ceiling = maxContain;
    while (ceiling <= participants.length) {
      //print("CEILING: $ceiling floor: $floor length: ${participants.length}");
      retVal.add(
          /*Column(
          //children: participantGenerate(participants.sublist(floor,ceiling-1))
        )*/
          Table(
              //border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: participantGenerate(participants.sublist(floor,
                  (ceiling == participants.length) ? ceiling : ceiling - 1))));
      //if(floor != 0) {
      if (ceiling == participants.length) {
        break;
      }
      floor = ceiling - 1;
      //print("FLOOR: $floor");
      ceiling += maxContain;
      if (ceiling > participants.length) {
        ceiling = participants.length;
      }
      //print("CEILING: $ceiling");
      //}
      pageMax += 1;
    }
    //print("RETURNING retval: ${retVal.length}");
    return retVal;
  }

  bool isMulti(String? dataName) {
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    if (heatName.contains(" ")) {
      return true;
    } else {
      return false;
    }
  }

  String stripHeatNumber(String? dataName) {
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    if (heatName.contains(" ")) {
      heatName = heatName.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
      heatName = heatName.substring(0, heatName.indexOf(' '));
    }
    return heatName;
  }

  String stripMultiDanceHeat(String? dataName) {
    String heatName = dataName?.replaceAll("HEAT ", "") ?? "";
    if (heatName.contains(" ")) {
      heatName = heatName.replaceAll(RegExp(r' P\d{1,2}$'), "").trim();
      heatName = heatName.substring(heatName.indexOf(' '), heatName.length);
    }
    return heatName;
  }

  @override
  Widget build(BuildContext context) {
    // print('IMG Url : ${genUrl}');
    heatStarted = heatStatus?.start != null && heatStatus!.start!;
    if (heatStarted) {
      _updateState(stats: true);
    } else {
      _updateState(stats: false);
    }

    //print('Dance Length : $danceLength $isFormation');
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    decoration: BoxDecoration(
                        //border: Border.all(color: Colors.white, width: 1.5)
                        color: Colors.black,
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.white),
                        )),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                                //color: Colors.black,
                                )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            //color: Colors.black,
                            width: double.infinity,
                            child: Center(
                              child: new Text(
                                (EventConfig.eventName != null && !isRPIFail)
                                    ? EventConfig.eventName
                                    : "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.0,
                                    fontFamily: "Times new roman"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Container(
                                      // color: Colors.red,
                                      width: 150.0,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(change_device_mode());
                                          // Navigator.pushNamed(
                                          //     context, "/change_device_mode");
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                //padding: EdgeInsets.all(12.0),

                                                decoration: BoxDecoration(
                                                  color: Color(0xff97040c),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  //border: Border.all(color: Colors.black, width: 1.5)
                                                ),
                                                constraints: BoxConstraints(
                                                    minHeight: 50.0,
                                                    minWidth: 140.0),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("OFFICIAL TIME",
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800)),
                                                    Text(labelTime ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800)),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ))),
            Expanded(
              flex: 20,
              child: Container(
                  //color: Colors.blue,
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.white,
                          //width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.60,
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  child: Row(children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              //width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.topLeft,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow[200],
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  left: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'ON DECK',
                                                style: TextStyle(
                                                    fontSize: 42.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Times new roman"),
                                              )),
                                            ),
                                          ),
                                          if (nextHeatId != null)
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                //width: MediaQuery.of(context).size.width,
                                                alignment: Alignment.topLeft,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[50],
                                                    border: Border.all()),
                                                child: Center(
                                                    child: (heatStatus !=
                                                                null &&
                                                            (heatStatus?.nextHeatNameL2 !=
                                                                    null &&
                                                                heatStatus!
                                                                    .nextHeatNameL2!
                                                                    .isNotEmpty))
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                                AutoSizeText(
                                                                    (heatStatus != null)
                                                                        ? '${heatStatus?.nextHeatNameL1?.toUpperCase().replaceAll("HEAT", "").trim()}'
                                                                        : '--',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            120.0,
                                                                        fontFamily:
                                                                            "Times new roman")),
                                                                AutoSizeText(
                                                                  (heatStatus !=
                                                                          null)
                                                                      ? '${heatStatus?.nextHeatNameL2}'
                                                                      : '--',
                                                                  maxLines: 2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          58.0,
                                                                      fontFamily:
                                                                          "Times new roman"),
                                                                )
                                                              ])
                                                        : Text(
                                                            (heatStatus != null)
                                                                ? '${heatStatus?.nextHeatNameL1?.toUpperCase().replaceAll("HEAT", "").trim()}'
                                                                : '--',
                                                            style: TextStyle(
                                                                fontSize: 128.0,
                                                                fontFamily:
                                                                    "Times new roman"))),
                                              ),
                                            ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.orange[50],
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  left: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10.0),
                                                child: AutoSizeText(
                                                  (heatStatus != null)
                                                      ? '${heatStatus?.nextDanceName}'
                                                      : '--',
                                                  maxLines: 4,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Times new roman"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Stack(
                                        children: [
                                          Container(
                                            //height: MediaQuery.of(context).size.height,
                                            key: containerKey,
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              color: Colors.yellow[50],
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Column(children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ))),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0),
                                                  alignment: Alignment.topRight,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              //setState((){
                                                              /*if(heatStarted)
                                                              heatStarted = false;
                                                            else
                                                              heatStarted = true;*/
                                                              //});
                                                              /*setState((){
                                                            if(_pgWidth == 0.0) {
                                                              _pgWidth = 100.0;
                                                              pgDuration = 10;
                                                            } else {
                                                              _pgWidth = 0.0;
                                                              pgDuration = 0;
                                                            }
                                                          });*/
                                                            },
                                                            child: Text(
                                                                "Page $pageNum of $pageMax",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "Times new roman"))),
                                                        (participants.length >
                                                                maxContain)
                                                            ? Stack(children: [
                                                                AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          pgDuration),
                                                                  height: 10.0,
                                                                  width:
                                                                      _pgWidth,
                                                                  color: Color(
                                                                      0xFF4CAF50),
                                                                ),
                                                                Container(
                                                                    height:
                                                                        10.0,
                                                                    width:
                                                                        100.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black),
                                                                    )),
                                                              ])
                                                            : Container(),
                                                        /*new LinearPercentIndicator(
                                                        width: 100.0,
                                                        alignment: MainAxisAlignment.center,
                                                        animation: true,
                                                        lineHeight: 8.0,
                                                        animationDuration: 300,
                                                        animateFromLastPercent: true,
                                                        percent: 0.0,
                                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                                        progressColor: Colors.green,
                                                      )
                                                      AnimatedSize(
                                                        duration: Duration(seconds: 10),
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: 10.0,
                                                          width: (heatStarted) ? _width : 50.0,
                                                          color: (heatStarted)
                                                              ? Colors.green
                                                              : Colors.white,
                                                        ),
                                                      ),*/
                                                      ])),
                                              getParticipantList()
                                            ]),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*if (recallStatus == 'recallEnabled')
                        Expanded(
                          flex: 1,
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.50,
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        // First column, first row
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 58, 68),
                                                        border: Border.all()),
                                                    child: Center(
                                                        child: Text(
                                                      'RECALL A',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 26.0,
                                                          fontFamily:
                                                              "Times new roman"),
                                                    )),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[50],
                                                        border: Border.all()),
                                                    child: Center(
                                                        child: (nextHeatId! > 0)
                                                            ? Text(
                                                                '$nextHeatId',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        80.0,
                                                                    fontFamily:
                                                                        "Times new roman"),
                                                              )
                                                            : Text('')),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[50],
                                                        border: Border.all()),
                                                    child: Center(
                                                      child: (heatDescNext !=
                                                                  null &&
                                                              heatDescNext!
                                                                      .length >
                                                                  0)
                                                          ? Text(
                                                              '$heatDescNext',
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  fontFamily:
                                                                      "Times new roman"),
                                                            )
                                                          : Text(''),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        // First column, second row
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '1-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '1-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '1-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '1-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '1-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),

                                                      // Add more text widgets here
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '2-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '2-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '2-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '2-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            '2-First Name Last Name A\nSecond Name Last Name B'),
                                                      ),

                                                      // Add more text widgets here
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 233, 233, 233),
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Second column, first row
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 58, 68),
                                                        border: Border(
                                                          top: BorderSide.none,
                                                          left: BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                          right: BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                          bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                        )),
                                                    child: Center(
                                                        child: Text(
                                                      'RECALL B',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 26.0,
                                                          fontFamily:
                                                              "Times new roman"),
                                                    )),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[50],
                                                        border: Border.all()),
                                                    child: Center(
                                                        child: (nextHeatId! > 0)
                                                            ? Text(
                                                                '$nextHeatId',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        80.0,
                                                                    fontFamily:
                                                                        "Times new roman"),
                                                              )
                                                            : Text('')),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[50],
                                                        border: Border.all()),
                                                    child: Center(
                                                      child: (heatDescNext !=
                                                                  null &&
                                                              heatDescNext!
                                                                      .length >
                                                                  0)
                                                          ? Text(
                                                              '$heatDescNext',
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  fontFamily:
                                                                      "Times new roman"),
                                                            )
                                                          : Text(''),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '3-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '3-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '3-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '3-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '3-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),

                                                        // Add more text widgets here
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Second column, second row

                                          Expanded(
                                            child: Stack(
                                              children: [
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '4-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '4-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '4-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              'First Name Last Name A\nSecond Name Last Name B'),
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                          indent: 10,
                                                          endIndent: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                              '4-First Name Last Name A\nSecond Name Last Name B'),
                                                        ),

                                                        // Add more text widgets here
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),*/
                      if (recallStatus == 'recallDisabled')
                        Expanded(
                          flex: 2,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/logo.png',
                              )),
                        )
                    ],
                  )),
            ),

            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'DANCE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                              fontSize: 22.0),
                        ),
                        TextSpan(
                            text: 'FRAME ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0)),
                        TextSpan(
                            text: 'C',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 22.0)),
                        TextSpan(
                            text: 'OMPETITION ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 18.0)),
                        TextSpan(
                            text: 'S',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 22.0)),
                        TextSpan(
                            text: 'YSTEMS',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     RaisedButton(
            //       child: Text('Next'),
            //       onPressed: nextButton,
            //     ),
            //     RaisedButton(
            //       child: Text('Start timer'),
            //       onPressed: () {
            //         _updateState();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
