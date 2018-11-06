![Semantic graph](http://volweb.utk.edu/~scolli46/assets/images/fig04-952x620.png)

# Small Finds from Roman Peasant Project (2009-2014):

Technical notes on a behavioral analysis of Roman sites in rural Tuscany.

Information may also be found at [https://volweb.utk.edu/~scolli46/rppsf.html](https://volweb.utk.edu/~scolli46/rppsf.html).

The code below depends on the following csv files which contain the semantic graph, as the original graph was composed in Gephi and exported: 

> * [dataset.csv](https://github.com/scollinselliott/rppsf/blob/master/data/dataset.csv) - table of small finds listed by site, phase, and definition, by count and weight.
> * [nodes.csv](https://github.com/scollinselliott/rppsf/blob/master/data/nodes.csv) - the nodes of the network.
> * [edges.csv](https://github.com/scollinselliott/rppsf/blob/master/data/edges.csv) - the links of the network.
> * [sfcodes.csv](https://github.com/scollinselliott/rppsf/blob/master/data/sfcodes.csv) - a list of codes used for the RPP small finds assemblage, derived from [rppsfnodes.csv](https://github.com/scollinselliott/rppsf/blob/master/data/sfnodes.csv).
> * [rppsfnodes.csv](https://github.com/scollinselliott/rppsf/blob/master/data/sfnodes.csv) - definitions and metrics of each artifact-type.
> * [qmethod.csv](https://github.com/scollinselliott/rppsf/blob/master/data/qmethod.csv) - quantitative metric used for each artifact-type (c: count, w: weight, p: presence/absence).


A more compact version of the network is available in JSON:
> * [rppsf.json](https://github.com/scollinselliott/rppsf/blob/master/data/rppsf.json) - full semantic graph with nodes and links.

The following scripts compute an index of a function or behavior, as indicated on the semantic graph above, for further multivariate analysis:
> 1. [rppsf-ontology.py](https://github.com/scollinselliott/rppsf/blob/master/python/rppsf-ontology.py) - associates artifact-types with behaviors of interest and generates a set estimates of the intensity of that behavior as an index from 0 to 1 through random subsampling.
> 2. [https://github.com/scollinselliott/rppsf/blob/master/R/indices.r](https://github.com/scollinselliott/rppsf/blob/master/R/indices.r) - used to produce plots; resamples distributions generated from the previous script to evaluate credible intervals.
> 3. [https://github.com/scollinselliott/rppsf/blob/master/R/mds.r](https://github.com/scollinselliott/rppsf/blob/master/R/mds.r) - performs non-metric multidimensional scaling on the modes (argmax) of behavioral indices. Creates a distance matrix (Euclidean) and uses Kruskal's nMDA (iso.mda).
