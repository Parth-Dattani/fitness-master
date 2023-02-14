mixin Apis {

  static String baseAPI =
      'https://www.googleapis.com/calendar/v3/calendars/primary/';

  static String insertAPI = 'events';
  static String getEvent = 'events/eventId';
  //https://www.google.com/calendar/event?eid=Nm9zMzBlMWg3NHM2NGJiNDZnc2owYjlrY2hqM2diOXA2NWgzY2I5bjZrbzZhYzFsNmdzamVwYjM2Y18xOTcwMDEwMVQwMDAwMDBaIG1heXVydGhlb25ldGVjaDFAbQ
  static const String acToken = 'token';
}