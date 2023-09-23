const String emailRegExpRaw =
    r'^([a-z0-9]+(?:[._+-][a-z0-9]+)*)@([a-z0-9]+(?:[.-][a-z0-9]+)*\.[a-z]{2,})$';
final RegExp emailRegexp = RegExp(emailRegExpRaw);
