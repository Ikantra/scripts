import random
import math
import csv
#import pdb;pdb.set_trace()
MAXPHEROMONES = 100000
MINPHEROMONES = 1
generalPath = "C:/Users/ikantra/Downloads/City data for ant/output/" 
inputFile = generalPath+"testCityJumps"
inputType = ".csv"
outputFileName = generalPath+"output"
nameGreedy = "Greedy"
nameAnt = "Ant"

class Node:
   def __init__(self,name):
        self.name = name
        self.edges = []

   def rouletteWheelSimple(self):
        return random.sample(self.edges,1)[0]

   def rouletteWheel(self,visitedEdges,startNode):
          visitedNodes = [oneEdge.toNode for oneEdge in visitedEdges]
          viableEdges = [oneEdge for oneEdge in self.edges if not oneEdge.toNode in visitedNodes and oneEdge.toNode!=startNode]
          if not viableEdges: 
               viableEdges = [oneEdge for oneEdge in self.edges if not oneEdge.toNode in visitedNodes]

          allPheromones = sum([oneEdge.pheromones for oneEdge in viableEdges])
          num = random.uniform(0,allPheromones)
          s = 0
          i = 0
          selectedEdge = viableEdges[i]
          while(s<=num):
              selectedEdge = viableEdges[i]
              s += selectedEdge.pheromones
              i += 1
          return selectedEdge

   def __repr__(self):
        return(self.name)

class Edge:
   def __init__(self,fromNode,toNode,cost):
       self.fromNode = fromNode
       self.toNode = toNode
       self.cost = cost
       self.pheromones = MAXPHEROMONES

   def checkPheromones(self):
       if(self.pheromones>MAXPHEROMONES):
           self.pheromones = MAXPHEROMONES
       if(self.pheromones<MINPHEROMONES):
           self.pheromones = MINPHEROMONES

   def __repr__(self):
       return(self.fromNode.name+"--("+str(self.cost)+")--"+self.toNode.name)

a = Node("A")
b = Node("B")
c = Node("C")
d = Node("D")
e = Node("E")

nodes = [a,b,c,d,e]
edges = [
   Edge(a,b,100),
   Edge(a,c,175),
   Edge(a,d,100),
   Edge(a,e,75),
   Edge(b,c,50),
   Edge(b,d,75),
   Edge(b,e,125),
   Edge(c,d,100),
   Edge(c,e,125),
   Edge(d,e,75)]

with open(inputFile+str(10)+inputType,'r') as in_file:
    firstTime = 0
    helpVar = 12 #Size -1 as we have identifiers on top
    help2Var = 0
    nodes = [Node] * helpVar 
    testThing = sum(range(helpVar))
    edges = [Edge] * testThing #Since its 0 indexing this would usually be -1
    #City = array[3] // Lattitude = array[5] // Longtitude = array[6]
    for line2 in in_file:
        if firstTime == 0:
            firstTime += 1
            continue
        array = line2.split(",")
        print("Node= "+array[3])
        nodes[help2Var] = Node(""+array[3])
        stag = helpVar-help2Var
        for line in in_file:
            if stag < help2Var+1:
                continue
            array2 = line.split(",")
            lat1 = float(array[5])
            lat2 = float(array2[5])
            lon1 = float(array[6])
            lon2 = float(array2[6])
            helpFloat = math.acos(math.sin(lat1)*math.sin(lat2)+math.cos(lat1)*math.cos(lat2)*math.cos(lon1-lon2))
            help2Float = 2*math.asin(math.sqrt((math.sin((lat1-lat2)/2))**2+math.cos(lat1)*math.cos(lat2)*(math.sin((lon1-lon2)/2))**2))
            testMath = (help2Float/2*math.pi)*6356.752/100
            print("CITY HUAN: "+str(array[3])+" CITY TWO: "+str(array2[3])+" NUMBAH: "+str(testMath)+" "+str(int(testMath)))
            edges[stag+help2Var] = Edge(Node(""+array[3]),Node(""+array2[3]),int(help2Float))
            stag +=1
        help2Var += 1

