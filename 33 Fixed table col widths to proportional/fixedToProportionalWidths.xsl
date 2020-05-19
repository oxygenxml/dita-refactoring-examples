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
    
    <xsl:template match="colspec[not(contains(@colwidth, '*'))]">
        <!-- Try to convert fixed widths to proportional widths -->
        <xsl:copy>
            <xsl:apply-templates select="@* except @colwidth"/>
            <xsl:variable name="sumOfAllWidths" as="xs:double" select="sum(../colspec/xs:double(replace(@colwidth, 'pt|px', '')))"/>
            <xsl:variable name="currentWidth" select="xs:double(replace(@colwidth, 'pt|px', ''))" as="xs:double"/>
            <xsl:attribute name="colwidth" select="concat(floor(($currentWidth div $sumOfAllWidths) * 100), '*')"></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>