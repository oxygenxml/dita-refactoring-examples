<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="attrName"/>
    <xsl:param name="elemName"/>
    <xsl:param name="newAttrName"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[local-name()=$elemName][@*[name() = $attrName]]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @*[name() = $attrName]"/>
            <xsl:attribute name="{$newAttrName}">
                <xsl:value-of select="@*[name() = $attrName]"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>