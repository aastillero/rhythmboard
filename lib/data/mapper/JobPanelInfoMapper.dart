import 'package:uber_display/model/JobPanelData.dart';

class JobPanelInfoMapper {

  static JobPanelData mapFromPanelInfo(panelInfo) {
    JobPanelData jbp = new JobPanelData.fromMap({
      "id": panelInfo["jobPanelId"]
    });

    return jbp;
  }
}