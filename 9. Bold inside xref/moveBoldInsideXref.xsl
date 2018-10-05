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
    
    <!-- Match a bold which contains precisely one xref inside -->
    <xsl:template match="b[xref and count(*) = 1]">
        <xsl:apply-templates select="node()[not(local-name() = 'xref')]"/>
        <xref>
            <xsl:apply-templates select="xref/@*"/>
            <b>
                <xsl:apply-templates select="xref/node()"/>
            </b>
        </xref>
    </xsl:template>
    
</xsl:stylesheet>