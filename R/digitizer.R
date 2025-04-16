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
#' all images are processed.
#' 
#' Note that when the output is created, the image is considered as processed.
#' 
#' @return No return value.
#' 
#' @export

digitizer <- function() {
  image_path <- "..."

  while (!is.null(image_path)) {
    image_path <- get_next_image()

    if (is.null(image_path)) {
      message("Congrats! All maps have been processed!")
      return(invisible(NULL))
    }

    image_path <- file.path("data", image_path)

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

    values <- get_point_values(points)
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
  }

  invisible(NULL)
}
