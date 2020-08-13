<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs m"
    version="2.0"
    xmlns:m="http://www.w3.org/1998/Math/MathML">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="m:*">
        <xsl:element name="m:{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="equation-inline">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <mathml>
                <xsl:apply-templates/>
            </mathml>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>