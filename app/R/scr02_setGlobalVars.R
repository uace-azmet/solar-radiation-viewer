
# to delete

batteryVariables <- 
  tibble::tibble(
    name = c(
      "meta_bat_volt_max", "meta_bat_volt_mean", "meta_bat_volt_min"
    ),
    
    variable = c(
      "Voltage maximum (V)", "Voltage average (V)", "Voltage minimum (V)"
    )
  )

downloadStartDate <- lubridate::date("2024-01-01")

weatherVariables <- 
  tibble::tibble(
    name = c(
      "relative_humidity_max", 
      "relative_humidity_mean", 
      "relative_humidity_min", 
      "sol_rad_total",
      "temp_air_maxC", 
      "temp_air_meanC", 
      "temp_air_minC"
    ),
    
    variable = c(
      "Relative Humidity maximum (%)", 
      "Relative Humidity average (%)", 
      "Relative Humidity minimum (%)", 
      "Solar Radiation total (MJ/m^2)",
      "Air Temperature maximum (°C)", 
      "Air Temperature average (°C)", 
      "Air Temperature minimum (°C)")
  )
