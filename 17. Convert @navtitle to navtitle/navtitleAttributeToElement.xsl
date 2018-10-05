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
    
    <xsl:template match="*[@navtitle]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @navtitle"/>
            <xsl:if test="count(topicmeta) = 0">
                <topicmeta>
                    <navtitle><xsl:value-of select="@navtitle"/></navtitle>
                </topicmeta>
            </xsl:if>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topicmeta">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
            <xsl:if test="parent::*[@navtitle]">
                <navtitle><xsl:value-of select="parent::*/@navtitle"/></navtitle>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>