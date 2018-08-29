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

A more compact version of the network is available in JSON:
> * [rppsf.json](https://github.com/scollinselliott/rppsf/blob/master/data/rppsf.json) - full graph with nodes and links.

1. [Uploading converting the csv files to a python dictionary.](https://github.com/scollinselliott/rppsf/blob/516fb8f87a1285575b49bf1c605e646287f5e02f/python/rppsf-ontology.py#L1-L46)

```python
#match rppsf codes 
rppsfcodes = dict()
with open('rppsf.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        for j in range(len(nodes)):
            if nodes.get(j) == row[0]:
                rppsfcodes[j] = row[0]

#define recursive trace function
def pathtrace(start, depth=10):
    """ negative depths means unlimited recursion """
    kats1 = []

    # recursive function that collects all the ids in `acc`
    def recurse(current, depth):
        kats1.append(current)
        if depth != 0:
            if current != '':
                for step in steps.get(current):
                # recursive call for each subfolder
                    recurse(step, depth-1)

    recurse(start, depth) # starts the recursion
    return kats1

#run a trace on the semantic map to remap definitions
semmap = dict()
for k in nodes.keys():
    tracing = list(set(pathtrace(k)))
    tracing = [x for x in tracing if x in signodes.keys()]
    semmap[k] = tracing
```
