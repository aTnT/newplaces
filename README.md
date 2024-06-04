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
set_api_key(key = "YOUR_MAPS_API_KEY")

```

See [here how to get an API key from Google](https://developers.google.com/maps/documentation/embed/get-api-key).



## Usage

Presently only Text Search has been implemented. Here's an example:

```
library(newplaces)

# returns one (great!) place:
text_search(textQuery = "nature retreat near trails and river in southwest Portugal", pageSize = 1)

# Sending request ...
# $places
# # A tbl_json: 1 x 29 tibble with a "JSON" attribute
#   ..JSON           document.id name  id    nationalPhoneNumber internationalPhoneNu…¹ formattedAddress googleMapsUri websiteUri utcOffsetMinutes adrFormatAddress businessStatus
#   <chr>                  <int> <chr> <chr> <chr>               <chr>                  <chr>            <chr>         <chr>                 <dbl> <chr>            <chr>         
# 1 "{\"name\":\"pl…           1 plac… ChIJ… 924 236 699         +351 924 236 699       Carrasqueira, 7… https://maps… https://n…               60 "Carrasqueira, … OPERATIONAL   
# # ℹ abbreviated name: ¹​internationalPhoneNumber
# # ℹ 17 more variables: iconMaskBaseUri <chr>, iconBackgroundColor <chr>, primaryType <chr>, shortFormattedAddress <chr>, goodForChildren <lgl>, plusCode.globalCode <chr>,
# #   plusCode.compoundCode <chr>, location.latitude <dbl>, location.longitude <dbl>, displayName.text <chr>, displayName.languageCode <chr>, primaryTypeDisplayName.text <chr>,
# #   primaryTypeDisplayName.languageCode <chr>, viewport.low.latitude <dbl>, viewport.low.longitude <dbl>, viewport.high.latitude <dbl>, viewport.high.longitude <dbl>
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
# # A tibble: 0 × 1
# # ℹ 1 variable: document.id <int>
# 
# $photos
# # A tibble: 3 × 4
#   document.id photos.name                                                                                                                         photos.widthPx photos.heightPx
#         <int> <chr>                                                                                                                                        <dbl>           <dbl>
# 1           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZmZ2suFo3RoT3uPyGnV1Yk2HWPuPQZV7XeC4gWbU_6XVV7aWhnq4O2SXMDq1oJCzOtOw31enAkiVta3TUha…           1600            1200
# 2           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZnMzemnlvA0BV305JD7S5OhwlGaXnMCcTSuMB8A_YQ8exD-5G0fLx-deHQYERkAq4YkI_5iZElGAOZmzJ4O…           4608            3456
# 3           1 places/ChIJM8N4BPqnGw0R2Bjj7xrQCQ8/photos/AUGGfZnNFZyVAiHSpBhuRDilZ-XvdTPPGo7MzP-udXUH-joS0SkuiT7x0_f_mfA24SnwXJ9vnN4dE6I_L7GCqh3f…           1600            1200

```
Here below other examples:


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

# shows the request (incl. auth header) when debugging/reprexing. Beware to accidentally leak credentials while using it!:
text_search(textQuery = "nature retreat near trails and river in southwest Portugal", show_request = TRUE)

```

