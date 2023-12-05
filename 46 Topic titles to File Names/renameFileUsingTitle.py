import sys
import shutil
import os
import xml.etree.ElementTree as ET
import re

def copySrcToDst(src, dest):
    try:
        shutil.rmtree(dest)
    except Exception:
        pass
    shutil.copytree(src, dest)

def fillOriginalToNewFileNameMap(folder):
    originalFileNameToNewFileNameMap = {}
    for currentpath, folders, files in os.walk(folder):
        for file in files:
            currentFile = os.path.join(currentpath, file).replace("\\", "/")
            if os.path.isfile(currentFile):
                addTitleToMapping(currentFile, originalFileNameToNewFileNameMap)
    originalFileNameToNewFileNameMap = removeDuplicateValues(originalFileNameToNewFileNameMap)
    return originalFileNameToNewFileNameMap

def removeDuplicateValues(originalFileNameToNewFileNameMap):
    valuesCounter = {}
    fileNamesMapNoDuplicateVals = {}
    for key, value in originalFileNameToNewFileNameMap.items():
        if value in valuesCounter:
            valuesCounter[value] += 1
        else: valuesCounter[value] = 1
    for key, value in originalFileNameToNewFileNameMap.items():
        if valuesCounter[value] == 1:
            fileNamesMapNoDuplicateVals[key] = value
    return fileNamesMapNoDuplicateVals
    

def addTitleToMapping(currentFile, originalFileNameToNewFileNameMap):
    try:
        tree = ET.parse(currentFile)
        titleElement = tree.find(".//title")
        if titleElement == None:
            titleElement = tree.find(".//glossterm")
        if titleElement == None:
            titleElement = tree.find(".//mainbooktitle")
        if titleElement != None and titleElement.text != None and len(titleElement.text.strip()) > 3:
            mytable = str.maketrans(" !?./\\()[]{}@+:=-,;\n#", "_" * 21)
            processedFileName = titleElement.text.strip().translate(mytable).lower();
            processedFileName = processedFileName.replace("_the_", "_")
            processedFileName = processedFileName.replace("_a_", "_")
            processedFileName = re.sub("_+", "_", processedFileName)
            processedFileName = re.sub("^_", "", processedFileName)
            processedFileName = re.sub("_$", "", processedFileName)
            processedFileName += getFileExtension(currentFile)
            originalFileNameToNewFileNameMap[currentFile] = processedFileName
    except Exception as ex:
        #Ignore this exception
        pass

def getFileExtension(file):
    extension = ".dita"
    lastIndexExtension = file.rfind(".")
    if lastIndexExtension != -1:
        extension = file[lastIndexExtension:]
    return extension

def renameFiles(filesToNewNamesMapping):                 
    for file, proposedName in filesToNewNamesMapping.items():
        lastIndexSlash = file.rfind("/")
        parentFolder = file[0:lastIndexSlash]
        try:
            proposedFilePath = parentFolder + "/" + proposedName
            if not os.path.isfile(proposedFilePath):
                os.rename(file, proposedFilePath)
        except Exception as ex:
            pass

def renameReferences(folder, filesToNewNamesMapping):
    for currentpath, folders, files in os.walk(folder):
         for file in files:
             currentFilePath = os.path.join(currentpath, file).replace("\\", "/")
             if os.path.isfile(currentFilePath):
                 renameReferencesInFile(currentFilePath, filesToNewNamesMapping)
                
def renameReferencesInFile(currentFilePath, filesToNewNamesMapping):
    #First rename file refs
    try:
        if not isNonXML(currentFilePath):
            tree = ET.parse(currentFilePath)
            allElements = tree.findall(".//*")
            modified = False
            for element in allElements:
                modified = renameRefAttribute("href", element, filesToNewNamesMapping) or modified
                modified = renameRefAttribute("conref", element, filesToNewNamesMapping) or modified
            if modified:
                serializeTreeWithPreservedDOCTYPE(currentFilePath, tree)
    except Exception as ex:
        print(currentFilePath, ex)
        pass
    
def renameRefAttribute(attrName, element, filesToNewNamesMapping):
    href = element.get(attrName)
    modified = False
    isTopicref = element.tag in ["topicref", "mapref"]
    hasLocalScope = element.get("scope") == None or element.get("scope") == 'local'
    hasDITAFormat = element.get("format") == None or element.get("format") == "dita" or element.get("format") == "ditamap"
    if  href != None and (isTopicref or (hasLocalScope and hasDITAFormat)):
        for file, proposedName in filesToNewNamesMapping.items():
            lastIndexSlash = file.rindex("/")
            currentFileName = file[lastIndexSlash + 1:]
            anchorIndex = href.rfind("#")
            hrefNoAnchor = href
            if anchorIndex != -1:
                hrefNoAnchor = href[0:anchorIndex]
            indexOfCurrentFileName = hrefNoAnchor.rfind(currentFileName)
            if indexOfCurrentFileName != -1:
                if(indexOfCurrentFileName == 0 or indexOfCurrentFileName == hrefNoAnchor.rfind("/") + 1):
                    href = href[0:indexOfCurrentFileName] + proposedName + href[indexOfCurrentFileName + len(currentFileName):]
                    modified = True
                    element.set(attrName, href)
    return modified

def isNonXML(filePath):
    extension = getFileExtension(filePath)
    return extension.lower() in [".png", ".gif", ".jpeg", ".jpg", ".psd", ".txt", ".js", ".html", ".css", ".ds_store", ".yml", ".jar", ".zip", ".exe", ".dll", ".tdi", ".json", ".pdf"]

def serializeTreeWithPreservedDOCTYPE(currentFilePath, tree):
    contentBeforeRoot = ""
    #obtain doctype or xml model before root
    with open(currentFilePath, 'r') as f:
        entireContent = f.read()
        contentBeforeRoot = ""
        if "<!DOCTYPE" in entireContent:
            indexFirstGT = entireContent.find(">", entireContent.find("<!DOCTYPE"))
            indexFirstsubsetEnd = entireContent.find("]>")
            if indexFirstGT < indexFirstsubsetEnd and not ("CDATA" in entireContent[0:indexFirstsubsetEnd] or "codeblock" in entireContent[0:indexFirstsubsetEnd]):
                contentBeforeRoot = entireContent[0:indexFirstsubsetEnd + 2]
            else:
                contentBeforeRoot = entireContent[0:indexFirstGT + 1]
        elif "<?xml-model" in entireContent:
            indexFirstGT = entireContent.find("?>", entireContent.find("<?xml-model"))
            contentBeforeRoot = entireContent[0:indexFirstGT + 2]
        else:
            indexFirstGT = entireContent.find("?>")
            if indexFirstGT != -1:
                contentBeforeRoot = entireContent[0:indexFirstGT + 1]
    #place content before root back
    with open(currentFilePath, 'wb') as f:
        f.write((contentBeforeRoot + "\n").encode('utf8'))
        tree.write(f, 'utf-8')

srcFolder = sys.argv[1].replace("\\", "/")
destFolder = sys.argv[2].replace("\\", "/")
print("Source folder ", srcFolder)
print("Dest folder ", destFolder)
copySrcToDst(srcFolder, destFolder)
originalFileNameToNewFileNameMap = fillOriginalToNewFileNameMap(destFolder)
renameReferences(destFolder, originalFileNameToNewFileNameMap)
renameFiles(originalFileNameToNewFileNameMap)