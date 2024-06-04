
#' Set Google Places API (New) key
#'
#' @param key See [here](https://developers.google.com/maps/documentation/places/web-service/get-api-key) how to get an api key from google.
#' @export
set_api_key <- function(key = NULL) {
  if (is.null(key)) {
    key <- askpass::askpass("Please enter your Google Maps API key")
  }
  Sys.setenv("MAPS_API_KEY" = key)
}


#' Get Google Places API (New) key
get_api_key <- function() {
  key <- Sys.getenv("MAPS_API_KEY")
  if (!identical(key, "")) {
    return(key)
  } else {
    stop("No API key found, please use set_api_key(key = \"YOUR_MAPS_API_KEY\") or set a MAPS_API_KEY environment variable.")
  }
}

