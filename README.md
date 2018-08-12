Roman Peasant Project - Small Finds

(This readme is under development.)

The following page contains the scripts and data for the paper "A Behavioral Analysis of Monetary Exchange and Craft Production in Rural Tuscany via Small Finds from the Roman Peasant Project."

Data can be found at:
- [rppsfcodes.csv](https://github.com/scollinselliott/rppsf/blob/master/data/rppsfcodes.csv) - Artifact codes used to identify each artifact-type, along with the method of quantification used ('c' for count, 'w' for weight, and 'p' for presence').
- [dataset.csv](https://github.com/scollinselliott/rppsf/blob/master/data/dataset.csv) - Quantites of each artifact-type found by site-phase. Empty cells in the csv file are the result of extra rows in the project database entered for the sake of inventory, and can be ignored. 
- rppsfontology - Semantic network of artifact-to-activity 

Analysis was carried out using Python and R.

-	[rppsf-ontology.py](https://github.com/scollinselliott/rppsf/blob/master/python/rppsf-ontology.py) – Redefines artifacts in terms of and rescales finds quantities through subsampling.
-	rppsf-kde.r - Produces the kernel density estimate and resamples, as well as the jitter and scatterplots in the paper.
