#!/usr/bin/env python
# This software is part of OpenMono, see http://developer.openmono.com
# Released under the MIT license, see LICENSE.txt

def build_api_reference(inputfile = "api_classes.txt", destination = "reference"):
	#inputfile = "api_classes.txt"
	#destination = "reference"
	file = open(inputfile,"r")
	classes = file.readlines()
	file.close()

	titlePrefix = "# "
	blockPrefix = "```eval_rst\n.. doxygenclass:: "
	blockPrefixStruct = "```eval_rst\n.. doxygenstruct:: "
	blockPostfix = "   :project: monoapi\n   :path: xml\n   :members:\n   :protected-members:\n```"

	content = open(destination+"/reference.md","w")
	content.write("# API Reference\n\n")

	for c in classes:
		# Section separation
		if c.startswith("#"):
			content.write("\n"+c)
			continue

		fileName = c.replace("::","_").replace("\n","").replace(" ","").replace("#struct","")+".md"
		prefix = blockPrefix
		if c.replace("\n","").endswith("#struct"):
			print "Writing struct: "+fileName
			prefix = blockPrefixStruct
		else:
			print "Writing class: "+fileName

		nameList = c.split("::")
		baseName = nameList[len(nameList)-1].replace(" ","").replace("#struct","")
		f = open(destination+"/"+fileName,"w")
		f.write(titlePrefix+baseName+"\n\n")
		f.write(prefix+c.replace(" ","").replace("#struct",""))
		f.write(blockPostfix)
		f.close()
		content.write(" * ["+baseName.replace("\n","")+"]("+fileName+")\n")

	content.write("""## mbed API

If you need to interact with the *GPIO*, *Hardware interrupts*, *SPI*, *I<sup>2</sup>C*, etc. you should use the *mbed* layer in the SDK. Take a look on the documentation for mbed:

[**mbed documentation**](https://developer.mbed.org/handbook/Homepage)""")

	content.close()

BuildApiReference = build_api_reference

if __name__ == "__main__":
    BuildApiReference()
