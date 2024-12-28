enum ParticipantLevel { PRO, AM }

ParticipantLevel? getParticipantLevelromString(String code) {
  code = 'ParticipantLevel.${code.replaceAll("-", "_")}';
  try {
    return ParticipantLevel.values.firstWhere((f) => f.toString() == code);
  } catch (e) {
    // If there is no Category, it will throw "Bad state: No element"
    return null;
  }
}
