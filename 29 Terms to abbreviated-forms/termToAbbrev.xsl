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
    
    <!-- Convert <term id="PLEM">PLEM</term> to <abbreviated-form  keyref="PLEM"/> -->
    <!-- Match a term which has the @id attribute equal to its text value -->
    <xsl:template match="term[@id=text()]">
        <abbreviated-form keyref="{@id}"/>
    </xsl:template>
</xsl:stylesheet>