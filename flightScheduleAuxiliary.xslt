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
    </title>
  </xsl:template>

  <xsl:template match="/flight_schedule/customers/customer">
    <customer>
      <xsl:copy-of select="name" />
      <contact_info>
        <xsl:copy-of select="./contact_info/phone_number" />
        <location>
          <xsl:value-of select="key('location',./contact_info/@location_ref)/." />
        </location>
      </contact_info>
      <launches>
        <xsl:variable name="customer_id">
          <xsl:value-of select="@customer_id" />
        </xsl:variable>
        <xsl:apply-templates select="/flight_schedule/launches/launch[@customer_ref = $customer_id]" >
        <xsl:sort select="launch_date" data-type="text" order="ascending" />
        </xsl:apply-templates>
      </launches>
      <xsl:call-template name="getCosts">
        <xsl:with-param name="id" select="@customer_id" />
      </xsl:call-template>
    </customer>
  </xsl:template>

  <xsl:template match="/flight_schedule/launches/launch">
    <launch>
      <xsl:copy-of select="launch_date" />
      <xsl:copy-of select="cost" />
      <xsl:variable name="launchpad_ref">
        <xsl:value-of select="@launchpad_ref" />
      </xsl:variable>
      <xsl:apply-templates select="/flight_schedule/launchpads/launchpad[@launchpad_id = $launchpad_ref]" />
      <payload>
        <xsl:copy-of select="key('payload',@payload_ref)/*" />
      </payload>
      <rocket>
        <xsl:copy-of select="key('rocket',@rocket_ref)/*" />
      </rocket> 
    </launch>
  </xsl:template>

  <xsl:template match="/flight_schedule/launchpads/launchpad">
    <launchpad>
      <xsl:copy-of select="name" />
      <location>
        <xsl:value-of select="key('location',@location_ref)/." />
      </location>
    </launchpad>
  </xsl:template>

  <xsl:template match="/flight_schedule/launchpads"/>

  <xsl:template match="/flight_schedule/payloads"/>

  <xsl:template match="/flight_schedule/rockets"/>

  <xsl:template match="/flight_schedule/locations"/>

  <xsl:template match="/flight_schedule/launches"/>

  <xsl:key name="location" match="/flight_schedule/locations/location" use="@location_id"/>
  <xsl:key name="payload" match="/flight_schedule/payloads/payload" use="@payload_id"/>
  <xsl:key name="rocket" match="/flight_schedule/rockets/rocket" use="@rocket_id"/>

  <xsl:template name="getCosts">
    <xsl:param name="id"/>
    <xsl:variable name="currency">
      <xsl:value-of select="/flight_schedule/launches/launch[@customer_ref = $id]/cost/@currency" />
    </xsl:variable>
    <xsl:variable name="exchange_rate">
    <xsl:if test="contains($currency,'EUR')">
      <xsl:value-of>1.12</xsl:value-of>
    </xsl:if>
    <xsl:if test="contains($currency,'PLN')">
      <xsl:value-of>0.26</xsl:value-of>
    </xsl:if>
    <xsl:if test="contains($currency,'USD')">
      <xsl:value-of>1</xsl:value-of>
    </xsl:if>
    </xsl:variable>
    <xsl:variable name="costs">
      <xsl:value-of select='format-number(sum(for $i in /flight_schedule/launches/launch[@customer_ref = $id] return ($i/cost * $exchange_rate)),"#")' />
    </xsl:variable>
    <total_launch_cost currency="USD">
      <xsl:value-of select="$costs" />
    </total_launch_cost>
    <xsl:variable name="launches">
      <xsl:value-of select='format-number(sum(for $i in /flight_schedule/launches/launch[@customer_ref = $id] return 1),"#")' />
    </xsl:variable>
    <number_of_launches>
      <xsl:value-of select="$launches" />
    </number_of_launches>
    <xsl:if test="$launches != 0">
      <average_launch_cost currency="USD">
        <xsl:value-of select='format-number($costs div $launches,"#")' />
      </average_launch_cost>
    </xsl:if>
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