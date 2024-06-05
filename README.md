# newplaces

This is a R-wrapper package to the [Google Places API (New)](https://developers.google.com/maps/documentation/places/web-service/op-overview). 


## Installation

To install the latest version of `newplaces` from GitHub run:

```
remotes::install_github("aTnT/newplaces")

```

## Google Maps API Key

A Google Maps API key shall be defined in a `MAPS_API_KEY` environment variable. This can be easily done by placing a `MAPS_API_KEY = "YOUR_MAPS_API_KEY"` line inside a .Renviron file saved in the project root directory. To make sure the environment variable is read just restart the R session. 

Alternatively you can set the key by running:

```
library(newplaces)

set_api_key(key = "YOUR_MAPS_API_KEY")

```

See [here how to get an API key from Google](https://developers.google.com/maps/documentation/embed/get-api-key).



## Usage

Presently only Text Search has been implemented. Here's an example:

```
# returns one (great) place:
great_place <- text_search(textQuery = "nature retreat near trails and river in southwest Portugal", pageSize = 1)

```

The function returns a list with four elements: `$places`, `$types`, `$reviews` and `$photos`. If the the API returns non-empty items in any of these list elements, a tibble is returned. If there are no items, the element will be `NA`. We can see that (so far) the `great_place` above has no reviews, but it has photos:

```
great_place

# $places
# # A tbl_json: 1 x 29 tibble with a "JSON" attribute
#   ..JSON              document.id name  id    nationalPhoneNumber internationalPhoneNu…¹ formattedAddress googleMapsUri websiteUri utcOffsetMinutes
#   <chr>                     <int> <chr> <chr> <chr>               <chr>                  <chr>            <chr>         <chr>                 <dbl>
# 1 "{\"name\":\"place…           1 plac… ChIJ… 924 236 699         +351 924 236 699       Carrasqueira, 7… https://maps… https://n…               60
# # ℹ abbreviated name: ¹​internationalPhoneNumber
# # ℹ 19 more variables: adrFormatAddress <chr>, businessStatus <chr>, iconMaskBaseUri <chr>, iconBackgroundColor <chr>, primaryType <chr>,
# #   shortFormattedAddress <chr>, goodForChildren <lgl>, plusCode.globalCode <chr>, plusCode.compoundCode <chr>, location.latitude <dbl>,
# #   location.longitude <dbl>, displayName.text <chr>, displayName.languageCode <chr>, primaryTypeDisplayName.text <chr>,
# #   primaryTypeDisplayName.languageCode <chr>, viewport.low.latitude <dbl>, viewport.low.longitude <dbl>, viewport.high.latitude <dbl>,
# #   viewport.high.longitude <dbl>
# 
# $types
# # A tibble: 4 × 2
#   document.id types.includedType
#         <int> <list>            
# 1           1 <chr [1]>         
# 2           1 <chr [1]>         
# 3           1 <chr [1]>         
# 4           1 <chr [1]>         
# 
# $reviews
# [1] NA
# 
# $photos
# # A tibble: 3 × 4
#   document.id photos.name                                                                                            photos.widthPx photos.heightPx
#         <int> <chr>                                                                                                           <dbl>           <dbl>
# 1           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZkBL_PFkYKppUBEf384jbSwUtiNHUIbJ92izd6Po0pWDQNVXVaHHwX…           1600            1200
# 2           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZmuimO5xyhpCPGJuMnEwlScDQx6VELJOBgjCsa80uZMbG8s7nqICHO…           4608            3456
# 3           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZlEY2GsD3XnkUaqYh08XxxNCbILpBX87tWWBBol6gOtyftMAPgVc6S…           1600            1200

```

The primary information about the returned places will be available in `$places`:

```
# Name of the place:
great_place$places$displayName.text
# [1] "Nature retreat, trails & river"

# It's website:
great_place$places$websiteUri
# [1] "https://nature-retreat.com/"

# It's address:
great_place$places$formattedAddress
# [1] "Carrasqueira, 7630-174 São Luís, Portugal"

```

Here below other examples, showcasing the function argument possibilities:


```

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

# prints the the request (incl. auth header) to the console, useful when debugging/reprexing. Beware to accidentally leak credentials while using it!:
text_search(textQuery = "nature retreat near trails and river in southwest Portugal", show_request = TRUE)

```

