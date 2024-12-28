enum UserProfiles {
  JUDGE,
  EMCEE,
  CHAIRMAN_OF_JUDGES,
  INVIGILATOR,
  SCRUTINEER,
  DECK_CAPTAIN,
  FREE_TIME,
  REGISTRAR,
  MUSIC_DJ,
  PHOTOS_VIDEOS,
  HAIR_MAKEUP
}

UserProfiles? getUserProfilesFromString(String profile) {
  profile = 'UserProfiles.$profile';
  try {
    return UserProfiles.values.firstWhere((f) => f.toString() == profile);
  } catch (e) {
    // If there is no Profile, it will throw "Bad state: No element"
    return null;
  }
}
