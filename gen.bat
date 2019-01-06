rem generates uml graphs. Needs graphviz installed
dot -Tpng -o .\generated\dot\scadabt_er.png .\generated\dot\scadabt_er.dot
dot -Tpng -o .\generated\dot\scadabt_uml_small.png .\generated\dot\scadabt_uml_small.dot
rem dot -Tpng -o .\generated\dot\uml.png .\generated\dot\uml.dot
rem dot -Tpng -Kfdp -o .\generated\dot\uml.png .\generated\dot\uml.dot
rem dot -Tpng -Kneato -o .\generated\dot\uml_small.png .\generated\dot\uml_small.dot
rem dot -T png -o .\generated\dot\uml.png .\generated\dot\uml.dot
dot -Tpng -o .\generated\dot\scadabtweb_er.png .\generated\dot\scadabtweb_er.dot
dot -Tpng -o .\generated\dot\scadabtweb_uml_small.png .\generated\dot\scadabtweb_uml_small.dot
@if errorlevel 1 pause