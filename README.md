# Lightweight Phenomic Tutorial

A `learnr` tutorial for RGB orthomosaic analysis and plot-level GLI traits.

# From RGB Pixels to Plot-Level Crop Traits

## A Self-Paced RGB Orthomosaic and Green Leaf Index Tutorial

This repository contains a practical, self-paced **R `learnr` tutorial** for processing RGB orthomosaic imagery and extracting plot-level crop traits. Learners progress through 12 hands-on activities that transform red, green, and blue image bands into the **Green Leaf Index (GLI)**, classify vegetation using **Otsu thresholding**, estimate canopy cover, and summarize phenotypic traits within field-plot boundaries.

The tutorial is designed for students, researchers, plant breeders, agronomists, and others learning remote sensing and high-throughput phenotyping. It runs as a Shiny-prerendered `learnr` tutorial and uses standard R plots and printed tables rather than interactive maps, Plotly graphics, or interactive data tables.

## Learning objectives

After completing the tutorial, learners will be able to:

1. Inspect the structure, resolution, extent, and coordinate reference system of an RGB orthomosaic.
2. Identify and name the Red, Green, and Blue raster bands.
3. Display true-color imagery and compare individual spectral bands.
4. Calculate the Green Leaf Index from RGB pixel values.
5. Examine the distribution of GLI values.
6. Calculate an image-specific vegetation threshold using Otsu's method.
7. Create a binary vegetation mask.
8. Produce a vegetation-only GLI raster.
9. Inspect field-plot polygons, attributes, identifiers, and coordinate reference systems.
10. Align and overlay plot boundaries with raster products.
11. Extract plot-level mean GLI, GLI variability, and canopy cover.
12. Visualize plot-level mean GLI and canopy cover as heatmaps over the RGB orthomosaic.
13. Export plot-level crop traits as a CSV file.

## Tutorial workflow

The tutorial guides learners through the following activities:

### Activity 1: Inspect the RGB orthomosaic

Load the orthomosaic and examine its number of layers, spatial resolution, extent, and coordinate reference system.

### Activity 2: Display the RGB composite

Create a true-color composite using the first three raster bands in the expected order:

1. Red
2. Green
3. Blue

### Activity 3: Name and compare RGB bands

Assign descriptive band names and display the Red, Green, and Blue layers separately to compare their spatial patterns.

### Activity 4: Calculate and save GLI

Calculate the Green Leaf Index for every valid image pixel:

```text
GLI = (2G - R - B) / (2G + R + B)
```

Pixels with a denominator of zero are assigned `NA`. The resulting raster is saved as `outputs/gli.tif`.

### Activity 5: Calculate the Otsu threshold

Apply Otsu's method to a regular sample of valid GLI values. The method identifies a threshold that maximizes between-class variance, helping separate likely vegetation from background pixels. The threshold is saved as `outputs/otsu_threshold.rds`.

### Activity 6: Create a vegetation mask

Classify pixels as vegetation when their GLI value exceeds the Otsu threshold:

```text
Vegetation = 1 when GLI > Otsu threshold
Background = 0 otherwise
```

The binary mask is saved as `outputs/vegetation_mask.tif`.

### Activity 7: Create vegetation-only GLI

Use the vegetation mask to retain GLI values only for classified vegetation pixels. Background pixels are assigned `NA`, and the output is saved as `outputs/vegetation_gli.tif`.

### Activity 8: Inspect field-plot vectors

Examine the plot polygons, attribute fields, geometry type, feature count, and coordinate reference system. The activity also displays each polygon with its `plot_id` label.

If the source data do not contain a recognized plot identifier, the tutorial creates identifiers in the form `Plot_1`, `Plot_2`, and so forth.

### Activity 9: Overlay plot boundaries

Check the raster and vector coordinate reference systems. When necessary, project the plot polygons to the raster coordinate reference system before overlaying them on the vegetation-only GLI layer.

### Activity 10: Extract plot-level traits

Use fractional pixel coverage at polygon boundaries to calculate:

- Mean vegetation GLI
- Standard deviation of vegetation GLI
- Canopy cover percentage

The resulting trait table is saved as `outputs/plot_level_rgb_gli_traits.csv`.

### Activity 11: Create a mean GLI heatmap

Join mean vegetation GLI values to the plot polygons and display transparent, color-coded plot overlays on the RGB orthomosaic. Each plot is labeled with its mean GLI value.

### Activity 12: Create a canopy-cover heatmap

Display plot-level canopy cover as transparent green overlays on the RGB orthomosaic. Each polygon is labeled with its canopy-cover percentage.

## Required input data

The tutorial expects the following input files:

```text
data/
├── rgb_orthomosaic.tif
└── plot_boundaries.geojson
```

### RGB orthomosaic requirements

