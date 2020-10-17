# -*- coding: utf-8 -*-
"""
Created on Sat Oct 17 12:25:38 2020

@author: x
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import plotly.express as px

tree_query = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=boroname,health,steward,spc_common,count(tree_id)' +\
        '&$group=boroname,spc_common,steward,health').replace(' ', '%20')

trees = pd.read_json(tree_query)

#Setting up total for tree count by type
tree_totals = trees.groupby(['boroname','health'])['count_tree_id'].sum()
tree_totals = tree_totals.reset_index(drop=False)
tree_totals.columns = ['boroname', 'common_name', 'total_in_boro']

#Setting up total by health
tree_total_spec_health = trees.groupby(['boroname', 'spc_common', 'health'])['count_tree_id'].sum()
tree_total_spec_health = tree_total_spec_health.reset_index(drop=False)
tree_total_spec_health.columns = ['boroname', 'common_name', 'health', 'total']

#combining them
tree_proportions = pd.merge(tree_total_spec_health, tree_totals, on=['boroname', 'common_name'])

#Getting the Ratio
tree_proportions['ratio']=tree_proportions['total']/tree_proportions['total_in_boro']



