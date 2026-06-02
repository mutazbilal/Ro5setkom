import xml.etree.ElementTree as ET

file_path = r"C:\Users\Lenovo\source\repos\Rokhsetak\Rokhsetak\Resources\Resources.SharedResourceMarker.en.resx"

tree = ET.parse(file_path)
root = tree.getroot()

seen = set()
to_remove = []

for data in root.findall("data"):
    name = data.attrib.get("name")
    if name in seen:
        to_remove.append(data)
    else:
        seen.add(name)

for item in to_remove:
    root.remove(item)

tree.write("Resources.cleaned.resx", encoding="utf-8", xml_declaration=True)