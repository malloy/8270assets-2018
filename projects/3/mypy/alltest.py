#!/usr/bin/python

import os
import sys
import fnmatch
import subprocess
import filecmp

EXECUTABLE = os.path.join(os.getcwd(), 'run')
LIB_FOLDER = os.path.join(os.getcwd(), '../Python-2.7.2/')


class TestHarness:
    def __init__(self):
        self.noPassed = 0
        self.noFailed = 0
        self.makeExecutable()

    @classmethod
    def makeExecutable(cls):
        if not os.path.isfile(EXECUTABLE):
            retcode = subprocess.call('make', shell=True)
            assert retcode == 0, '\tFAILED to make the parser'

    def testCode(self, retcode, testcase):
        if retcode > 0:
            print testcase, 'failed'
            self.noFailed += 1
        else:
            # print testcase, 'passed'
            self.noPassed += 1

    def testOneFile(self, root, filename):
        testcase = os.path.join(root, filename)
        toExec = '%s < %s > /dev/null' % (EXECUTABLE, testcase)
        retcode = subprocess.call(toExec, shell=True)
        self.testCode(retcode, testcase)

    def testDirectory(self, testDir):
        assert os.path.isdir(testDir), testDir + 'must be a directory'
        for root, dirs, files in os.walk(testDir):
            for filename in files:
                if filename.endswith('.py'):
                    self.testOneFile(root, filename)

    def runTestCases(self, testPath):
        if os.path.isdir(testPath):
                self.testDirectory(testPath)
        elif os.path.isfile(testPath):
                self.testOneFile(os.getcwd(), testPath)

    def __str__(self):
        return ('\t%d test cases Passed\n' % self.noPassed) +  \
                     ('\t%d test cases Failed' % self.noFailed)


if __name__ == '__main__':
    testcases = []
    if len(sys.argv) <= 1:
        testcases = [LIB_FOLDER]
    else:
        testcases = sys.argv[1:]
    harness = TestHarness()
    for t in testcases:
        harness.runTestCases(t)
    print harness
