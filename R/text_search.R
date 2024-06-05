#' Google Places API (New): Text Search
#'
#' A Text Search (New) returns information about a set of places based on a string — for example "pizza in New York" or "shoe stores near Ottawa" or "123 Main Street". The service responds with a list of places matching the text string and any location bias that has been set.
#' The service is especially useful for making ambiguous address queries in an automated system, and non-address components of the string may match businesses as well as addresses. Examples of ambiguous address queries are poorly-formatted addresses or requests that include non-address components such as business names.
#'
#' @param textQuery The text string on which to search, for example: "restaurant", "123 Main Street", or "best place to visit in San Francisco". The API returns candidate matches based on this string and orders the results based on their perceived relevance.
#' @param languageCode See [supported languages](https://developers.google.com/maps/faq#languagesupport).
#' @param regionCode The region code used to format the response, specified as a [two-character CLDR code](https://www.unicode.org/cldr/charts/latest/supplemental/territory_language_information.html) value. This parameter can also have a bias effect on the search results. There is no default value.
#' @param rankPreference Specifies how the results are ranked in the response based on the type of query: For a categorical query such as "Restaurants in New York City", "RELEVANCE" (rank results by search relevance) is the default. You can set rankPreference to "RELEVANCE" or "DISTANCE" (rank results by distance).
#' For a non-categorical query such as "Mountain View, CA", we recommend that you leave rankPreference unset.
#' @param includedType Restricts the results to places matching the specified type defined by [Table A](https://developers.google.com/maps/documentation/places/web-service/place-types#table-a). Only one type may be specified, for example "bar" or "pharmacy".
#' @param openNow If "true", return only those places that are open for business at the time the query is sent. If "false", return all businesses regardless of open status. Places that don't specify opening hours in the Google Places database are returned if you set this parameter to "false".
#' @param minRating Restricts results to only those whose average user rating is greater than or equal to this limit. Values must be between 0.0 and 5.0 (inclusive) in increments of 0.5. For example: 0, 0.5, 1.0, ... , 5.0 inclusive. Values are rounded up to the nearest 0.5. For example, a value of 0.6 eliminates all results with a rating less than 1.0.
#' @param pageSize Specifies the number of results (between 1 and 20) to display per page. For example, setting a pageSize value of 5 will return up to 5 results on the first page. If there are more results that can be returned from the query, the response includes a nextPageToken that you can pass into a subsequent request to access the next page.
#' @param priceLevels Restrict the search to places that are marked at certain price levels. The default is to select all price levels.
#' Specify an array of one or more of values defined by PriceLevel. For example: jsonlite::toJSON(c("PRICE_LEVEL_INEXPENSIVE", "PRICE_LEVEL_MODERATE"), auto_unbox = TRUE, pretty = TRUE)
#' @param strictTypeFiltering Used with the `includedType` parameter. When set to "true", only places that match the specified types specified by `includeType` are returned. When "false", the default, the response can contain places that don't match the specified types.
#' @param location Specifies an area to search. You can specify location = "restriction" or location = "bias", but not both. Think of "restriction" as specifying the region which the results must be within, and "bias" as specifying the region that the results must be near but can be outside of the area. If you omit both "bias" and "restriction", then the API uses IP biasing by default.
#' With IP biasing, the API uses the device's IP address to bias the results. The `location` parameter can be overridden if the `textQuery` contains an explicit location such as "Market in Barcelona". In this case, "bias" is ignored. When using "bias" the region can be specified as a rectangle or a circle viewport. When using "restriction" the region can only be specified as a rectangle viewport. Use a circle or a rectangle viewport by setting the corresponding `circle_*` or `rectangle_*` arguments below and leave the other empty.
#' @param circle_center_latitude Circle centre latitude used with `location = "bias"`. The latitude bounds must range between -90 to 90 degrees inclusive.
#' @param circle_center_longitude Circle centre longitude used in `location = "bias"`. The longitude bounds must range between -180 to 180 degrees inclusive.
#' @param circle_radius Radius of circle in meters used in `location = "bias"`. The radius must be between 0 and 50000, inclusive. The default radius is 0.
#' @param rectangle_lowLatLng A vector with low latitude-longitude coordinates, for example c(37.71, -8.83). A rectangle is a latitude-longitude viewport, represented as two diagonally opposite low and high points. The low point marks the southwest corner of the rectangle, and the high point represents the northeast corner of the rectangle.
#' @param rectangle_highLatLng A vector with high latitude-longitude coordinates, for example c(37.74, -8.79). A rectangle is a latitude-longitude viewport, represented as two diagonally opposite low and high points. The low point marks the southwest corner of the rectangle, and the high point represents the northeast corner of the rectangle.
#' @param show_request If TRUE the request to be sent to the API server will be print to the console. Default is FALSE. Note that this will print the auth header and the API key to the console, so beware to accidentally leak credentials when debugging/reprexing.
#' @param key API key. By default the function runs `get_api_key()` to get the key from the MAPS_API_KEY environment variable. \code{\link{set_api_key}} function can be used to set the API key.
#'
#' @return A list with tibbles containing information on places (main tibble), types of places, reviews of places and photos of places. Each tibble can be cross-referenced by using `document.id`. Note that Places API (New) returns up to 20 places, so `document.id` never exceeds 20.
#'
#' @import tidyjson tidyr dplyr httr2 httpuv askpass stringr
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # returns one (great!) place:
#' text_search(textQuery = "nature retreat near trails and river in southwest Portugal", pageSize = 1)
#'
#' # returns response in a specified language:
#' text_search(textQuery = "restaurants in China", languageCode = "pt-PT")
#'
#' # removes the specified country from the response `formattedAddress` string:
#' text_search(textQuery = "bacalhau restaurants in Portugal", regionCode = "PT")
#'
#' # rank by distance:
#' text_search(textQuery = "slow-food restaurants near Times Square, NY", rankPreference = "DISTANCE")
#'
#' # returns only places open now:
#' text_search(textQuery = "slow-food restaurants in New York", openNow = "true")
#'
#' # include min. rating criteria:
#' text_search(textQuery = "slow-food restaurants in New York", openNow = "true", minRating = 4.5)
#'
#' # include pricing criteria:
#' text_search(textQuery = "slow-food restaurants in New York", openNow = "true", minRating = 4.5,
#' priceLevels = c("PRICE_LEVEL_INEXPENSIVE", "PRICE_LEVEL_MODERATE"))
#'
#' # include circular location bias criteria:
#' text_search(textQuery = "slow-food restaurants in New York",
#' location = "bias", circle_center_latitude = 40.75797, circle_center_longitude = -73.98554, circle_radius = 500))
#'
#' # include rectangular location bias criteria:
#' text_search(textQuery = "slow-food restaurants in New York",
#' location = "bias", rectangle_lowLatLng = c(40.75634, -73.99052), rectangle_highLatLng = c(40.75989, -73.98035))
#'
#' # include rectangular location restriction criteria:
#' text_search(textQuery = "slow-food restaurants in New York",
#' location = "restriction", rectangle_lowLatLng = c(40.75634, -73.99052), rectangle_highLatLng = c(40.75989, -73.98035))
#'
#' # shows the request (incl. auth header), useful for debugging/reprexing. Beware to accidentally leak credentials while using it!:
#' text_search(textQuery = "nature retreat near trails and river in southwest Portugal", show_request = TRUE)
#'
#'}
#' @references [Google Places (New) API documentation - Text Search](https://developers.google.com/maps/documentation/places/web-service/text-search)