- The orthomosaic must contain at least three bands.
- The first three bands must be ordered as Red, Green, and Blue.
- The raster must contain valid numeric pixel values.
- The tutorial uses only the first three bands if the source image contains additional layers.

### Plot-boundary requirements

The GeoJSON file must contain polygon features representing experimental plots. The tutorial searches for a plot identifier using the following field names, in order:

```text
plot_id, Plot_ID, plot, Plot, id, ID
```

If none of these fields exists, sequential identifiers are created automatically.

## Repository structure

A recommended repository structure is:

```text
Phenomic_Tutorial/
├── data/
│   ├── rgb_orthomosaic.tif
│   └── plot_boundaries.geojson
├── outputs/
├── RGB_GLI_Plot_Traits.Rmd
├── install.R
├── Dockerfile
├── runtime.txt
├── LICENSE
└── README.md
```

The `outputs/` directory is created automatically when the tutorial starts.

## Software requirements

The tutorial uses R and the following packages:

- `learnr` for the self-paced tutorial environment
- `shiny` for the tutorial runtime
- `terra` for raster and vector processing
- `sf` for spatial vector objects and geometry operations
- `exactextractr` for fractional-coverage polygon extraction

A current R installation and RStudio are recommended for local use.

## Install required packages

Run the following command in R:

```r
install.packages(c(
  "learnr",
  "shiny",
  "terra",
  "sf",
  "exactextractr"
))
```

If the repository includes `install.R`, packages can instead be installed with:

```r
source("install.R")
```

Some spatial packages rely on system libraries. On Linux, installation may require GDAL, GEOS, PROJ, and related development libraries. A repository-provided Docker or Binder environment can avoid most local system-configuration issues.

## Run the tutorial locally

### 1. Clone the repository

```bash
git clone https://github.com/pspawar71/Phenomic_Tutorial.git
cd Phenomic_Tutorial
```

### 2. Confirm the input files

Verify that these paths exist:

```text
data/rgb_orthomosaic.tif
data/plot_boundaries.geojson
```

### 3. Open the tutorial

Open the `.Rmd` tutorial file in RStudio and select **Run Document**, or run it from the R console:

```r
learnr::run_tutorial("pawar/Plot_Level_GLI_Tutorial.Rmd")
```

Replace the filename in the command if the tutorial file uses a different name.

## Run in Binder

The tutorial includes path-resolution logic for Binder environments where the project is stored in `/home/pawar`.

