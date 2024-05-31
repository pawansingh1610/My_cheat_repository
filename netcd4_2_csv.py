#!/usr/bin/env python
# coding: utf-8

# In[14]:


import netCDF4 as nc
import pandas as pd
import os
import numpy as np


# In[15]:


# Define the path to the NetCDF file
nc_file_path = "C:\\Users\\svija\\Desktop\\machoi\\winddata.nc"
output_dir = "C:\\Users\\svija\\Desktop\\machoi"


# In[16]:


if not os.path.exists(output_dir):
    os.makedirs(output_dir)


# In[17]:


ds = netCDF4.Dataset(nc_file_path)


# In[18]:


ds


# In[19]:


data_dict = {}


# In[20]:


# Iterate over each variable in the NetCDF file
for var_name in ds.variables:
    # Extract the variable data
    var_data = ds.variables[var_name][:]
    
    # Flatten the data if it has more than 1 dimension
    if var_data.ndim > 1:
        var_data = var_data.flatten()
    
    # Ensure the data is of type float
    var_data = var_data.astype(float)
    
    # Add the variable data to the dictionary
    data_dict[var_name] = var_data

# Close the NetCDF file
ds.close()

# Find the length of the longest variable data
max_length = max(len(data) for data in data_dict.values())

# Create a DataFrame from the dictionary
# Pad shorter variables with NaN to ensure equal length
df = pd.DataFrame({var_name: np.pad(data, (0, max_length - len(data)), 'constant', constant_values=np.nan) 
                   for var_name, data in data_dict.items()})

print(df)


# In[25]:


import os

# Define the output directory and file name
output_dir = 'C:\\Users\\svija\\Desktop\\machoi\\output.csv'

# Check if the directory exists
output_dirname = os.path.dirname(output_dir)
if not os.path.exists(output_dirname):
    os.makedirs(output_dirname)

try:
    # Save the DataFrame to a CSV file
    df.to_csv(output_dir, index=False)
    print(f"All variables have been combined and saved to {output_dir}")
except PermissionError as e:
    print(f"Permission denied: {e}")
except Exception as e:
    print(f"An error occurred: {e}")