'''
def nodesFromData(inp, numberOfTowns):
    global nodes
    global edges
    with open(inp+str(numberOfTowns)+inputType,'r') as in_file:
        firstTime = 0
        helpVar = 12 #Size -1 as we have identifiers on top
        help2Var = 0
        nodes = [""] * helpVar 
        testThing = sum(range(helpVar))
        edges = [Edge] * testThing #Since its 0 indexing this would usually be -1
        #City = array[3] // Lattitude = array[5] // Longtitude = array[6]
        for line in in_file:
            if firstTime == 0:
                firstTime += 1
                continue
            array = line.split(",")
            nodes[help2Var] = Node(""+array[3])
            stag = helpVar-help2Var
            for line in in_file:
                if stag <= help2Var:
                    continue
                array2 = line.split(",")
                lat1 = float(array[5])
                lat2 = float(array2[5])
                lon1 = float(array[6])
                lon2 = float(array2[6])
                helpFloat = math.acos(math.sin(lat1)*math.sin(lat2)+math.cos(lat1)*math.cos(lat2)*math.cos(lon1-lon2))
                print(helpFloat)
                edges[stag+help2Var] = Edge(Node(array[3]),Node(array2[3]),int(helpFloat))#INSER DISTANCE NUMBAH!
                stag +=1
            help2Var += 1
    #return nodes, edges

nodesFromData(inputFile, 10)
for testEdge in edges:
    print(testEdge)
'''
'''
def sortEdges(edges):
    print("test")
    return(sorted(edges))
'''

#Make symetrical
for oneEdge in edges[:]:
   edges.append(Edge(oneEdge.toNode,oneEdge.fromNode,oneEdge.cost))
  

#Assign to nodes
for oneEdge in edges:
    for oneNode in nodes:
        if(oneEdge.fromNode==oneNode):
            oneNode.edges.append(oneEdge)


def checkAllNodesPresent(edges):
    visitedNodes = [edge.toNode for edge in edges]
    return set(nodes).issubset(visitedNodes)

class Greedy:
   def __init__(self):
       self.visitedEdges = []   
       self.visitedNodes = []

   def walk(self,startNode):
         currentNode = startNode
         currentEdge = None
         while(not checkAllNodesPresent(self.visitedEdges)):
             possibleEdges = [(edge.cost,edge) for edge in currentNode.edges if edge.toNode not in self.visitedNodes]
             possibleEdges.sort(key=lambda x: x[0])
             #import pdb;pdb.set_trace()
             currentEdge = possibleEdges[0][1]
             currentNode = currentEdge.toNode
             self.visitedEdges.append(currentEdge)
             self.visitedNodes.append(currentNode)
             print(currentNode,currentEdge)

print("Greedy")
g = Greedy()
g.walk(a)
#print("Cost:",sum([e.cost for e in g.visitedEdges]))
with open(outputFileName+nameGreedy+inputType,'w') as out_file:
    for e in g.visitedEdges:
        out_file.write(str(e))    #Else write as normal

#Cost function
def getSum(edges):
    return sum(e.cost for e in edges)
MAXCOST = getSum(edges)
bestScore = 0
bestSolution = []

class ANT:
    def __init__(self):
        self.visitedEdges = []
    
    def walk(self,startNode):
        currentNode = startNode
        currentEdge = None
        while(not checkAllNodesPresent(self.visitedEdges)):
            currentEdge = currentNode.rouletteWheel(self.visitedEdges,startNode)
            currentNode = currentEdge.toNode 
            self.visitedEdges.append(currentEdge)


    def pheromones(self):
        currentCost = getSum(self.visitedEdges)
        if(currentCost<MAXCOST):
            score = 1000**(1-float(currentCost)/MAXCOST) # Score function
            global bestScore
            global bestEdges
            if(score>bestScore):
                bestScore = score
                bestEdges = self.visitedEdges
            for oneEdge in bestEdges:
                oneEdge.pheromones += score

def evaporate(edges):
    for edge in edges:
        edge.pheromones *= 0.99

def checkAllEdges(edges):
    for edge in edges:
        edge.checkPheromones()

for i in range(100000):
    evaporate(edges)
    ant = ANT()
    ant.walk(a)
    ant.pheromones()
    checkAllEdges(edges)
    #print i,getSum(ant.visitedEdges)
    ####print(getSum(ant.visitedEdges))

#Printing
ant = ANT()
ant.walk(a)
'''
for edge in ant.visitedEdges:
    print(edge,edge.pheromones)
'''
with open(outputFileName+nameAnt+inputType,'w') as out_file:
    for edge in ant.visitedEdges:
        out_file.write(""+str(edge)+str(edge.pheromones))    #Else write as normal