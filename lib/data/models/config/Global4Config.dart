import '../JobPanel.dart';
import '../enums/UserProfiles.dart';
import '../enums/AcessPermissions.dart';

class Global4Config {
  List<JobPanel>? _jobPanelPermissions;
  Map<AccessPermissions, List<UserProfiles>>? _rolePermissions;

  Global4Config._privateConstructor();

  static final Global4Config _instance = Global4Config._privateConstructor();

  static List<JobPanel>? get permissions =>
      (_instance._jobPanelPermissions != null)
          ? _instance._jobPanelPermissions
          : [];
  static Map<AccessPermissions, List<UserProfiles>>? get rolePermissions =>
      _instance._rolePermissions != null ? _instance._rolePermissions : {};

  static List<JobPanel>? get jobPanelCopy {
    return _instance._jobPanelPermissions
        ?.map((e) => JobPanel(
            id: e.id,
            description: e.description,
            judge: e.judge,
            scrutineer: e.scrutineer,
            emcee: e.emcee,
            chairman: e.chairman,
            deck: e.deck,
            registrar: e.registrar,
            musicDj: e.musicDj,
            photosVideo: e.photosVideo,
            hairMakeup: e.hairMakeup))
        .toList();
  }

  static set permissions(List<JobPanel>? panels) {
    _instance._jobPanelPermissions = panels;
  }

  static set rolePermissions(
      Map<AccessPermissions, List<UserProfiles>>? rolePermissions) {
    _instance._rolePermissions = rolePermissions;
  }

  static toMap() {
    return {"permissions": permissions};
  }

  factory Global4Config(
      {List<JobPanel>? permissions,
      Map<AccessPermissions, List<UserProfiles>>? rolePermissions}) {
    _instance._jobPanelPermissions = permissions;
    _instance._rolePermissions = rolePermissions;
    return _instance;
  }
}
