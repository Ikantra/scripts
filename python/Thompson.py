import math
#print(sum(range(11)))
'''
with open(inputFile+str(10)+inputType,'r') as in_file:
    firstTime = 0
    helpVar = 12-1 #Size -1 as we have identifiers on top
    help2Var = 1
    stag = 0
    nodes = [Node] * helpVar 
    testThing = sum(range(helpVar))
    #print(testThing)
    edges = [Edge] * testThing #Since its 0 indexing this would usually be -1
    ##City = array[3] // Lattitude = array[5] // Longtitude = array[6]
    for ind1, line2 in enumerate(in_file):
        if ind1 == 0:
            continue
        array = line2.split(",")
        #print("Node= "+array[3])
        nodes[ind1-1] = Node(""+array[3])
        with open(inputFile+str(10)+inputType,'r') as in2_file:
            for ind2, line2 in enumerate(in2_file):
                if ind2 <= help2Var:
                    continue
                array2 = line2.split(",")
                lat1 = float(array[5])
                lat2 = float(array2[5])
                lon1 = float(array[6])
                lon2 = float(array2[6])
                helpFloat = math.acos(math.sin(lat1)*math.sin(lat2)+math.cos(lat1)*math.cos(lat2)*math.cos(lon1-lon2))
                #help2Float = 2*math.asin(math.sqrt((math.sin((lat1-lat2)/2))**2+math.cos(lat1)*math.cos(lat2)*(math.sin((lon1-lon2)/2))**2))
                radToDist = (helpFloat*earthRadialDistance)
                indexOfEdges = int(stag+ind2-help2Var-1)    #stag is total inserted objects so far, index is inserted this for loop, help2var to adjust for skips, and -1 for 0 index
                print("CITY1: "+str(array[3]),"  CITY TWO: ",str(array2[3]),"  NUMBAH: ",str(radToDist)," Trunk:",str(int(radToDist)),"index",indexOfEdges)
                edges[indexOfEdges] = Edge(Node(""+array[3]),Node(""+array2[3]),int(radToDist))
            help2Var += 1
            stag += helpVar-ind1
'''