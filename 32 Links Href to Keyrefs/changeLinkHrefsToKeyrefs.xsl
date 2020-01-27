<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs oxy"
    xmlns:oxy="http://www.oxygenxml.com/extensions"
    version="2.0">
    
    <xsl:template match="node() | @*">
      <xsl:copy>
        <xsl:apply-templates select="node() | @*"/>
      </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[local-name() = ('link', 'xref')][@href][not(@format) or @format = 'dita']">
        <xsl:copy>
            <xsl:attribute name="keyref" select="oxy:extractKeyName(@href)"/>
            <xsl:apply-templates select="@* except @href"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="oxy:extractKeyName">
        <xsl:param name="reference"/>
        <xsl:variable name="lastPart">
            <xsl:value-of select="tokenize($reference, '/')[last()]"/>
        </xsl:variable>
        <xsl:value-of select="replace($lastPart, '\.(.*)', '')"/>
    </xsl:function>
</xsl:stylesheet>
