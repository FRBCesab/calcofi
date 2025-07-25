#' Prompt question - Species name
#'
#' @noRd

get_species_name <- function() {
  cli::cli_alert_success("What is the {cli::col_green('species name')}?")
  readline(prompt = "    Answer: ")
}


#' Prompt question - Cruise Identifier
#'
#' @noRd

get_cruise_identifier <- function() {
  cli::cli_alert_success("What is the {cli::col_green('cruise identifier')}?")
  readline(prompt = "    Answer: ")
}


#' Prompt question - Cruise Date
#'
#' @noRd

get_cruise_date <- function() {
  cli::cli_alert_success("What is the {cli::col_green('cruise date')}?")
  readline(prompt = "    Answer: ")
}


#' Click on map for axes
#'
#' @noRd

locate_axes <- function() {
  corners <- c(
    "x-axis (left)",
    "x-axis (right)",
    "y-axis (bottom)",
    "y-axis (top)"
  )

  data <- data.frame()

  for (corner in corners) {
    cli::cli_alert("Click on the {.val {corner}}")
    coord <- locator(n = 1)

    axis <- unlist(lapply(strsplit(corner, "-"), function(x) x[1]))
    side <- unlist(lapply(strsplit(corner, " "), function(x) x[2]))
    pos <- ifelse(axis == "x", 1, 2)

    tmp <- data.frame(
      "axis" = axis,
      "side" = side,
      "coord" = coord[[pos]]
    )

    data <- rbind(data, tmp)
  }

  cat("\n")
  answers <- NULL
  for (corner in corners) {
    cli::cli_alert_success("What is the value of the {.val {corner}}?")
    answers <- c(
      answers,
      readline(prompt = "    Answer: ")
    )
  }

  data$"value" <- answers
  data$"side" <- gsub("\\(|\\)", "", data$"side")

  data[1:2, "value"] <- paste0("-", data[1:2, "value"])
  data$"value" <- gsub("--", "-", data$"value")

  data
}


#' Click on map for points
#'
#' @noRd

locate_points <- function() {
  cli::cli_alert("Click on the points (right click to stop)")
  xy <- locator()

  data.frame(
    "x" = xy$"x",
    "y" = xy$"y"
  )
}


#' Convert 'usr' coordinates to spatial coordinates
#'
#' @noRd

xy_to_lonlat <- function(points, axes) {
  coords <- data.frame()
  for (i in 1:nrow(points)) {
    lon <- axes[1, "value"] +
      (points[i, "x"] - axes[1, "coord"]) *
        (axes[2, "value"] - axes[1, "value"]) /
        (axes[2, "coord"] - axes[1, "coord"])

    lat <- axes[3, "value"] +
      (points[i, "y"] - axes[3, "coord"]) *
        (axes[4, "value"] - axes[3, "value"]) /
        (axes[4, "coord"] - axes[3, "coord"])

    coords <- rbind(coords, data.frame(lon, lat))
  }

  data.frame(points, coords)
}


#' Prompt question - Point values
#'
#' @noRd

get_point_values <- function(points, day_night = TRUE) {
  cat("\n")
  daynights <- NULL
  abundances <- NULL
  for (i in 1:nrow(points)) {
    points(points[i, "x"], points[i, "y"], cex = 1.5, col = "red")

    if (day_night) {
      cli::cli_alert_success(
        "What is the color of the point? [(b)lack|(w)hite]"
      )
      daynights <- c(
        daynights,
        readline(prompt = "    Answer: ")
      )
    } else {
      daynights <- c(
        daynights,
        "b"
      )
    }

    cli::cli_alert_success("What is the abundance class? [0|1|2|3|4|5|6]")
    abundances <- c(
      abundances,
      readline(prompt = "    Answer: ")
    )

    points(points[i, "x"], points[i, "y"], cex = 1.5, col = "white")
  }

  points$"day_night" <- ifelse(
    substr(tolower(daynights), 1, 1) == "b",
    "Night",
    "Day"
  )
  points$"abundance" <- as.numeric(abundances)

  points
}


#' Get next image to process
#'
#' @noRd

get_next_image <- function() {
  images <- list.files(
    path = "data",
    pattern = "CalCOFI_Atlas_06_Page_[0-9]{3}.tiff"
  )

  if (length(images) == 0) {
    stop("No images detected in 'data/'", call. = FALSE)
  }

  datas <- list.files(
    path = "outputs",
    pattern = "CalCOFI_Atlas_06_Page_[0-9]{3}.csv"
  )

  if (length(datas) == 0) {
    return(images[1])
  }

  if (length(datas) == length(images)) {
    return(NULL)
  }

  image_names <- gsub("\\.tiff", "", basename(images))
  data_names <- gsub("\\.csv", "", basename(datas))

  pos <- which(image_names %in% data_names)

  if (length(pos) > 0) {
    images <- images[-pos]
  }

  images[1]
}