[Launch the Phenomic Tutorial repository](https://mybinder.org/v2/gh/pspawar71/Phenomic_Tutorial/HEAD?urlpath=rstudio)

Then run the following command in the RStudio Console:
```r
learnr::run_tutorial("pawar/Plot_Level_GLI_Tutorial.Rmd")
```

When using a temporary Binder session:

1. Start the tutorial from the repository's RStudio environment.
2. Complete the activities in order because later activities reuse files created earlier.
3. Download the CSV and any raster outputs before closing the session.
4. Remember that files created during a Binder session may be deleted after the session ends.

## Generated outputs

The tutorial writes intermediate and final products to the `outputs/` directory:

```text
outputs/
├── gli.tif
├── otsu_threshold.rds
├── vegetation_mask.tif
├── vegetation_gli.tif
└── plot_level_rgb_gli_traits.csv
```

### Output descriptions

- `gli.tif`: Continuous pixel-level Green Leaf Index raster.
- `otsu_threshold.rds`: R object containing the calculated Otsu GLI threshold.
- `vegetation_mask.tif`: Binary raster in which 1 represents vegetation and 0 represents background.
- `vegetation_gli.tif`: GLI raster retaining only pixels classified as vegetation.
- `plot_level_rgb_gli_traits.csv`: Plot-level trait table for subsequent analysis.

## Trait-table fields

The final CSV contains the following columns:

| Column | Description |
|---|---|
| `plot_id` | Plot identifier obtained from the polygon attribute table or generated automatically. |
| `mean_vegetation_gli` | Mean GLI among vegetation pixels within the plot, rounded to four decimal places. |
| `sd_vegetation_gli` | Standard deviation of vegetation GLI within the plot, rounded to four decimal places. |
| `canopy_cover_percent` | Percentage of the plot classified as vegetation, rounded to two decimal places. |

`exactextractr` accounts for fractional pixel coverage along plot boundaries during trait extraction.

## Important implementation details

### Sequential workflow

Activities should be run in order. Several later activities read files created by earlier activities rather than recalculating them. For example:

- Activity 5 requires `gli.tif` from Activity 4.
- Activity 6 requires `gli.tif` and `otsu_threshold.rds`.
- Activity 7 requires `gli.tif` and `vegetation_mask.tif`.
- Activity 10 requires `vegetation_gli.tif` and `vegetation_mask.tif`.
- Activities 11 and 12 require the final trait CSV.

### Coordinate reference systems

The plot polygons are automatically projected to the raster coordinate reference system when the two datasets do not match. Nevertheless, users should inspect both coordinate reference systems and verify that the overlay is spatially correct.

### Exercise evaluation

The setup specifies:

```r
learnr::tutorial_options(
  exercise.eval = FALSE,
  exercise.timelimit = 300
)
```

Individual raster-processing activities use longer limits where needed, including up to 600 seconds for plot-level trait extraction. Learners should execute the exercise code in the displayed environment or RStudio Console according to the deployed tutorial configuration.

### Visualization approach

The tutorial intentionally uses standard R graphics and printed tables. It does not use:

- Interactive raster maps
- Interactive vector maps
- Plotly charts
- Interactive data tables

This design reduces software complexity and helps the tutorial run reliably in local and Binder environments.

## Interpretation and quality control

GLI is an RGB-based greenness indicator, not a direct measurement of plant biomass, yield, nitrogen status, or physiological performance. Its values can be affected by:

- Illumination and cloud conditions
- Shadows
- Soil and crop-residue background
- Camera exposure and white balance
- Orthomosaic processing
- Crop growth stage
- Weeds within plots
- Image spatial resolution
- Plot-boundary accuracy

Before using the extracted traits in research analyses:

1. Visually inspect the RGB image, GLI raster, vegetation mask, and plot overlays.
2. Confirm that the first three raster bands are truly Red, Green, and Blue.
3. Check whether the Otsu threshold separates crop vegetation appropriately.
4. Verify plot-boundary alignment at image edges and between neighboring plots.
5. Compare image-derived values with field measurements when possible.
6. Use consistent acquisition and processing settings when comparing dates, genotypes, or treatments.

## Troubleshooting

### Tutorial data folder cannot be located

Expected message:

```text
Could not locate the tutorial data folder.
```

Confirm that both required files exist under the repository's `data/` directory and that their filenames match exactly.

### Orthomosaic has fewer than three bands

Use an RGB GeoTIFF with at least three raster layers. Confirm the band count with:

```r
rgb <- terra::rast("data/rgb_orthomosaic.tif")
terra::nlyr(rgb)
```

### Plot identifiers are missing

The setup generates sequential identifiers if no supported ID field is available. If a meaningful experimental identifier is required, add a unique `plot_id` field to `plot_boundaries.geojson` before running the tutorial.

### Raster and polygons do not overlap

Inspect their coordinate reference systems and extents:

```r
terra::crs(rgb_raw)
terra::crs(plots_raw)
terra::ext(rgb_raw)
terra::ext(plots_raw)
```

A dataset with an incorrect or missing coordinate reference system should be corrected at the source rather than assigned an assumed CRS without verification.

### Otsu segmentation includes soil or shadows

Otsu's method is data-driven and may not always separate crop vegetation perfectly. Inspect the GLI histogram and mask. Strong illumination differences, green weeds, crop residue, or unusual soil backgrounds may require additional preprocessing or a validated thresholding approach.

### Output cannot be written

Confirm that the project directory is writable and that no output file is locked by another application. The tutorial creates `outputs/` automatically and overwrites raster products when activities are rerun.

## Suggested teaching use

A practical teaching sequence is:

1. Introduce RGB reflectance and the GLI equation.
2. Ask learners to inspect the raster and predict which areas will have higher GLI.
3. Compare the three image bands.
4. Calculate GLI and inspect its histogram.
5. Discuss how Otsu thresholding separates pixel classes.
6. Evaluate the vegetation mask against the RGB image.
7. Inspect plot geometry and attributes.
8. Extract plot-level traits.
9. Compare mean GLI, within-plot variability, and canopy cover.
10. Discuss limitations and potential validation measurements.

## Citation

If you use this tutorial in teaching, workshops, extension, or research, please cite the repository:

> Pawar, P. S. *From RGB Pixels to Plot-Level Crop Traits: A Self-Paced RGB Orthomosaic and Green Leaf Index Tutorial*. GitHub repository. [View the Phenomic Tutorial repository](https://github.com/pspawar71/Phenomic_Tutorial)

## Contributing

Contributions are welcome. You can:

1. Fork the repository.
2. Create a feature branch.
3. Add or revise an activity.
4. Test the full workflow from a clean session.
5. Submit a pull request describing the change.

You may also open an issue to report an error, suggest an additional trait, or recommend an instructional improvement.

## License

See the repository's `LICENSE` file for the applicable terms of use, modification, and distribution.

## Author

**Popat Shivaji Pawar**  
Hands-On Remote Sensing and High-Throughput Phenotyping  
[View the GitHub profile](https://github.com/pspawar71)

---

If this tutorial supports your teaching or research, consider starring the repository and sharing it with learners working in remote sensing and high-throughput crop phenotyping.

