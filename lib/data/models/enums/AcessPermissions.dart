enum AccessPermissions {
  CRITIQUE_MODULE,
  HEAT_LIST,
  VIEW_ALL_HEATS_PARTICIPANTS,
  SCRATCH_COMPETITORS,
  UN_SCRATCH_COMPETITORS,
  MANAGE_COUPLE,
  SCHEDULE_JUDGING_PANEL,
  MARK_COUPLE,
  EVENT_MONITORING_STATISTICS,
}

AccessPermissions? getAccessPermissionsFromString(String profile) {
  profile = 'AccessPermissions.$profile';
  try {
    return AccessPermissions.values.firstWhere((f) => f.toString() == profile);
  } catch (e) {
    // If there is no Permissions, it will throw "Bad state: No element"
    return null;
  }
}
