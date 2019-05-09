<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" />

  <xsl:template match="/flight_schedule">
    <customers_report>
      <xsl:apply-templates />
    </customers_report>
  </xsl:template>

  <xsl:template match="/flight_schedule/authors">
    <authors>
      <xsl:for-each select="author">
			  <xsl:sort select="first_name" data-type="text" lang="pl" />
			  <xsl:copy-of select="." />
		  </xsl:for-each>
    </authors>
  </xsl:template>

  <xsl:template match="/flight_schedule/description">
    <title>
      <xsl:copy-of select="." />
    </title>
    <date>
      <xsl:variable name="date">
        <xsl:value-of select="current-dateTime()"/>
      </xsl:variable>
      <day>
        <xsl:value-of select="number(substring($date, 9, 2))" />
      </day>
      <month>
        <xsl:call-template name="monthToString">
          <xsl:with-param name="m">
            <xsl:value-of select="substring($date, 6, 2)" />
          </xsl:with-param>
        </xsl:call-template>
      </month>
      <year>
        <xsl:value-of select="substring($date, 1, 4)" />
      </year>
    </date>
  </xsl:template>

  <xsl:template match="/flight_schedule/customers/customer">
    <customer>
      <xsl:copy-of select="name" />
      <contact_info>
        <xsl:copy-of select="./contact_info/phone_number" />
        <location>
          <xsl:variable name="location_ref">
            <xsl:value-of select="./contact_info/@location_ref" />
          </xsl:variable>
          <xsl:apply-templates select="/flight_schedule/locations/location[@location_id = $location_ref]" />
        </location>
      </contact_info>
      <launches>
        <xsl:variable name="customer_id">
          <xsl:value-of select="@customer_id" />
        </xsl:variable>
        <xsl:apply-templates select="/flight_schedule/launches/launch[@customer_ref = $customer_id]" />
      </launches>
      <costs>
        <xsl:call-template name="getCosts">
          <xsl:with-param name="id" select="@customer_id" />
        </xsl:call-template>
      </costs>
    </customer>
  </xsl:template>

  <xsl:template name="getCosts">
    <xsl:param name="id"/>
    <xsl:for-each-group select="/flight_schedule/launches/launch[@customer_ref = $id]/cost" group-by="@currency">
      <total_launch_cost currency="{./@currency}">
        <xsl:call-template name="add">
          <xsl:with-param name="c">
           <xsl:value-of select="./@currency" />
          </xsl:with-param>
          <xsl:with-param name="id">
           <xsl:value-of select="$id" />
          </xsl:with-param>
        </xsl:call-template>
      </total_launch_cost>
		</xsl:for-each-group>
  </xsl:template>

  <xsl:template name="add">
    <xsl:param name="c"/>
    <xsl:param name="id"/>
    <xsl:value-of select='format-number(sum(for $i in /flight_schedule/launches/launch[@customer_ref = $id] return $i/cost[@currency = $c]),"#")' />
  </xsl:template>

  <xsl:template match="/flight_schedule/locations"/>

  <xsl:template match="/flight_schedule/locations/location">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="/flight_schedule/launches"/>

  <xsl:template match="/flight_schedule/launches/launch">
    <launch>
      <xsl:copy-of select="launch_date" />
      <xsl:copy-of select="cost" />
      <xsl:variable name="launchpad_ref">
        <xsl:value-of select="@launchpad_ref" />
      </xsl:variable>
      <xsl:apply-templates select="/flight_schedule/launchpads/launchpad[@launchpad_id = $launchpad_ref]" />
      <xsl:variable name="payload_ref">
        <xsl:value-of select="@payload_ref" />
      </xsl:variable>
      <xsl:apply-templates select="/flight_schedule/payloads/payload[@payload_id = $payload_ref]" /> 
      <xsl:variable name="rocket_ref">
        <xsl:value-of select="@rocket_ref" />
      </xsl:variable>
      <xsl:apply-templates select="/flight_schedule/rockets/rocket[@rocket_id = $rocket_ref]" /> 
    </launch>
  </xsl:template>

  <xsl:template match="/flight_schedule/launchpads"/>

  <xsl:template match="/flight_schedule/launchpads/launchpad">
    <launchpad>
      <xsl:copy-of select="name" />
      <location>
        <xsl:variable name="location_ref">
          <xsl:value-of select="@location_ref" />
        </xsl:variable>
        <xsl:apply-templates select="/flight_schedule/locations/location[@location_id = $location_ref]" />
      </location>
    </launchpad>
  </xsl:template>

  <xsl:template match="/flight_schedule/payloads"/>

  <xsl:template match="/flight_schedule/payloads/payload">
    <payload>
      <xsl:copy-of select="*" />
    </payload>
  </xsl:template>

  <xsl:template match="/flight_schedule/rockets"/>

  <xsl:template match="/flight_schedule/rockets/rocket">
    <rocket>
      <xsl:copy-of select="*" />
    </rocket>
  </xsl:template>

  <xsl:template name="monthToString">
    <xsl:param name="m" />
    <xsl:choose>
      <xsl:when test="$m = 01">
        <xsl:value-of select="'styczeń'" />
      </xsl:when>
      <xsl:when test="$m = 02">
        <xsl:value-of select="'luty'" />
      </xsl:when>
      <xsl:when test="$m = 03">
        <xsl:value-of select="'marzec'" />
      </xsl:when>
      <xsl:when test="$m = 04">
        <xsl:value-of select="'kwiecień'" />
      </xsl:when>
      <xsl:when test="$m = 05">
        <xsl:value-of select="'maj'" />
      </xsl:when>
      <xsl:when test="$m = 06">
        <xsl:value-of select="'czerwiec'" />
      </xsl:when>
      <xsl:when test="$m = 07">
        <xsl:value-of select="'lipiec'" />
      </xsl:when>
      <xsl:when test="$m = 08">
        <xsl:value-of select="'sierpień'" />
      </xsl:when>
      <xsl:when test="$m = 09">
        <xsl:value-of select="'wrzesień'" />
      </xsl:when>
      <xsl:when test="$m = 10">
        <xsl:value-of select="'październik'" />
      </xsl:when>
      <xsl:when test="$m = 11">
        <xsl:value-of select="'listopad'" />
      </xsl:when>
      <xsl:when test="$m = 12">
        <xsl:value-of select="'grudzień'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'blędny_miesiąc'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>