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
    
    <xsl:template match="@href | @conref | @conrefend">
        <!--<xsl:message>I am <xsl:value-of select="."/> <xsl:value-of select="matches(., 'ta_')"/></xsl:message>-->
        <xsl:choose>
            <xsl:when test="matches(., '/ta_(.*)#')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(., '/ta_(.*)#', '/t_$1#')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="matches(., '/ta_(.*)$')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(., '/ta_(.*)$', '/t_$1')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="matches(., '/re_(.*)#')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(., '/re_(.*)#', '/r_$1#')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="matches(., '/re_(.*)$')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(., '/re_(.*)$', '/r_$1')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>