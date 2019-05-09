all: flightScheduleAuxiliary.xml #prezentacja.txt prezentacja.xhtml prezentacja.pdf

flightScheduleAuxiliary.xml: flightSchedule.xml  flightScheduleAuxiliary.xslt
# 	xsltproc --stringparam 'date' `date +"%Y%m%d"` --output auxiliary.xml flightScheduleAuxiliary.xslt flightSchedule.xml
	saxon -o:auxiliary.xml flightSchedule.xml flightScheduleAuxiliary.xslt
	sed -i 's/ćwiczenia/cwiczenia/g' auxiliary.xml
	tidy -config tidy-xml.conf -m auxiliary.xml 2>tidy1.log
	sed -i 's/cwiczenia/ćwiczenia/g' auxiliary.xml
	unexpand --first-only -t4 auxiliary.xml > flightScheduleAuxiliary.xml
	-rm auxiliary.xml

# prezentacja.txt: flightScheduleAuxiliary.xml pomocniczy-tekst.xsl
# 	xsltproc --output prezentacja.txt pomocniczy-tekst.xsl flightScheduleAuxiliary.xml
# 
# prezentacja.xhtml: flightScheduleAuxiliary.xml pomocniczy-xhtml.xsl
# 	xsltproc --output prezentacja-tmp.xhtml pomocniczy-xhtml.xsl flightScheduleAuxiliary.xml 
# 	tidy -config tidy-xhtml.conf -m prezentacja-tmp.xhtml 2>tidy2.log
# 	unexpand --first-only -t4 prezentacja-tmp.xhtml > prezentacja.xhtml
# 	-rm prezentacja-tmp.xhtml
# 
# prezentacja.pdf: flightScheduleAuxiliary.xml pomocniczy-pdf.xsl
# 	xmlroff flightScheduleAuxiliary.xml pomocniczy-pdf.xsl -o prezentacja.pdf

clean:
	-rm flightScheduleAuxiliary.xml
	-rm tidy1.log
# 	-rm auxiliary.xml
# 	-rm prezentacja.txt
# 	-rm prezentacja.xhtml
# 	-rm prezentacja.pdf
# 	-rm xmllint1.log
# 	-rm xmllint2.log
# 	-rm tidy2.log
