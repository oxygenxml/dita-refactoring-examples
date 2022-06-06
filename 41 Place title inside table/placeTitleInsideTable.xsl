<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Copy everything as it is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p[following-sibling::*[1][self::table[not(title)]]]">
      <!-- Ignore this paragraph, it's followed by a table without a title -->
    </xsl:template>
    <xsl:template match="table[not(title)][preceding-sibling::*[1][self::p]]">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <title><xsl:apply-templates select="preceding-sibling::*[1][self::p]/node()"></xsl:apply-templates></title>
        <xsl:apply-templates select="node()"/>
      </xsl:copy>
    </xsl:template>
</xsl:stylesheet>