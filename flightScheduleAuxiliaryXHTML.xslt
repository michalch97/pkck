<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xhtml" encoding="utf-8" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/customers_report">
    <html>
      <head>
        <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
        <title>Raport</title>
      </head>
      <body>
        <div style="text-align: center">
          <h1>Podsumowanie lotów dla klientów</h1>
          <h2>
            <xsl:value-of select="./title/description" />
          </h2>
        </div>
        <div style="display: inline-block;">
        <table style="table-layout: fixed; width: 100%" summary="authors_and_date">
        <tr>
          <td style="text-align: left;">
            <h3>Autorzy:</h3>
            <xsl:apply-templates select="./authors/author" />
          </td>
          <td style="text-align: right;">
            <h3>Data wygenerowania raportu:</h3>
            <xsl:apply-templates select="./title/date" />
          </td>
        </tr>
        </table>
        </div>
        <xsl:apply-templates select="./customer" />
      </body>
    </html>
  </xsl:template>
  <xsl:template match="/customers_report/authors/author">
    <xsl:value-of select="first_name" />
    &#160;
    <xsl:value-of select="surname" />
    <br />
  </xsl:template>
  <xsl:template match="/customers_report/customer">
  <div style="text-align:center">
    <div style="display:inline-block;">
      <table style="text-align: left;
                    border-style: double;" summary="customers_table">
        <tr style="background: #707070">
          <th>Nazwa klienta:</th>
          <td>
            <xsl:value-of select="name" />
          </td>
        </tr>
        <tr>
          <th>Numer telefonu:</th>
          <td>
            <xsl:value-of select="./contact_info/phone_number" />
          </td>
        </tr>
        <tr style="background: #707070">
          <th>Lokalizacja klienta:</th>
          <td>
            <xsl:value-of select="./contact_info/location" />
          </td>
        </tr>
        <xsl:for-each select="./launches/launch">
          <tr>
            <th style="padding-top:2%">Lot z dnia</th>
            <td style="padding-top:2%">
              <xsl:value-of select="concat(substring(./launch_date,9,2),'/',substring(./launch_date,6,2),'/',substring(./launch_date,0,5))" />
            </td>
          </tr>
          <tr style="background: #707070">
            <th>Koszt lotu:</th>
            <td>
              <xsl:value-of select="concat(./cost,' ',./cost/@currency)" />
            </td>
          </tr>
          <tr>
            <th>Platforma startowa:</th>
            <td>
              <xsl:value-of select="concat(./launchpad/name,' - ',./launchpad/location)" />
            </td>
          </tr>
          <tr style="background: #707070;">
            <th>Ładunek:</th>
            <td>
              <xsl:value-of select="concat(./payload/payload_type/*,' typu ',./payload/payload_type/*/local-name(),' o wadze ',concat(./payload/mass,' ',./payload/mass/@unit))" />
            </td>
          </tr>
          <tr>
            <th>Rakieta:</th>
            <td>
              <xsl:value-of select="concat(./rocket/name,' o wadze ',concat(./rocket/mass,' ',./rocket/mass/@unit),
          ', sile ciągu ',concat(./rocket/thrust,' ',./rocket/thrust/@unit),
          ', ładowności ',concat(./rocket/payload_capacity,' ',./rocket/payload_capacity/@unit),
          ' i koszcie ',concat(./rocket/cost,' ',./rocket/cost/@currency))" />
            </td>
          </tr>
        </xsl:for-each>
        <tr>
          <th style="padding-top:2%">Całkowity koszt lotów:</th>
          <td style="padding-top:2%">
            <xsl:value-of select="concat(total_launch_cost,' ',total_launch_cost/@currency,' ')" />
          </td>
        </tr>
        <tr style="background: #707070;">
          <th>Ilość lotów:</th>
          <td>
            <xsl:value-of select="number_of_launches" />
          </td>
        </tr>
        <tr>
          <th>Średni koszt lotu:</th>
          <td>
            <xsl:value-of select="concat(average_launch_cost,' ',average_launch_cost/@currency,' ')" />
          </td>
        </tr>
      </table>
    </div>
    </div>
  </xsl:template>
  <xsl:template match="/customers_report/date">
    <span>
      <xsl:value-of select="day" />
    </span>
    <span>
      <xsl:value-of select="month" />
    </span>
    <span>
      <xsl:value-of select="year" />
    </span>
    <br />
  </xsl:template>
</xsl:stylesheet>