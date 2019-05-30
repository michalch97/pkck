<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2000/svg">
    <xsl:output indent="yes" cdata-section-elements="style"/>

    <xsl:variable name="customer_labels" select="('Nazwa klienta', 'Numer Telefonu', 'Lokalizacja',
                                                  'Ilość lotów', 'Całkowity koszt', 'Średni koszt lotu')"/>

    <xsl:param name="bar_width" select="40"/>
    <xsl:param name="bar_height" select="400"/>
    <xsl:param name="bar_spacing" select="5"/>
    <xsl:param name="plot_spacing" select="60"/>

    <xsl:template match="/customers_report">
        <svg>
            <defs>
                <style type="text/css">
                    <![CDATA[
                      g.bar text {
                        font-family: Arial;
                        fill: black;
                      }
                      g.bar rect {
                        fill: orange;
                      }

                      text.titleText {
                        font-weight: bold;
                        fill: blue;
                      }

                      text.barLabel {
                        font-weight: bold;
                        fill: green;
                      }
                    ]]>
                </style>
            </defs>

            <xsl:variable name="customer_count" select="count(./customer)"/>


            <text class="titleText" transform="translate(60, 40)">Sumaryczny koszt lotów</text>
            <g transform="translate(50, 50)">
                <xsl:apply-templates select="./customer/total_launch_cost"/>
            </g>

            <g transform="translate(0, {($bar_spacing + $bar_width) * ($customer_count + 1)})">
                <text class="titleText" transform="translate(60, 40)">Liczba lotów</text>
                <g transform="translate(50, 50)">
                    <xsl:apply-templates select="./customer/number_of_launches"/>
                </g>
            </g>

        </svg>
    </xsl:template>

    <xsl:template match="/customers_report/customer/total_launch_cost">
        <xsl:variable name="prev-item" select="../preceding-sibling::customer"/>
        <g class="item" id="item-{position()}"
           transform="translate(0, {count($prev-item) * ($bar_width + $bar_spacing)})">

            <text class="barLabel" transform="translate(10, {$bar_width * 0.6})">
                <xsl:value-of select="./../name"/>
            </text>
            <g transform="translate(200, 0)">
                <xsl:call-template name="draw_column">
                    <xsl:with-param name="max_value" select="max(/customers_report/customer/total_launch_cost)"/>
                </xsl:call-template>
            </g>
        </g>
    </xsl:template>

    <xsl:template match="/customers_report/customer/number_of_launches">
        <xsl:variable name="prev-item" select="../preceding-sibling::customer"/>
        <g class="item" id="item-{position()}"
           transform="translate(0, {count($prev-item) * ($bar_width + $bar_spacing)})">

            <text class="barLabel" transform="translate(10, {$bar_width * 0.6})">
                <xsl:value-of select="./../name"/>
            </text>
            <g transform="translate(200, 0)">
                <xsl:call-template name="draw_column">
                    <xsl:with-param name="max_value" select="max(/customers_report/customer/number_of_launches)"/>
                </xsl:call-template>
            </g>
        </g>
    </xsl:template>

    <xsl:template name="draw_column">
        <xsl:param name="max_value"/>
        <xsl:variable name="height" select="$bar_height * . div $max_value"/>
        <g class="bar">
            <rect x="{$bar_spacing}" y="{0}" height="{$bar_width}" width="{$height}"/>
            <text x="{$bar_spacing + $height + 20}" y="{$bar_width * 0.7}">
                <xsl:value-of select="."/>
            </text>
        </g>
    </xsl:template>
</xsl:stylesheet>