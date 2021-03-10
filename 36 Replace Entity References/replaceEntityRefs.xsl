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
    
    <xsl:template match="text()">
        <xsl:variable name="textval" select="."/>
        <xsl:variable name="textval" select="replace($textval, '&amp;ent1Initial;', '&amp;ent1Final;')"/>
        <xsl:variable name="textval" select="replace($textval, '&amp;ent2Initial;', '&amp;ent2Final;')"/>
        <xsl:value-of select="$textval"/>
    </xsl:template>
</xsl:stylesheet>