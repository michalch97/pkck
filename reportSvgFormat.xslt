<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2000/svg">
    <xsl:output indent="yes" cdata-section-elements="style"/>

    <xsl:param name="bar_width" select="40"/>
    <xsl:param name="bar_height" select="400"/>
    <xsl:param name="bar_spacing" select="5"/>
    <xsl:param name="plot_spacing" select="60"/>

    <xsl:template match="/customers_report">
        <svg class="mainSvg">
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
                        font-family: Arial;
                        font-weight: bold;
                        fill: red;
                      }

                      text.barLabel {
                        font-family: Arial;
                        font-weight: bold;
                        fill: DarkGreen;
                      }

                      .highlight {
                        fill: pink !important;
                        stroke: red;
                        stroke-width: 2;
                      }
                    ]]>
                </style>

                <script type="text/javascript">
                    <![CDATA[
                    function highlight(object) {
                        let attribute = object.getAttribute("class");
                        if (attribute === "highlight") {
                            object.setAttribute("class", "rect");
                        } else {
                            object.setAttribute("class", "highlight");
                        }
                    }
                    ]]>
                </script>

                linear-gradient(to right, #1492e5 0%, #1550a2 100%)

                <linearGradient id="backgroundGradientBlue" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" style="stop-color:rgb(132, 195, 237);stop-opacity:1" />
                    <stop offset="100%" style="stop-color:rgb(83, 127, 188);stop-opacity:1" />
                </linearGradient>
            </defs>
            <rect width="100%" height="100%" fill="url(#backgroundGradientBlue)"/>

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
        <xsl:variable name="prev_item" select="../preceding-sibling::customer"/>
        <xsl:call-template name="draw_node">
            <xsl:with-param name="prev_item" select="$prev_item"/>
            <xsl:with-param name="node_name" select="/customers_report/customer/total_launch_cost"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="/customers_report/customer/number_of_launches">
        <xsl:variable name="prev_item" select="../preceding-sibling::customer"/>
        <xsl:call-template name="draw_node">
            <xsl:with-param name="prev_item" select="$prev_item"/>
            <xsl:with-param name="node_name" select="/customers_report/customer/number_of_launches"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="draw_node">
        <xsl:param name="prev_item"/>
        <xsl:param name="node_name"/>

        <g class="item" id="item-{position()}"
           transform="translate(0, {count($prev_item) * ($bar_width + $bar_spacing)})">

            <text class="barLabel" transform="translate(10, {$bar_width * 0.6})">
                <tspan fill-opacity="0">
                    <animate id="label_animation" attributeName="fill-opacity" dur="0.7s" to="1" fill="freeze"/>
                    <xsl:value-of select="./../name"/>
                </tspan>
            </text>
            <g transform="translate(250, 0)">
                <xsl:call-template name="draw_bar">
                    <xsl:with-param name="max_value" select="max($node_name)"/>
                </xsl:call-template>
            </g>
        </g>
    </xsl:template>

    <xsl:template name="draw_bar">
        <xsl:param name="max_value"/>
        <xsl:variable name="height" select="$bar_height * . div $max_value"/>
        <g class="bar">
            <rect class="bar_rect" x="{$bar_spacing}" y="{0}" height="{$bar_width}" width="{$height}" onclick="highlight(this)">
                <animate attributeName="width" from="0" to="{$height}" dur="0.7s" fill="freeze" />
            </rect>
            <text x="{$bar_spacing + $height + 20}" y="{$bar_width * 0.7}">
                <tspan fill-opacity="0">
                    <animate attributeName="fill-opacity" dur="1s" begin="label_animation.end" to="1" fill="freeze"/>
                    <xsl:value-of select="."/>
                </tspan>
            </text>
        </g>
    </xsl:template>
</xsl:stylesheet>