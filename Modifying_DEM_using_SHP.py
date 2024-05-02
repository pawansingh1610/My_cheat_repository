import rasterio
import fiona
from rasterio.features import geometry_mask
import numpy as np

# Load the DEM
with rasterio.open("C:\\Users\\svija\\Downloads\\scports_complex_dsm.tif") as src:
    dem = src.read(1)
    transform = src.transform
    crs = src.crs
    nodata = src.nodata  # Get the original NoData value

# Open the shapefile
shapefile_path = "C:\\Users\\svija\\Desktop\\saaa.shp"
with fiona.open(shapefile_path, "r") as shapefile:
    for feature in shapefile:
        # Extract each feature (polygon)
        polygon = feature['geometry']

        # Create a mask for the defined region
        region_mask = geometry_mask([polygon], out_shape=dem.shape, transform=transform, invert=True)

        # Extract elevation values within the region
        elevation_values = dem[region_mask]

        # Add the constant value of 20 (changed from 10 to 20 as per your request)
        modified_values = elevation_values + 20

        # Update the DEM with modified values
        dem[region_mask] = modified_values

# Set NoData value to -10000
dem[np.isnan(dem)] = -10000

# Saving the modified DEM
output_path = "C:\\Users\\svija\\Downloads\\modified_dem.tif"
with rasterio.open(output_path, 'w', driver='GTiff', width=dem.shape[1], height=dem.shape[0], count=1, dtype=dem.dtype, crs=crs, transform=transform, nodata=-10000) as dst:
    dst.write(dem, 1)
779727.083395,3307542.036085 [EPSG:32643]