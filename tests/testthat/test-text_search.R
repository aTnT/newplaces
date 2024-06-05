
test_that("textQuery & pageSize works", {

  t1 <- text_search(textQuery = "nature retreat in Portugal", pageSize = 1)

  expect_equal(dim(t1$places)[1], 1)

})


test_that("empty response returns NULL", {

  t2 <- text_search(textQuery = "fegegcr7>m10gsdgef4")

  expect_null(t2)
})


test_that("languageCode works", {

  t3 <- text_search(textQuery = "restaurants in China", languageCode = "pt-PT")

  expect_true(
    any(stringr::str_detect(unique(t3$reviews$reviews.text.languageCode), stringr::regex("pt|pt-pt", ignore_case = TRUE)))
  )
})


# test_that("regionCode works", {
#
#   t4 <- text_search(textQuery = "bacalhau restaurants in Portugal", regionCode = "PT")
#
#   expect_false(
#     any(stringr::str_detect(stringr::str_sub(t4$places$formattedAddress, start= -12), stringr::regex("Portugal", ignore_case = TRUE)))
#     )
# })



test_that("rankPreference works", {

  t5 <- text_search(textQuery = "restaurants in Alandroal", rankPreference = "DISTANCE")
  t6 <- text_search(textQuery = "restaurants in Alandroal", rankPreference = "RELEVANCE")

  expect_gte(dim(t6$places)[1], dim(t5$places)[1])
})


test_that("includedType works", {

  t6 <- text_search(textQuery = "restaurants in Alandroal", rankPreference = "RELEVANCE")
  t7 <- text_search(textQuery = "restaurants in Alandroal", includedType = "bar")

  expect_gte(dim(t6$places)[1], dim(t7$places)[1])
})


test_that("openNow works", {

  t6 <- text_search(textQuery = "restaurants in New York", rankPreference = "RELEVANCE")
  t8 <- text_search(textQuery = "restaurants in New York", openNow = "true")

  expect_gte(dim(t6$places)[1], dim(t8$places)[1])
})


test_that("minRating works", {

  t9 <- text_search(textQuery = "restaurants in Alandroal", minRating = 4.5)

  expect_lte(min(t9$places$rating), 4.5)
})


test_that("priceLevels works", {

  pl <- c("PRICE_LEVEL_INEXPENSIVE", "PRICE_LEVEL_MODERATE")
  t10 <- text_search(textQuery = "restaurants in Alandroal", show_request = TRUE, priceLevels = pl )

  expect_equal(sort(unique(t10$places$priceLevel)), sort(pl))
})


test_that("restriction gives error without the right arguments", {

  expect_error(
    text_search(textQuery = "neither me nor my family own a restaurant in Alandroal", location = "restriction",
                circle_center_latitude = 37.71, circle_center_longitude = -8.77, circle_radius = 25000)
  )
})


test_that("bias gives error without the right arguments", {

  expect_error(
    text_search(textQuery = "restaurants that serve bacalhau", location = "bias")
  )
})


test_that("circular location bias works", {

  lat <- 40.75797
  long <- -73.98554

  t11 <- text_search(textQuery = "restaurants in New York",
                     location = "bias", circle_center_latitude = lat, circle_center_longitude = long, circle_radius = 500)

  expect_true(
    abs(round(mean(t11$places$viewport.low.latitude), 2) - round(lat, 2)) <= 0.05
  )

  expect_true(
    abs(round(mean(t11$places$viewport.low.longitude), 2) - round(long, 2)) <= 0.05
  )

})


test_that("rectangular location restriction works", {

  sw <- c(40.75634, -73.99052)
  ne <- c(40.75989, -73.98035)

  t12 <- text_search(textQuery = "slow-food restaurants in New York",
                     location = "restriction", rectangle_lowLatLng = sw, rectangle_highLatLng = ne)

  expect_true(
    abs(round(mean(t12$places$viewport.low.latitude), 2) - round(sw[1], 2)) <= 0.05
  )

  expect_true(
    abs(round(mean(t12$places$viewport.low.longitude), 2) - round(sw[2], 2)) <= 0.05
  )

})


test_that("rectangular location bias works", {

  sw <- c(40.75634, -73.99052)
  ne <- c(40.75989, -73.98035)

  t13 <- text_search(textQuery = "slow-food restaurants in New York",
                     location = "bias", rectangle_lowLatLng = sw, rectangle_highLatLng = ne)

  expect_true(
    abs(round(mean(t13$places$viewport.low.latitude), 2) - round(sw[1], 2)) <= 0.05
  )

  expect_true(
    abs(round(mean(t13$places$viewport.low.longitude), 2) - round(sw[2], 2)) <= 0.05
  )

})
