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
    
    <xsl:template match="tbody">
        <xsl:choose>
            <xsl:when test="preceding-sibling::thead or count(child::row) = 0">
                <!-- Already has a header row or it has no child rows -->
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <thead>
                    <xsl:copy-of select="child::row[1]"/>
                </thead>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="node()[not(self::row) or preceding-sibling::row]"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>