all: flightScheduleAuxiliary.xml textReport

flightScheduleAuxiliary.xml: flightSchedule.xml  flightScheduleAuxiliary.xslt
	saxon -o:auxiliary.xml flightSchedule.xml flightScheduleAuxiliary.xslt
	tidy -config tidy-xml.conf -m auxiliary.xml
	unexpand --first-only -t4 auxiliary.xml > flightScheduleAuxiliary.xml
	-rm auxiliary.xml

textReport: flightScheduleAuxiliary.xml reportTextFormat.xslt
	saxon -o:report.txt flightScheduleAuxiliary.xml reportTextFormat.xslt
	
pdfReport: flightScheduleAuxiliary.xml reportPdfFormat.xslt
	saxon -o:reportTemp.fo flightScheduleAuxiliary.xml reportPdfFormat.xslt
	tidy -config tidy-xml.conf -m reportTemp.fo
	fop -fo reportTemp.fo -pdf report.pdf
	-rm reportTemp.fo

svgReport: flightScheduleAuxiliary.xml reportSvgFormat.xslt
	saxon -o:report.svg flightScheduleAuxiliary.xml reportSvgFormat.xslt

clean:
	-rm flightScheduleAuxiliary.xml
	-rm report.txt
	-rm report.pdf
	-rm report.svg

