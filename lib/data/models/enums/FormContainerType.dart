enum FormContainerType { ROUNDED, BOXED }

FormContainerType? getFormContainerTypeFromString(String profile) {
  profile = 'FormContainerType.$profile';
  try {
    return FormContainerType.values.firstWhere((f) => f.toString() == profile);
  } catch (e) {
    // If there is no Profile, it will throw "Bad state: No element"
    return null;
  }
}