text_search <- function(textQuery = NULL,
                        languageCode = NULL,
                        regionCode = NULL,
                        rankPreference = NULL,
                        includedType = NULL,
                        openNow = NULL,
                        minRating = NULL,
                        pageSize = NULL,
                        priceLevels = NULL,
                        strictTypeFiltering = NULL,
                        location = NULL,   # Use either NULL (default), "bias" or "restriction"
                        circle_center_latitude = NULL,
                        circle_center_longitude = NULL,
                        circle_radius = NULL,
                        rectangle_lowLatLng = NULL,
                        rectangle_highLatLng = NULL,
                        #evOptions = NULL, # TO DO
                        show_request = FALSE,
                        key = get_api_key()) {


  if (!is.null(location)) {
    if (location == "restriction" &
        !is.null(rectangle_lowLatLng) & !is.null(rectangle_highLatLng)) {
      cat(location, "location type with rectangular viewport\n")
      locationBias = NULL

      # Creating locationRestriction object:
      body <- list()
      innerBody <- list()
      innerInnerBody1 <- list()
      innerInnerBody2 <- list()
      innerInnerBody1$latitude <- rectangle_lowLatLng[1]
      innerInnerBody1$longitude <- rectangle_lowLatLng[2]
      innerInnerBody2$latitude <- rectangle_highLatLng[1]
      innerInnerBody2$longitude <- rectangle_highLatLng[2]
      innerBody$low <- innerInnerBody1
      innerBody$high <- innerInnerBody2
      body$rectangle <- innerBody
      locationRestriction <- body

    } else if (location == "restriction" &
               (is.null(rectangle_lowLatLng) | is.null(rectangle_highLatLng))) {
      stop("rectangle_lowLatLng and rectangle_highLatLng cannot be NULL with location=\"restriction\" case")

    } else if (location == "bias" &
               !is.null(circle_center_latitude) & !is.null(circle_center_longitude) & !is.null(circle_radius)) {
      locationRestriction = NULL

      # Creating locationBias object:
      body <- list()
      innerBody <- list()
      innerInnerBody <- list()
      innerInnerBody$latitude <- circle_center_latitude
      innerInnerBody$longitude <- circle_center_longitude
      innerBody$center <- innerInnerBody
      innerBody$radius <- circle_radius
      body$circle <- innerBody
      locationBias <- body

    } else if (location == "bias" & (is.null(circle_center_latitude) | is.null(circle_center_longitude) | is.null(circle_radius)) |
               location == "bias" & (is.null(rectangle_lowLatLng) | is.null(rectangle_highLatLng) )) {
      stop(
        "(circle_center_latitude, circle_center_longitude and circle_radius) OR (rectangle_lowLatLng and rectangle_highLatLng) cannot be NULL with location=\"bias\" case"
      )

    } else if (location == "bias" &
               !is.null(rectangle_lowLatLng) & !is.null(rectangle_highLatLng)) {
      cat(location, "location type with rectangular viewport\n")
      locationBias = NULL

      # Creating locationBias object:
      body <- list()
      innerBody <- list()
      innerInnerBody1 <- list()
      innerInnerBody2 <- list()
      innerInnerBody1$latitude <- rectangle_lowLatLng[1]
      innerInnerBody1$longitude <- rectangle_lowLatLng[2]
      innerInnerBody2$latitude <- rectangle_highLatLng[1]
      innerInnerBody2$longitude <- rectangle_highLatLng[2]
      innerBody$low <- innerInnerBody1
      innerBody$high <- innerInnerBody2
      body$rectangle <- innerBody
      locationBias <- body

    }
  } else if (is.null(location)) {
    locationBias <- NULL
    locationRestriction <- NULL
  }

  params <- list(
    textQuery = textQuery,
    languageCode = languageCode,
    regionCode = regionCode,
    rankPreference = rankPreference,
    includedType = includedType,
    openNow = openNow,
    minRating = minRating,
    pageSize = pageSize,
    priceLevels = priceLevels,
    strictTypeFiltering = strictTypeFiltering,
    locationBias = locationBias,
    locationRestriction = locationRestriction
    #evOptions = evOptions
  )

  #cat("Sending the request with the following body parameters: \n", jsonlite::toJSON(Filter(Negate(is.null), params), auto_unbox = TRUE, pretty = TRUE))

  req <-
    request("https://places.googleapis.com/v1/places:searchText") |>
    req_headers(
      `X-Goog-Api-Key` = key,
      `X-Goog-FieldMask` = "*",
      `Content-Type` = "application/json"
    ) |>
    req_body_json(Filter(Negate(is.null), params))

  cat("Sending request ...\n")

  if (show_request == TRUE) {
    req |>
      req_dry_run()
  }

  resp <- req |>
    req_perform()
  resp

  res <- resp |> resp_body_json()

  if (length(resp$body) < 5) {
    return(NULL)

  } else if (length(resp$body) >= 5) {

    # Converting resp into a structured tibble:
    places <- tryCatch(
      {
        res$places |> tidyjson::spread_all()
      },
      error = function(e) NA
    )

    # Inspecting response data structure:
    #insp <- res$places |> gather_object |> json_types |> count(name, type) #|> select(type == "array")

    # Extracting nested arrays and merging to main tibble:
    places_types <- tryCatch(
      {
        suppressWarnings(
          res$places |>
            tidyjson::enter_object(types) |>
            #tidyjson::gather_array() |>
            tidyjson::spread_all() |>
            #dplyr::select(-array.index) |>
            rename_at(vars(-document.id), ~ paste0('types.', .)) |>
            rename("types.includedType" = "types...JSON") |>
            tidyr::unnest(types.includedType)
        )
      },
      error = function(e) NA
    )

    places_reviews <- tryCatch(
      {
        suppressWarnings(
          res$places |>
            tidyjson::enter_object(reviews) |>
            tidyjson::gather_array() |>
            tidyjson::spread_all()  |>
            dplyr::select(-array.index) |>
            tidyr::unnest(..JSON) |>
            dplyr::select(-..JSON) |>
            rename_at(vars(-document.id), ~ paste0('reviews.', .)) |>
            dplyr::distinct(document.id, reviews.name, reviews.publishTime, .keep_all = TRUE)
        )
      },
      error = function(e) NA
    )

    places_photos <- tryCatch(
      {
        suppressWarnings(
          res$places |>
            tidyjson::enter_object(photos) |>
            tidyjson::gather_array() |>
            tidyjson::spread_all() |>
            dplyr::select(-array.index) |>
            tidyr::unnest(..JSON) |>
            dplyr::select(-..JSON) |>
            rename_at(vars(-document.id), ~ paste0('photos.', .)) |>
            dplyr::distinct(document.id, photos.name, .keep_all = TRUE)
        )
      },
      error = function(e) NA
    )


    # places_join <-
    #   left_join(places,
    #             places_types,
    #             relationship = "many-to-many",
    #             by = "document.id")
    # places_join <-
    #   left_join(places_join,
    #             places_reviews,
    #             relationship = "many-to-many",
    #             by = "document.id")
    # places_join <-
    #   left_join(places_join,
    #             places_photos,
    #             relationship = "many-to-many",
    #             by = "document.id")


    return(
      list(
        "places" = places,
        "types" = places_types,
        "reviews" = places_reviews,
        "photos" = places_photos
      )
    )

  }
}




