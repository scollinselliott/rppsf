# -*- coding: utf-8 -*-

import numpy
import matplotlib.pyplot as plt
import csv
import random
from collections import Counter
import json

nodes = dict()
signodes = dict()
edges = numpy.zeros((0,2))

#import network from exported gephi file
#import all nodes
with open('nodes.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        nodes[int(row[0])] = row[1]
        
#create list of significant nodes
with open('nodes.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        if row[3] == 'TRUE':
            signodes[int(row[0])] = row[1]

#import all edges
with open('edges.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        edges = numpy.vstack((edges,(int(row[0]),int(row[1]))))

numberofnodes = int(max(edges.flatten()))

#create a dictionary of the linked nodes from each node
steps = dict()
for node in range(numberofnodes + 1):
    nextstep = []
    for row in range(edges.shape[0]):
        if edges[row][0] == node:
            nextstep = nextstep + [edges[row][1]]
    steps[node] = nextstep

dataset = numpy.zeros((0,2))

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
    
simulations = 1000

#import areas as fieldwork intensity
area = dict()
with open('area.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        area[row[0]] = row[1]

#import rppdata
dataset = []
with open('dataset.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        dataset = dataset + [row]

##import quant method
#create dict of quantification methods2
qmethodlist = []
qmethods = dict()
with open('qmethod.csv', 'r') as csv_file:
    reader = csv.reader(csv_file)
    next(reader, None) #skip header
    for row in reader:
        qmethodlist = qmethodlist + [row]
for i in nodes:
    for j in qmethodlist:
        if nodes[i] == j[0]:
            qmethods[i] = j[1]

#list of sites
sites = []
for i in dataset:
    if i[0] not in sites:
        sites.append(i[0])
        
#remove phases and sites which belong to topsoil/medieval contexts to avoid contamination
#remove Colle Massari (insufficient finds data for effective subsampling)
sites.remove('CN Topsoil')
sites.remove('MZ Topsoil')
sites.remove('PI Topsoil')
sites.remove('MZ4')
sites.remove('CN Medieval')
sites.remove('CMM')
sites.remove('CM Topsoil')

#list of finds
lfinds = []
for i in dataset:
    if i[1] not in lfinds:
        lfinds.append(i[1])
        
#remove nonid and unid finds, as well as nonsf
lfinds.remove('YYY')
lfinds.remove('ZZZ')
lfinds.remove('LMP') #remove lamp fragments (part of ceramic assemblage)
lfinds.remove('MTR') #remove mortar samples
#finds.remove('COQ')
#lfinds.remove('PCO')

#create concordance dict of finds from nodes key
finds = dict()
for i in nodes:
    for j in lfinds:
        if nodes[i] == j:
            finds[i] = j


subsamples = 1000
squants = dict()

for s in range(subsamples):
    nsub = random.randint(0,len(dataset))
    subsample = random.sample(dataset, nsub)
    
    findsitequant = dict()
    #create a set of find - sites - quantities normalized
    for i in finds:
        sitequant = dict()
        for site in sites:
            #print(site)
            quant = 0
            findtype = []
            for row in subsample:
                if row[1] == finds.get(i):
                    if row[0] == site:
                        findtype = findtype + [row[1]]
                        method = qmethods.get(i)
                        if method == 'c':
                            quant = quant +  ( ( float(row[2]) + float(row[3]) ) / float(area.get(site)) )
                        if method == 'w':
                            if row[4] != '':
                                quant = quant + ( float(row[4]) / float(area.get(site)) )
                        if method == 'p':
                            quant = quant + 1
                            if quant > 1:
                                quant = 1
            sitequant[site] = quant 
        #normalization
        diff = (max(sitequant.values()) - min(sitequant.values()))
        minval = min(sitequant.values())
        if diff != 0:
            for j in sitequant:
                sitequant[j] = (sitequant.get(j) -  minval) / diff
        findsitequant[i] = sitequant
       
    kquants = dict()
    for k in signodes:
        ksite = dict()
        for site in sites:
            kquant = 0
            for i in findsitequant:
                for j in findsitequant.get(i):
                    if j == site:
                        if k in semmap[i]:
                            kquant = kquant + (float(findsitequant.get(i).get(j))  )
            ksite[site] = kquant
        #normalization
        diff = (max(ksite.values()) - min(ksite.values()))
        minval = min(ksite.values())
        if diff != 0:
            for j in ksite:
                ksite[j] = (ksite.get(j) -  minval) / diff
        kquants[k] = ksite
    squants[s] = kquants

subsampling = dict()
for k in signodes:
    ksite = dict()
    
    for site in sites:
        subs = []
        for s in squants:
            subs = subs + [squants[s].get(k).get(site)]
        ksite[site] = subs
    subsampling[k] = ksite
    
 
colheader = ''
for i in list(signodes.values()):
    colheader = colheader + str(i) + ','

for s in sites:
    result = numpy.zeros((subsamples,len(signodes)))
    colcount = 0
    for k in subsampling.keys():
        #result[0,colcount] = k
    #    for s in subsampling.get(k).keys():
        q = subsampling.get(k).get(s)
        result[0:,colcount] = q 
        colcount = colcount + 1
    numpy.savetxt("result-{0}.csv".format(s), result, delimiter=",", header = colheader,  comments='')
