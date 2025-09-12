{ self, ... }:
{
  /**
    Time constants in seconds.
  */
  secPerMin = 60;
  secPerHour = 60 * self.time.secPerMin;
  secPerDay = 24 * self.time.secPerHour;
  secPerWeek = 7 * self.time.secPerDay;
  secPerYear = 365 * self.time.secPerDay;
}
