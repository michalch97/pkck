all: flightScheduleAuxiliary.xml flightScheduleAuxiliary.xhtml

flightScheduleAuxiliary.xml: flightSchedule.xml  flightScheduleAuxiliary.xslt
# 	xsltproc --stringparam 'date' `date +"%Y%m%d"` --output auxiliary.xml flightScheduleAuxiliary.xslt flightSchedule.xml
	saxon -o:auxiliary.xml flightSchedule.xml flightScheduleAuxiliary.xslt
	tidy -config tidy-xml.conf -m auxiliary.xml
	unexpand --first-only -t4 auxiliary.xml > flightScheduleAuxiliary.xml
	-rm auxiliary.xml

flightScheduleAuxiliary.xhtml: flightScheduleAuxiliary.xml flightScheduleAuxiliaryXHTML.xslt
	saxon -o:auxiliary.xhtml flightScheduleAuxiliary.xml flightScheduleAuxiliaryXHTML.xslt
	tidy -config tidy-xhtml.conf -m auxiliary.xhtml
	unexpand --first-only -t4 auxiliary.xhtml > flightScheduleAuxiliary.xhtml
	-rm auxiliary.xhtml

clean:
	-rm flightScheduleAuxiliary.xml
	-rm flightScheduleAuxiliary.xhtml

