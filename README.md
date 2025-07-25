# CalCOFI maps digitalization <img src="https://raw.githubusercontent.com/FRBCesab/templates/main/logos/compendium-sticker.png" align="right" style="float:right; height:120px;"/>

![Compendium](https://img.shields.io/static/v1?message=Compendium&logo=r&labelColor=5c5c5c&color=yellowgreen&logoColor=white&label=%20)
![Lifecycle Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6)
[![License GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


<p align="left">
• <a href="#overview">Overview</a><br>
• <a href="#workflow">Workflow</a><br> 
• <a href="#content">Content</a><br>
• <a href="#installation">Installation</a><br>
• <a href="#usage">Usage</a><br>
• <a href="#citation">Citation</a><br>
• <a href="#contributing">Contributing</a><br>
• <a href="#acknowledgments">Acknowledgments</a><br>
• <a href="#references">References</a>
</p>



## Overview

This project is dedicated to digitalize pteropod abundance maps from the CalCOFI Atlas No. 6 (McGowan 1967).
Species maps have been scanned, saved as TIFF images and stored in the [`data/`](https://github.com/FRBCesab/calcofi/tree/main/data) directory.



## Workflow

The R function [`digitizer()`](https://github.com/FRBCesab/calcofi/blob/main/R/digitizer.R) is used to interactively extract information from maps and save data in the [`outputs/`](https://github.com/FRBCesab/calcofi/tree/main/outputs) directory. `digitizer()` works as follow:

- Import a `.tiff` stored in the [`data/`](https://github.com/FRBCesab/calcofi/tree/main/data) directory
- Plot the image
- Ask user to extract metadata (species, cruise, and date)
- Ask user to define the spatial axes
- Ask user to click on data points
- Convert coordinates in WGS84 system
- Ask user to extact point values
- Save data (`.csv` file) in the [`outputs/`](https://github.com/FRBCesab/calcofi/tree/main/outputs) directory

After this pipeline is completed for one image, the next image is automatically loaded until all images are processed.

When the output (`.csv` file) is created, the image is considered as processed and it will never be imported again by `digitizer()`. Thus user can digitize maps over a long period.



## Content

This repository is structured as follow:

- [`DESCRIPTION`](https://github.com/frbcesab/calcofi/blob/main/DESCRIPTION): contains project metadata (authors, description, license, dependencies, etc.).
- [`R/`](https://github.com/frbcesab/calcofi/blob/main/R): contains R functions developed especially for this project.
- [`data/`](https://github.com/frbcesab/calcofi/blob/main/data): contains raw data used in this project (CalCOFI maps).
- [`outputs/`](https://github.com/frbcesab/calcofi/blob/main/outputs): contains outputs of the project (one `csv` file per map).



## Installation

To install this project:

- [Fork](https://docs.github.com/en/get-started/quickstart/contributing-to-projects) this repository using the GitHub interface.
- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) your fork using `git clone fork-url` (replace `fork-url` by the URL of your fork). Alternatively, open [RStudio IDE](https://posit.co/products/open-source/rstudio/) and create a New Project from Version Control.

For users that are not familiar with `git`, [Download the ZIP](https://github.com/FRBCesab/calcofi/archive/refs/heads/main.zip) of the project.



## Usage

> [!IMPORTANT]
> Do not use RStudio or Positron to run this project. It depends on the [`locator()`](https://rdrr.io/r/graphics/locator.html) function not supported by these two IDE.

- Open a Terminal (Windows user can open Git Bash)
- Launch R by typing `R`
- Install the `devtools`, `cli` and `recolorize` packages

To run the project:

- Navigate to `calcofi` directory by using `setwd()`
- Load the project by running `devtools::load_all()`
- Start digitalizing maps with `digitizer()`

You will be ask to answer some questions and to click on the map. Just follow instructions.

**NB:** By default, the argument `day_night` of the function `digitizer()` is set to `TRUE`:
user will be ask to select the color the point. Otherwise, this question will be skipped.
If points on the map are all black, use `digitizer(day_night = FALSE)`. If you have two colors,
use `digitizer()` and you will be asked to select the color of the point.


![screenshot](readme/screenshot.png)

For the reporting of data values, two questions will be asked:

1. Color of the point (if `digitizer(day_night = TRUE)`)

- Type `b` for black (night sampling)
- Type `w` for white (day sampling)

2. Abundance classe

- Type `0` for no individual per 1000m<sup>3</sup> of water
- Type `1` for 1-49 individuals per 1000m<sup>3</sup> of water
- Type `2` for 50-499 individuals per 1000m<sup>3</sup> of water
- Type `3` for 500-4,999 individuals per 1000m<sup>3</sup> of water
- Type `4` for 5,000-49,999 individuals per 1000m<sup>3</sup> of water
- Type `5` for 50,000-499,999 individuals per 1000m<sup>3</sup> of water
- Type `6` for > 500,000 individuals per 1000m<sup>3</sup> of water

After digitalizing a first map, have a look at the `outputs/` directory: data should have been saved as a `csv` file (see the [example](https://github.com/FRBCesab/calcofi/blob/main/outputs/Example_of_Output.csv)).
The name of the `csv` will be the same as the image.


## Citation

Please use the following citation:

> Casajus N (2025) Digitalization of CalCOFI maps. URL: <https://github.com/FRBCesab/calcofi/>.


## Acknowledgments

This project has been developed for the [FRB-CESAB](https://www.fondationbiodiversite.fr/en/about-the-foundation/le-cesab/) research group [Dynamite](https://www.fondationbiodiversite.fr/en/the-frb-in-action/programs-and-projects/le-cesab/dynamite/) that aims to synthesize and compile a unique and comprehensive database to reveal the dynamics of aragonite shell production and export in the world ocean today and over recent decades.


## References

McGowan JA (1967) Distributional atlas of pelagic molluscs in the California Current region. CalCOFI Atlas No. 6. URL: <https://calcofi.org/downloads/publications/atlases/CalCOFI_Atlas_06.pdf>
