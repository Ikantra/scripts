import random
import math

MAXPHEROMONES = 100000
MINPHEROMONES = 1

bestScore = 0
bestSolution = []

alpha = 0.1
beta = 0.1

class Node():
    def __init__(self,name):
        self.name = name
        self.edges = []

    def rouletteWheelSimple(self):
        return random.sample(self.edges,1)[0]
    
    def rouletteWheel(self,visitedEdges,startNode):
        visitedNodes = [oneEdge.toNode for oneEdge in visitedEdges]
        viableEdges = [oneEdge for oneEdge in self.edges if not oneEdge.toNode in visitedNodes and oneEdge.toNode != startNode]

        allPheromones = sum([oneEdge.pheromones**alpha*oneEdge.cost**beta for oneEdge in self.edges if not oneEdge.toNode in visitedNodes])
        num = random.uniform(0,allPheromones)
        s = 0
        i = 0
        selectEdge = viableEdges[i]
        while(s<=num):
            selectEdge = viableEdges[i]
            s += selectEdge.pheromones**alpha*selectEdge**beta
            i += 1
        return selectEdge
        
    def __repr__(self):
        return self.name
    
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
        return self.fromNode.name + "--(" + str(self.cost) + ")--" + self.toNode.name

def evaporate(edges):
    for edge in edges:
        edge.pheromones *= 0.99

def checkAllEdges(edges):
    for edge in edges:
        edge.checkPheromones()

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

print(nodes)
print(edges)

#Greedy
class Greedy:
    def __init__(self):
        self.visitedEdges = []
        self.visitedNodes = []

    def walk(self,startNode):
        currentNode = startNode
        currentEdge = None
        while(not checkAllNodesPresent(self.visitedEdges)):
            possibleEdges = [(edge.cost,edge) for edge in currentNode.edges if edge.toNode not in self.visitedNodes]
            possibleEdges.sort(key= lambda x: x[0])
            currentEdge = possibleEdges[0][1]
            currentNode = currentEdge.toNode
            self.visitedEdges.append(currentEdge)
            self.visitedNodes.append(currentNode)
            print(currentNode,currentEdge)
        
g = Greedy()
g.walk(a)
print("Cost", sum([e.cost for e in g.visitedEdges]))

#Cost function
def getSum(edges):
    return sum(e.cost for e in edges)

MAXCOST = getSum(edges)

class ANT:
    def __init__(self):
        self.visitedEdges = []
        
    def walk(self,startNode):
        currentNode = startNode
        currentEdge = None
        while(not checkAllNodesPresent(self.visitedEdges)):
            #currentEdge = currentNode.rouletteWheelSimple()
            currentEdge = currentNode.rouletteWheel(self.visitedEdges,startNode)
            currentNode = currentEdge.toNode
            self.visitedEdges.append(currentEdge)
    
    def pheromones(self):
        currentCost = getSum(self.visitedEdges)
        if(currentCost<MAXCOST):
            #The Trick
            score = 1./currentCost #Works but is bad
            score = 1000**(1-float(currentCost)/MAXCOST) #Much better score function (will work better if 1000 is higher)
            global bestScore
            global bestEdges
            if(score>bestScore):
                bestScore = score
                bestEdges = self.visitedEdges
            for(oneEdge) in bestEdges:
                oneEdge.pheromones += score
            #for oneEdge in self.visitedEdges:
            #    oneEdge.pheromones += score

#Handing code + 1 page report (3 weeks from 5 november)
for i in range(10000):
    evaporate(edges)
    ant = ANT()
    ant.walk(a)
    ant.pheromones()
    checkAllEdges(edges)
    print(i,getSum(ant.visitedEdges))
