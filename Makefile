all: flightScheduleAuxiliary.xml flightScheduleAuxiliary.xhtml textReport

flightScheduleAuxiliary.xml: flightSchedule.xml  flightScheduleAuxiliary.xslt
	saxon -o:auxiliary.xml flightSchedule.xml flightScheduleAuxiliary.xslt
	tidy -config tidy-xml.conf -m auxiliary.xml
	unexpand --first-only -t4 auxiliary.xml > flightScheduleAuxiliary.xml
	-rm auxiliary.xml

flightScheduleAuxiliary.xhtml: flightScheduleAuxiliary.xml flightScheduleAuxiliaryXHTML.xslt
	saxon -o:auxiliary.xhtml flightScheduleAuxiliary.xml flightScheduleAuxiliaryXHTML.xslt
	tidy -config tidy-xhtml.conf -m auxiliary.xhtml
	unexpand --first-only -t4 auxiliary.xhtml > flightScheduleAuxiliary.xhtml
	-rm auxiliary.xhtml

textReport: flightScheduleAuxiliary.xml reportTextFormat.xslt
	saxon -o:report.txt flightScheduleAuxiliary.xml reportTextFormat.xslt
	
pdfReport: flightScheduleAuxiliary.xml reportPdfFormat.xslt
	saxon -o:reportTemp.fo flightScheduleAuxiliary.xml reportPdfFormat.xslt
	tidy -config tidy-xml.conf -m reportTemp.fo
	fop -fo reportTemp.fo -pdf report.pdf
	-rm reportTemp.fo
	
clean:
	-rm flightScheduleAuxiliary.xml
	-rm flightScheduleAuxiliary.xhtml
	-rm report.txt
	-rm report.pdf

