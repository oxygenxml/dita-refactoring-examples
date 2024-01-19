<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
     <xsl:template match="node() | @*">
         <xsl:copy>
             <xsl:apply-templates select="node() | @*"/>
         </xsl:copy>
     </xsl:template>
    
    <xsl:template match="title[not(@id)]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="id" select="replace(lower-case(string-join(.//text())), ' ', '_')"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>