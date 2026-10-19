# Lightweight Phenomic Tutorial

A `learnr` tutorial for RGB orthomosaic analysis and plot-level GLI traits.

# From RGB Pixels to Plot-Level Crop Traits

A practical, self-paced tutorial on **remote sensing** and **high-throughput plant phenotyping**. This repository provides hands-on activities for converting RGB orthomosaic imagery into plot-level crop traits using the **Green Leaf Index (GLI)**, vegetation segmentation, field-plot boundaries, and reproducible workflows in R.

## Overview

High-throughput phenotyping uses sensors, imagery, and computational methods to measure crop characteristics efficiently across many experimental plots. In this tutorial, learners work through an applied workflow that connects image pixels to meaningful plot-level measurements.

The tutorial is designed for students, researchers, plant breeders, agronomists, and others who want practical experience with drone or aerial RGB imagery and spatial analysis in R.

## Learning objectives

By completing the tutorial, learners will be able to:

- Understand how RGB imagery supports remote sensing and crop phenotyping.
- Import and inspect an RGB orthomosaic in R.
- Confirm the expected red, green, and blue band order.
- Calculate the Green Leaf Index from RGB reflectance values.
- Apply Otsu thresholding to separate vegetation from background pixels.
- Create and inspect a vegetation mask.
- Overlay field-plot boundaries on raster-derived products.
- Extract plot-level phenotypic traits.
- Export analysis results for further statistical analysis.
- Follow a reproducible, self-paced geospatial workflow.

## Workflow

The tutorial follows this general sequence:

1. Load the required R packages and input data.
2. Import the RGB orthomosaic.
3. Inspect the red, green, and blue image bands.
4. Calculate GLI for each pixel:

   ```text
   GLI = (2G - R - B) / (2G + R + B)
   ```

5. Use Otsu segmentation to identify an image-based vegetation threshold.
6. Generate a binary vegetation mask.
7. Apply the mask to retain vegetation pixels.
8. import and align the field-plot boundaries.
9. Extract plot-level GLI and vegetation traits.
10. Export the resulting table as a CSV file.

## Repository contents

```text
Phenomic_Tutorial/
├── data/
│   ├── rgb_orthomosaic.tif
│   └── plot_boundaries.geojson
├── Plot_Level_GLI_Tutorial.Rmd
├── install.R
├── Dockerfile
├── runtime.txt
├── LICENSE
└── README.md
```

- `Plot_Level_GLI_Tutorial.Rmd`: Guided tutorial with explanations and executable R code.
- `install.R`: Installs the R packages required by the tutorial.
- `data/`: Contains the RGB orthomosaic and field-plot boundary files.
- `Dockerfile` and `runtime.txt`: Define the reproducible Binder environment.

## Required data

The workflow expects these files:

```text
data/rgb_orthomosaic.tif
data/plot_boundaries.geojson
```

The expected orthomosaic band order is:

1. Red
2. Green
3. Blue

The raster and plot-boundary files should use compatible coordinate reference systems. If they do not, transform the plot boundaries to the raster coordinate reference system before extracting values.


## Instructor RStudio link

```text
https://mybinder.org/v2/gh/pspawar71/Phenomic_Tutorial/HEAD?urlpath=rstudio
```
