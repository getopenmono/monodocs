
inputfile = "api_classes.txt"
destination = "reference"
file = open(inputfile,"r")
classes = file.readlines()
file.close()

titlePrefix = "# "
blockPrefix = "```eval_rst\n.. doxygenclass:: "
blockPostfix = "   :project: monoapi\n   :path: xml\n   :members:\n```"

content = open(destination+"/reference.md","w")
content.write("# API Reference\n\n")

for c in classes:
	# Section separation
	if c.startswith("#"):
		content.write("\n"+c)
		continue
	
	fileName = c.replace("::","_").replace("\n","")+".md"
	print "Writing class: "+fileName
	nameList = c.split("::")
	baseName = nameList[len(nameList)-1]
	f = open(destination+"/"+fileName,"w")
	f.write(titlePrefix+baseName+"\n\n")
	f.write(blockPrefix+c)
	f.write(blockPostfix)
	f.close()
	content.write(" * ["+baseName.replace("\n","")+"]("+fileName+")\n")

content.close()