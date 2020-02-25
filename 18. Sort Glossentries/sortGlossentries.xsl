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
    <xsl:template match="glossarylist | topicgroup[@outputclass='glossarylist']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="closestXMLLang" select="ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/>
            <xsl:choose>
                <xsl:when test="exists($closestXMLLang)">
                    <xsl:for-each select="*" >
                        <xsl:sort select="document(@href, .)/*/glossterm/text()" lang="{$closestXMLLang}" case-order="lower-first"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="*" >
                        <xsl:sort select="document(@href, .)/*/glossterm/text()" case-order="lower-first"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
