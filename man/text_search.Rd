% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/text_search.R
\name{text_search}
\alias{text_search}
\title{Google Places API (New): Text Search}
\usage{
text_search(
  textQuery = NULL,
  languageCode = NULL,
  regionCode = NULL,
  rankPreference = NULL,
  includedType = NULL,
  openNow = NULL,
  minRating = NULL,
  pageSize = NULL,
  priceLevels = NULL,
  strictTypeFiltering = NULL,
  location = NULL,
  circle_center_latitude = NULL,
  circle_center_longitude = NULL,
  circle_radius = NULL,
  rectangle_lowLatLng = NULL,
  rectangle_highLatLng = NULL,
  show_request = FALSE,
  key = get_api_key()
)
}
\arguments{
\item{textQuery}{The text string on which to search, for example: "restaurant", "123 Main Street", or "best place to visit in San Francisco". The API returns candidate matches based on this string and orders the results based on their perceived relevance.}

\item{languageCode}{See \href{https://developers.google.com/maps/faq#languagesupport}{supported languages}.}

\item{regionCode}{The region code used to format the response, specified as a \href{https://www.unicode.org/cldr/charts/latest/supplemental/territory_language_information.html}{two-character CLDR code} value. This parameter can also have a bias effect on the search results. There is no default value.}

\item{rankPreference}{Specifies how the results are ranked in the response based on the type of query: For a categorical query such as "Restaurants in New York City", "RELEVANCE" (rank results by search relevance) is the default. You can set rankPreference to "RELEVANCE" or "DISTANCE" (rank results by distance).
For a non-categorical query such as "Mountain View, CA", we recommend that you leave rankPreference unset.}

\item{includedType}{Restricts the results to places matching the specified type defined by \href{https://developers.google.com/maps/documentation/places/web-service/place-types#table-a}{Table A}. Only one type may be specified, for example "bar" or "pharmacy".}

\item{openNow}{If "true", return only those places that are open for business at the time the query is sent. If "false", return all businesses regardless of open status. Places that don't specify opening hours in the Google Places database are returned if you set this parameter to "false".}

\item{minRating}{Restricts results to only those whose average user rating is greater than or equal to this limit. Values must be between 0.0 and 5.0 (inclusive) in increments of 0.5. For example: 0, 0.5, 1.0, ... , 5.0 inclusive. Values are rounded up to the nearest 0.5. For example, a value of 0.6 eliminates all results with a rating less than 1.0.}

\item{pageSize}{Specifies the number of results (between 1 and 20) to display per page. For example, setting a pageSize value of 5 will return up to 5 results on the first page. If there are more results that can be returned from the query, the response includes a nextPageToken that you can pass into a subsequent request to access the next page.}

\item{priceLevels}{Restrict the search to places that are marked at certain price levels. The default is to select all price levels.
Specify an array of one or more of values defined by PriceLevel. For example: jsonlite::toJSON(c("PRICE_LEVEL_INEXPENSIVE", "PRICE_LEVEL_MODERATE"), auto_unbox = TRUE, pretty = TRUE)}

\item{strictTypeFiltering}{Used with the \code{includedType} parameter. When set to "true", only places that match the specified types specified by \code{includeType} are returned. When "false", the default, the response can contain places that don't match the specified types.}

\item{location}{Specifies an area to search. You can specify location = "restriction" or location = "bias", but not both. Think of "restriction" as specifying the region which the results must be within, and "bias" as specifying the region that the results must be near but can be outside of the area. If you omit both "bias" and "restriction", then the API uses IP biasing by default.
With IP biasing, the API uses the device's IP address to bias the results. The \code{location} parameter can be overridden if the \code{textQuery} contains an explicit location such as "Market in Barcelona". In this case, "bias" is ignored. When using "bias" the region can be specified as a rectangle or a circle viewport. When using "restriction" the region can only be specified as a rectangle viewport. Use a circle or a rectangle viewport by setting the corresponding \verb{circle_*} or \verb{rectangle_*} arguments below and leave the other empty.}

\item{circle_center_latitude}{Circle centre latitude used with \code{location = "bias"}. The latitude bounds must range between -90 to 90 degrees inclusive.}

\item{circle_center_longitude}{Circle centre longitude used in \code{location = "bias"}. The longitude bounds must range between -180 to 180 degrees inclusive.}

\item{circle_radius}{Radius of circle in meters used in \code{location = "bias"}. The radius must be between 0 and 50000, inclusive. The default radius is 0.}

\item{rectangle_lowLatLng}{A vector with low latitude-longitude coordinates, for example c(37.71, -8.83). A rectangle is a latitude-longitude viewport, represented as two diagonally opposite low and high points. The low point marks the southwest corner of the rectangle, and the high point represents the northeast corner of the rectangle.}

\item{rectangle_highLatLng}{A vector with high latitude-longitude coordinates, for example c(37.74, -8.79). A rectangle is a latitude-longitude viewport, represented as two diagonally opposite low and high points. The low point marks the southwest corner of the rectangle, and the high point represents the northeast corner of the rectangle.}

\item{show_request}{If TRUE the request to be sent to the API server will be print to the console. Default is FALSE. Note that this will print the auth header and the API key to the console, so beware to accidentally leak credentials when debugging/reprexing.}

\item{key}{API key. By default the function runs \code{get_api_key()} to get the key from the MAPS_API_KEY environment variable. \code{\link{set_api_key}} function can be used to set the API key.}
}
\value{
A list with tibbles containing information on places (main tibble), types of places, reviews of places and photos of places. Each tibble can be cross-referenced by using \code{document.id}. Note that Places API (New) returns up to 20 places, so \code{document.id} never exceeds 20.
}
\description{
A Text Search (New) returns information about a set of places based on a string — for example "pizza in New York" or "shoe stores near Ottawa" or "123 Main Street". The service responds with a list of places matching the text string and any location bias that has been set.
The service is especially useful for making ambiguous address queries in an automated system, and non-address components of the string may match businesses as well as addresses. Examples of ambiguous address queries are poorly-formatted addresses or requests that include non-address components such as business names.
}
\examples{
\dontrun{

# returns one (great!) place:
text_search(textQuery = "nature retreat near trails and river in southwest Portugal", pageSize = 1)

# returns response in a specified language:
text_search(textQuery = "restaurants in China", languageCode = "pt-PT")

# removes the specified country from the response `formattedAddress` string:
text_search(textQuery = "bacalhau restaurants in Portugal", regionCode = "PT")

# rank by distance:
text_search(textQuery = "slow-food restaurants near Times Square, NY", rankPreference = "DISTANCE")

# returns only places open now:
text_search(textQuery = "slow-food restaurants in New York", openNow = "true")

# include min. rating criteria:
text_search(textQuery = "slow-food restaurants in New York", openNow = "true", minRating = 4.5)

# include pricing criteria:
text_search(textQuery = "slow-food restaurants in New York", openNow = "true", minRating = 4.5,
priceLevels = c("PRICE_LEVEL_INEXPENSIVE", "PRICE_LEVEL_MODERATE"))

# include circular location bias criteria:
text_search(textQuery = "slow-food restaurants in New York",
location = "bias", circle_center_latitude = 40.75797, circle_center_longitude = -73.98554, circle_radius = 500))

# include rectangular location bias criteria:
text_search(textQuery = "slow-food restaurants in New York",
location = "bias", rectangle_lowLatLng = c(40.75634, -73.99052), rectangle_highLatLng = c(40.75989, -73.98035))

# include rectangular location restriction criteria:
text_search(textQuery = "slow-food restaurants in New York",
location = "restriction", rectangle_lowLatLng = c(40.75634, -73.99052), rectangle_highLatLng = c(40.75989, -73.98035))

# shows the request (incl. auth header), useful for debugging/reprexing. Beware to accidentally leak credentials while using it!:
text_search(textQuery = "nature retreat near trails and river in southwest Portugal", show_request = TRUE)

}
}
\references{
\href{https://developers.google.com/maps/documentation/places/web-service/text-search}{Google Places (New) API documentation - Text Search}
}
