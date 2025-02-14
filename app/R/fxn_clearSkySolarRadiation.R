#' `fxn_clearSkySolarRadiation.R` Calculate clear-sky solar radiation by day of year and AZMet station
#' 
#' @param dayOfYear - day of year
#' @param stationElevation - AZMet station elevation in meters
#' @param stationLatitude - AZMet station latitude in decimal degrees north
#' @return `fltClearSkyRad` - clear-sky solar radiation


fxn_clearSkySolarRadiation <- function(dayOfYear, stationElevation, stationLatitude) {
  # From `fxnCalculateExtraterrestrialRadiation.R` in annual ETo reports
  
  fltDayOfYear <- dayOfYear
  fltStationElevation  <- stationElevation
  fltStationLatitude  <- stationLatitude
  
  fltFi <- 0.409 * sin(0.0172 * fltDayOfYear - 1.39)
  fltStationLatitudeRadians <- fltStationLatitude / 57.3
  fltDr <- 1.0 + 0.033 * cos(0.0172 * fltDayOfYear)
  fltX <- 1.0 - ((tan(fltStationLatitudeRadians)^2) * (tan(fltFi)^2))
  
  if (fltX <= 0) {
    fltX <- 0.00001
  }
  
  fltWS <- 1.571 - atan(( -(tan(fltFi)) * (tan(fltStationLatitudeRadians))) / (fltX^0.5))
  fltRET <- 37.6 * fltDr * (fltWS * sin(fltFi) * sin(fltStationLatitudeRadians) + cos(fltFi) * cos(fltStationLatitudeRadians) * sin(fltWS))
  fltClearSkyRad <- (0.75 + 2.0 * (10^-5) * fltStationElevation) * fltRET

  fltClearSkyRad <- round(fltClearSkyRad, digits = 2)
  
  return(fltClearSkyRad)
}
