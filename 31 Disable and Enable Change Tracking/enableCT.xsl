<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:xrf="http://www.oxygenxml.com/ns/xmlRefactoring/functions">
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
        <xsl:variable name="contentAfterRoot" as="xs:string" select="xrf:get-content-after-root()"/>
        <xsl:choose>
            <xsl:when test="contains($contentAfterRoot, '&lt;?oxy_options track_changes=&quot;on&quot;?&gt;')">
                <!-- It's already there -->
            </xsl:when>
            <xsl:when test="contains($contentAfterRoot, '&lt;?oxy_options track_changes=&quot;off&quot;?&gt;')">
                <!-- It's already there but off -->
                <xsl:value-of select="xrf:set-content-after-root(replace($contentAfterRoot, '&lt;\?oxy_options track_changes=&quot;off&quot;\?&gt;', '&lt;?oxy_options track_changes=&quot;on&quot;?&gt;'))"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Add the processing instruction -->
                <xsl:value-of select="xrf:set-content-after-root(concat($contentAfterRoot, '&lt;?oxy_options track_changes=&quot;on&quot;?&gt;'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>