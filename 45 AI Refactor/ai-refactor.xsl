<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs ai"
    version="2.0" xmlns:ai="http://www.oxygenxml.com/ai/function">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="shortdesc[count(tokenize(.,'\s+')) > 10]">
        <shortdesc>
            <xsl:value-of select="ai:transform-content('Reformulate phrase to be less that 10 words', .)"/>
        </shortdesc>
    </xsl:template>
</xsl:stylesheet>