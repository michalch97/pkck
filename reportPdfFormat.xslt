<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:variable name="customer_labels" select="('Nazwa klienta', 'Numer Telefonu', 'Lokalizacja',
                                                  'Ilość lotów', 'Całkowity koszt', 'Średni koszt lotu')"/>
    <xsl:variable name="launch_labels" select="('Nazwa klienta', 'Data startu', 'Koszt lotu',
                                                'Platforma startowa', 'Ładunek', 'Rakieta')"/>

    <xsl:template match="/customers_report">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="customers" page-height="12in" page-width="12in" font-family="sans-serif">
                    <fo:region-body region-name="only_region" margin="1in" background-color="#d5fff5"/>
                </fo:simple-page-master>
                <fo:simple-page-master master-name="launches" page-height="12in" page-width="12in" font-family="sans-serif">
                    <fo:region-body region-name="only_region" margin="1in" background-color="#d5fff5"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="customers">
                <fo:flow flow-name="only_region">
                    <fo:block text-align="center" font-weight="bold" font-family="Arial" font-size="40" color="#000000">
                        <xsl:text>Klienci</xsl:text>
                    </fo:block>
                    <fo:table text-align="center">
                        <xsl:call-template name="setup_column_labels">
                            <xsl:with-param name="labels" select="$customer_labels"/>
                        </xsl:call-template>

                        <xsl:apply-templates select="./customer"/>
                    </fo:table>
                </fo:flow>
            </fo:page-sequence>
            <fo:page-sequence master-reference="launches">
                <fo:flow flow-name="only_region">
                    <fo:block text-align="center" font-weight="bold" font-family="Arial" font-size="40" color="#000000">
                        <xsl:text>Loty</xsl:text>
                    </fo:block>

                    <fo:table text-align="center">
                        <xsl:call-template name="setup_column_labels">
                            <xsl:with-param name="labels" select="$launch_labels"/>
                        </xsl:call-template>

                        <xsl:apply-templates select="./customer/launches/launch"/>
                    </fo:table>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="/customers_report/customer">
        <fo:table-body>
            <fo:table-row>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="name"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="./contact_info/phone_number"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="./contact_info/location"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="concat(total_launch_cost,' ',total_launch_cost/@currency,' ')"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="number_of_launches"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="concat(average_launch_cost,' ',average_launch_cost/@currency,' ')"/>
                </xsl:call-template>
            </fo:table-row>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="/customers_report/customer/launches/launch">
        <fo:table-body>
            <fo:table-row>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="./../../name"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="concat(substring(./launch_date,9,2),'/',substring(./launch_date,6,2),'/',substring(./launch_date,0,5))"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="concat(./cost,' ',./cost/@currency)"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="concat(./launchpad/name,' - ',./launchpad/location)"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="./payload/payload_type/*"/>
                </xsl:call-template>
                <xsl:call-template name="create_cell">
                    <xsl:with-param name="cell_value" select="./rocket/name"/>
                </xsl:call-template>
            </fo:table-row>
        </fo:table-body>
    </xsl:template>

    <xsl:template name="setup_column_labels">
        <xsl:param name="labels"/>
        <fo:table-header>
            <fo:table-row>
                <xsl:for-each select="$labels">
                    <xsl:call-template name="create_cell">
                        <xsl:with-param name="cell_value" select="." />
                    </xsl:call-template>
                </xsl:for-each>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>

    <xsl:template name="create_cell">
        <xsl:param name="cell_value"/>
        <fo:table-cell display-align="center">
            <fo:block font-weight="bold" color="#000000">
                <xsl:value-of select="$cell_value"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

</xsl:stylesheet>