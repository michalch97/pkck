<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text" encoding="utf-8" />

  <xsl:variable name="customer_labels" as="xs:string*" select="('Nazwa klienta', 'Numer Telefonu', 'Lokalizacja', 
                                                                'Ilość lotów', 'Całkowity koszt', 'Średni koszt lotu')"/>
  <xsl:variable name="launch_labels" as="xs:string*" select="('Nazwa klienta', 'Data startu', 'Koszt lotu', 
                                                              'Platforma startowa', 'Ładunek', 'Rakieta')"/>
  <xsl:variable name="column_width">25</xsl:variable>
  <xsl:variable name="column_filler" select="'                         '"/>
  <xsl:variable name="new_line" ><xsl:text>&#xa;</xsl:text></xsl:variable>

  <xsl:template match="/customers_report">
      <xsl:value-of select="concat('Raport', $new_line)" />
      <xsl:value-of select="concat('Podsumowanie lotów dla klientów', $new_line, $new_line)"/>
      <xsl:value-of select="concat(./title/description, $new_line, $new_line)"/>
      
      <xsl:value-of select="concat('Autorzy:', $new_line)"/>
      <xsl:apply-templates select="./authors/author"/>
      <xsl:value-of select="$new_line"/>
      
      <xsl:text>Data wygenerowania raportu: </xsl:text>
      <xsl:apply-templates select="./title/date"/>
      <xsl:value-of select="$new_line"/>
      <xsl:value-of select="$new_line"/>
  
      <xsl:call-template name="setup_column_labels">
        <xsl:with-param name="labels" select="$customer_labels"/>
      </xsl:call-template>  
      <xsl:value-of select="$new_line"/>

      <xsl:apply-templates select="./customer"/>
      <xsl:value-of select="$new_line"/>

      <xsl:call-template name="setup_column_labels">
        <xsl:with-param name="labels" select="$launch_labels"/>
      </xsl:call-template>
      <xsl:value-of select="$new_line"/>
      <xsl:apply-templates select="./customer/launches/launch"/>
      <xsl:value-of select="$new_line"/>
  </xsl:template>

  <xsl:template match="/customers_report/authors/author">
    <xsl:value-of select="concat(./first_name, ' ', ./surname, $new_line)"/>
  </xsl:template>

  <xsl:template match="/customers_report/customer">
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="name" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="./contact_info/phone_number" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="./contact_info/location" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="concat(total_launch_cost,' ',total_launch_cost/@currency,' ')" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="number_of_launches" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="concat(average_launch_cost,' ',average_launch_cost/@currency,' ')" />
      </xsl:call-template>
      <xsl:value-of select="$new_line"/>
  </xsl:template>

  <xsl:template match="/customers_report/customer/launches/launch">
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="./../../name" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="concat(substring(./launch_date,9,2),'/',substring(./launch_date,6,2),'/',substring(./launch_date,0,5))" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="concat(./cost,' ',./cost/@currency)" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="concat(./launchpad/name,' - ',./launchpad/location)" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="./payload/payload_type/*" />
      </xsl:call-template>
      <xsl:call-template name="create_cell">
          <xsl:with-param name="cell_value" select="./rocket/name" />
      </xsl:call-template>
      <xsl:value-of select="$new_line"/>
  </xsl:template>

  <xsl:template match="/customers_report/title/date">
      <xsl:value-of select="concat(year, '-', month, '-', day)"/>
  </xsl:template>

  <xsl:template name="setup_column_labels">
      <xsl:param name="labels"/>
      <xsl:for-each select="$labels">
          <xsl:call-template name="create_cell">
            <xsl:with-param name="cell_value" select="." />
          </xsl:call-template>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="create_cell">
      <xsl:param name="cell_value"/>
      <xsl:value-of select="substring(concat($cell_value, $column_filler), 1, $column_width)" />
  </xsl:template>

</xsl:stylesheet>