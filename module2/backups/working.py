# -*- coding: utf-8 -*-
"""
Created on Sat Sep 12 11:36:09 2020

@author: x
"""

import datashader as ds
import datashader.transfer_functions as tf
import datashader.glyphs
from datashader import reductions
from datashader.core import bypixel
from datashader.utils import lnglat_to_meters as webm, export_image
from datashader.colors import colormap_select, Greys9, viridis, inferno
import copy


from pyproj import Proj, transform
import numpy as np
import pandas as pd
import urllib
import json
import datetime
import colorlover as cl

import plotly.offline as py
import plotly.graph_objs as go
from plotly import tools
import plotly.express as px

from shapely.geometry import Point, Polygon, shape
# In order to get shapley, you'll need to run [pip install shapely.geometry] from your terminal

from functools import partial

from IPython.display import GeoJSON

py.init_notebook_mode()

cut_points = np.ndarray.tolist(np.arange(5,120,10))

labels = ['>10'] + [str(i) for i in np.ndarray.tolist(np.arange(10,120,10))]