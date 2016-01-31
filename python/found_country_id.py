import sys
import xml.dom.minidom as dom
import libxml2

filename = "country_files/list.xml"

# fetch county-code
if len(sys.argv) < 2 :
    print "Country-Code not defined" 
    sys.exit(1)


c_code = str(sys.argv[1])

# xmlTree = dom.parse(filename)
doc = libxml2.parseFile(filename)
ctxt = doc.xpathNewContext()
res = ctxt.xpathEval('//relation[tag[@k = "ISO3166-1" and @v = "' + c_code + '"]]/@id') + ctxt.xpathEval('//relation[tag[@k = "ISO3166-1:alpha2" and @v = "' + c_code + '"]]/@id')

ids = []

for rel in res:
    id = rel.content
    if id not in ids:
        ids.append(id)

for id in ids:
    print id
