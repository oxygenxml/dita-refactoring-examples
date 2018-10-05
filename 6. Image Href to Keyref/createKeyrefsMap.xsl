<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:param name="filesList"/>
    <xsl:output doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd" indent="yes"/>
    <xsl:template match="/">
        <map>
            <xsl:call-template name="tokenizeString">
                <xsl:with-param name="list" select="$filesList"/>
            </xsl:call-template>
        </map>
    </xsl:template>
    <xsl:template name="tokenizeString">
        <xsl:param name="list"/>
        <xsl:param name="delimiter" select="';'"/>
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
                <keydef href="{substring-before($list,$delimiter)}" keys="{substring-before($list,$delimiter)}" format="jpg"/>
                <xsl:call-template name="tokenizeString">
                    <xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <keydef href="{$list}" keys="{$list}" format="jpg"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>