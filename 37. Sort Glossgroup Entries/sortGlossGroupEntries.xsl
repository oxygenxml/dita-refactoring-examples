<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="glossgroup">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="title"/>
            <xsl:variable name="closestXMLLang"
                select="ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/>
            <xsl:choose>
                <xsl:when test="exists($closestXMLLang)">
                    <xsl:apply-templates select="glossentry">
                        <xsl:sort select="glossterm/text()" lang="{$closestXMLLang}"
                            case-order="lower-first"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="glossentry">
                        <xsl:sort select="glossterm/text()" case-order="lower-first"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
