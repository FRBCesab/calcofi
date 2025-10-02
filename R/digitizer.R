#' Interactive data digitalization
#'
#' This function will:
#'   - Import a `tiff` stored in the `data/` folder
#'   - Plot the image
#'   - Ask user to extract metadata (species, cruise, and date)
#'   - Ask user to define the spatial axes
#'   - Ask user to click on data points
#'   - Ask user to extact point values
#'   - Save data (`csv` file) in the `outputs/` folder
#'
#' After this workflow completed for one image, the next image is loaded until
#' all images are processed (except if `image` is not `NULL`).
#'
#' Note that when the output is created, the image is considered as processed.
#'
#' @param image a `character` of length 1. If `NULL` (default), the function
#'   will process all images. If an image name is provided, only this image will
#'   be processed.
#'
#' @param day_night a `logical` of length 1. If `TRUE` (default), user will be
#'   ask to select the color the point. Otherwise, this question will be
#'   skipped.
#'
#' @return No return value.
#'
#' @export

digitizer <- function(image = NULL, day_night = TRUE) {
  if (!is.null(image)) {
    if (!is.character(image)) {
      stop("Argument 'image' must be a character")
    }

    if (length(image) != 1) {
      stop("Argument 'image' must be of length 1")
    }

    if (is.na(image)) {
      image <- NULL
    }
  }

  if (!is.null(image)) {
    digitizer_core(image, day_night)
  } else {
    image <- "..."
    while (!is.null(image)) {
      image <- get_next_image()

      if (is.null(image)) {
        message("Congrats! All maps have been processed!")
        return(invisible(NULL))
      }

      digitizer_core(image, day_night)
    }
  }

  invisible(NULL)
}


#' @noRd

digitizer_core <- function(image, day_night) {
  image_path <- file.path("data", image)

  if (!file.exists(image_path)) {
    stop("Unable to find the image '", image_path, "'")
  }

  cat("\n")
  cli::cli_rule(center = "DIGITIZER")

  cli::cli_h1("Information")
  cat("\n")

  cli::cli_alert_info("Digitizing {.val {basename(image_path)}}")

  par(mar = rep(0, 4))

  image_path |>
    recolorize::readImage() |>
    recolorize::plotImageArray()

  cat("\n")
  cli::cli_h1("Map metadata")
  cat("\n")

  species <- get_species_name()
  cruise <- get_cruise_identifier()
  date <- get_cruise_date()

  cat("\n")
  cli::cli_h1("Axes extent")
  cat("\n")

  meta <- data.frame(
    "species" = species,
    "cruise_id" = cruise,
    "cruise_date" = date
  )

  axes <- locate_axes()

  axes$"coord" <- as.numeric(axes$"coord")
  axes$"value" <- as.numeric(axes$"value")

  cat("\n")
  cli::cli_h1("Point data")
  cat("\n")

  points <- locate_points()

  points$"x" <- as.numeric(points$"x")
  points$"y" <- as.numeric(points$"y")

  points <- xy_to_lonlat(points, axes)

  values <- get_point_values(points, day_night)
  values <- values[, -c(1:2)]

  values$"map" <- basename(image_path)
  values$"species" <- species
  values$"cruise" <- cruise
  values$"date" <- date

  values <- values[, c(
    "map",
    "species",
    "cruise",
    "date",
    "lon",
    "lat",
    "day_night",
    "abundance"
  )]

  write.csv(
    values,
    file.path(
      "outputs",
      gsub("\\.tiff", ".csv", basename(image_path))
    ),
    row.names = FALSE
  )

  invisible(NULL)
}
