<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
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
        <xsl:variable name="filePath">
            <xsl:choose>
                <xsl:when test="contains($list, $delimiter)">
                    <xsl:value-of select="substring-before($list,$delimiter)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$list"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
                <xsl:call-template name="tokenizeString">
                    <xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <!-- Output the key definition -->
        <keydef href="{$filePath}" keys="{substring-before($filePath, '.')}" format="{substring-after($filePath, '.')}"/>
    </xsl:template>
</xsl:stylesheet>