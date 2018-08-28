<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="table[not(@morerows) and not(@rowspan) and not(@colspan) and not(title)]">
        <xsl:element name="simpletable">
            <xsl:apply-templates select="@*"/>
            <xsl:if test="tgroup/thead/row">
                    <xsl:for-each select="tgroup/thead/row">
                        <sthead>
                            <xsl:for-each select="entry">
                                <stentry>
                                    <xsl:apply-templates select="node()"></xsl:apply-templates>
                                </stentry>
                            </xsl:for-each>
                        </sthead>
                    </xsl:for-each>
                <xsl:for-each select="tgroup/tbody/row">
                    <strow>
                        <xsl:for-each select="entry">
                            <stentry>
                                <xsl:apply-templates select="node()"></xsl:apply-templates>
                            </stentry>
                        </xsl:for-each>
                    </strow>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>