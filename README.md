# RGB GLI Pixel-to-Plot Notebook

A cumulative, self-paced R notebook. Students run cells in order. Objects remain in memory and are reused rather than recalculated.

## Required data

```text
data/rgb_orthomosaic.tif
data/plot_boundaries.geojson
```

## Binder JupyterLab link

```text
https://mybinder.org/v2/gh/pspawar71/Phenomic_Tutorial/main?labpath=RGB_GLI_Plot_Traits.ipynb
```

## Local use

Open `RGB_GLI_Plot_Traits.ipynb` in JupyterLab with the R kernel. Use **Run All Cells** or run cells sequentially.

## Important implementation detail

The interactive overlay uses:

```r
mapview::mapview(...) %>%
  leafem:::addGeoRaster(x = vegetation_gli, ...)
```

`addGeoRaster()` is an internal function and may change across `leafem` versions.
