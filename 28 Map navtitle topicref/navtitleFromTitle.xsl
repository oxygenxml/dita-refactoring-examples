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
    
    <!-- Get topic title and use it to set navtitle on topicref -->
    <xsl:template match="topicref[@href]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @navtitle"/>
            <xsl:attribute name="navtitle"><xsl:value-of select="document(@href)/*/title"/></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>