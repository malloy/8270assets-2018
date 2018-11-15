#!/usr/bin/python

###========ReadMe=============###
#1. string is output with prefix: "STR: "
# make sure the prefix of output of your string is: "STR: ". If you set it anything else,
# you need to modify line 72 and 73 in function compareResults() to get it right.

#2. only need python file for test case: x.py
# this code will use your code and python interpreter to run test cases one by one.
# The result files are stored as x.myOut & x.pyOut in the dir "cases" but they are
# automatically removed after run. If you want to keep the output files to see what's going on,
# you could go line 109 and set the argument removeOutputs=False

#3. modify the variable "precisionValue" to set precision of floats.
# In case that the floats output may vary a little from python interpreter, we just guarantee
# the difference is limited in a small number. You may modify it to what you want.
# Because we just implement floats by using c++ float type.So the precision won't be right for
# some large values, e.g. 1000000+1.0/3 

# Recommend: set precision for float
#    1) add #include <iomanip> in includes/literal.h
#    2) cout float with the following statement:
# std::cout<<"FLOAT: "<<setiosflags(std::ios::fixed)<<std::setprecision(8)<<val<< std::endl;

import os, sys
import fnmatch
import subprocess
import filecmp

precisionValue = 0.001
#precisionValue = 0.0000001

def testCode( retcode, msg ):
    if retcode > 0:
        print msg
        sys.exit( 1 )

def runTestCase(dirPath, fileName):
    testPath = os.path.join(dirPath, fileName)
    header = fileName.split(".")[0] # extract the prefix
    myPath = os.path.join(dirPath, header+".myOut")
    pyPath = os.path.join(dirPath, header+".pyOut")
    retcode1 = subprocess.call("./run <"+testPath+"> "+myPath, shell=True)
    retcode2 = subprocess.call("python <"+testPath+"> "+pyPath, shell=True)
    if retcode1 != 0:
        print("\tMy code failed to run the test case;")
    if retcode2 != 0:
        print("\tPython failed to run the test case;")
    runFlag = retcode1 or retcode2 # make sure both myCode and python run well, 0 means right
    return runFlag, myPath, pyPath

def checkFileExistence(*tup):
    flag = True
    for file in tup:
        if not os.path.isfile(file):
            print "file {0} doesn't exist".format(file)
            flag = False
    return flag

def compareResults(myPath, pyPath, removeOutputs=True):
    flag = True
    myFile = open(myPath, 'r')
    pyFile = open(pyPath, 'r')
    myContent = myFile.readlines()
    pyContent = pyFile.readlines()
    if len(myContent) != len(pyContent):
         flag = False
    else:
        for lineIdx in range(len(myContent)):
            myList = myContent[lineIdx].split(":")
            pyList = pyContent[lineIdx]
            myValue = myList[1][1:] # skip the first " "(space) after ":"
            if myList[0] == "STR":
                pyValue = pyList
                if myValue != pyValue:
                    flag = False
                    break
            else:   # deal with floats/ints
                myValueFloat = float(myValue)
                pyValueFloat = float(pyList)
                if abs(myValueFloat-pyValueFloat) > precisionValue:
                    flag = False
                    break
    if removeOutputs:
        retcode1 = subprocess.call("rm "+myPath, shell=True)
        retcode2 = subprocess.call("rm "+pyPath, shell=True)
        if retcode1 != 0:
            print("\tFailed to remove my output;")
        if retcode2 != 0:
            print("\tFailed to remove python output;")
    return flag


testDir = os.path.join( os.getcwd(), 'cases')
if not os.path.isdir( testDir ):
    print testDir, "isn't a directory"
    sys.exit( 1 )

executable = os.path.join(os.getcwd(), "run")
if not os.path.isfile( executable ):
    retcode = subprocess.call("make",shell=True)
    testCode( retcode, "\tFAILED to make the scanner" )

files = os.listdir( testDir )
for x in files:
    if fnmatch.fnmatch(x, "*.py"):
        rflag, myPath, pyPath = runTestCase(testDir, x)
    if (rflag==0) and checkFileExistence(myPath, pyPath):
        cFlag = compareResults(myPath, pyPath, removeOutputs=True)
        if cFlag:
            print "testcase: {0} passed".format(x)
        else:
            print "\tTEST CASE FAILED:", x
