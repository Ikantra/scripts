import math
import csv
import matplotlib.pyplot as plt

outputFormat = ".csv"
generalPath = "C:/Users/ikantra/Downloads/City data for ant/" 
inputPath = generalPath+"GeoLiteCity_20180327/GeoLiteCity-Location"+outputFormat
gwFiles = generalPath+"goodwin files/"
plotFile1 = "evap"+outputFormat
plotFile2 = "mmas"+outputFormat
labelName1 = "evap"
labelName2 = "mmas"
outputPath = generalPath+"output/"
sortingRow = 3      #Which row would you like to sort by? "city" in our example which is index 4-1=3 (0 index vs not)
minNameSize = 2+3   #First element is namelength, second is emptylength string being 3 here
outputName1 = "test2"+outputFormat
outputName2 = "test3"+outputFormat
outputName3 = "test4"+outputFormat
testCityNumberName = "testCityJumps"
mainCity1 = "Oslo"
mainCity2 = "Bergen"
cityJumps = 5

def filterByCountry(inp, out, filterWord, firstLine): #str, str, str, str
    with open(inp, 'r') as f_in:
        with open(out, 'w', newline='') as f_outfile:
            f_out = csv.writer(f_outfile, escapechar=' ',quoting=csv.QUOTE_NONE)

            for line in f_in:
                line = line.strip()
                row = []
                #Just to add the first line
                if firstLine in line:
                    row.append(line)
                    f_out.writerow(row)
                if filterWord in line:
                    row.append(line)
                    f_out.writerow(row)

#filterOutDuplicates(outputPath+outputName1, outputPath+outputName2)
def filterOutDuplicates(inp, out): #Technically not used, but will check full lines for duplicates
    with open(inp,'r') as in_file, open(out,'w') as out_file:
        seen = set() # set for fast O(1) amortized lookup
        for line in in_file:
            if line in seen: continue # skip duplicate

            seen.add(line)
            out_file.write(line)
def filterOutDuplicatesByRow(inp, out, filterRow): #str, str, int
    with open(inp,'r') as in_file, open(out,'w') as out_file:
        seen = set() # set for fast O(1) amortized lookup
        for line in in_file:        #Array to keep track of duplicates
            array = line.split(",") #Splits each line into rows by CSV formatting
            if array[filterRow] in seen:    #
                continue # skip duplicate
            seen.add(array[filterRow])      #Checks the line City for our example
            out_file.write(line)

def filterTooSmallEntities(inp, out, filterRow, sizeOfEnt): #str, str, int, int
    with open(inp,'r') as in_file, open(out,'w') as out_file:
        firstTime = 0 #Help variable to fix ugly way to get first line
        for line in in_file:
            array = line.split(",") #Array to check columns specifically
            if firstTime == 0:      #Ugly fix to get first line regardless
                out_file.write(line)
                firstTime = 1
            if len(array[filterRow]) <= sizeOfEnt:  #If theres less than 2 letters in city name
                continue # skip city
            out_file.write(line)    #Else write as normal

def getSmallSetToWorkWith(inp, out, city1, city2, numberOfJumps): #str, str, str, str, int
    with open(inp,'r') as in_file, open(out+str(numberOfJumps)+outputFormat,'w') as out_file:
        firstTime = 0
        for line in in_file:
            #array = line.split(",") #Array to check columns specifically
            if firstTime >= numberOfJumps+2 and city1 not in line and city2 not in line:  #If theres less than 2 letters in city name
                continue # skip city
            out_file.write(line)    #Else write as normal
            firstTime += 1

def plotThingTest(inp1, inp2, label1, label2):
    data1 = [int(i.split()[1]) for i in open(inp1).readlines()] 
    data2 = [int(i.split()[1]) for i in open(inp2).readlines()] 
    #data1 = [1,1,1,1,3,3,3,3,2,2,2]
    #data2 = [2,2,2,2,2,2,4,4,4,3,3]
    plt.plot(data1,label=label1)
    plt.plot(data2,label=label2)
    plt.legend()
    plt.show()

#filterByCountry(inputPath,outputPath+outputName1,'NO',"postalCode")
#filterOutDuplicatesByRow(outputPath+outputName1,outputPath+outputName2,sortingRow)
#filterTooSmallEntities(outputPath+outputName2,outputPath+outputName3,sortingRow,6)
#getSmallSetToWorkWith(outputPath+outputName3,outputPath+testCityNumberName,mainCity1,mainCity2,cityJumps)

#plotThingTest(gwFiles+plotFile1,gwFiles+plotFile2,labelName1,labelName2)