import xml.etree.ElementTree as ET
from xml.etree.ElementTree import tostring
tree=ET.parse('metadata.xml')
tree = tree.getroot()
t = tostring(tree)
print(t)
