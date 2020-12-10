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
    
    <!-- Ignores the delete, insert and comment PIs which are done -->
    <xsl:template match="processing-instruction()[starts-with(name(), 'oxy_')][contains(., ' flag=&quot;done&quot;')]">
        <!-- Ignore PI -->
    </xsl:template>
    
    <!-- Also remove end of comment PIs which are done -->
    <xsl:template match="processing-instruction()[name() = 'oxy_comment_end']">
        <xsl:variable name="startPI" select="(preceding::processing-instruction()[name() = 'oxy_comment_start'])[last()]"/>
        <xsl:message>MATCH <xsl:value-of select="$startPI"/></xsl:message>
        <xsl:choose>
            <xsl:when test="contains($startPI, ' flag=&quot;done&quot;')">
                <!-- Ignore PI -->
            </xsl:when>
            <xsl:otherwise>
                <!-- Pass it through -->
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- Also remove end of insert PI which is done. -->
    <xsl:template match="processing-instruction()[name() = 'oxy_insert_end']">
        <xsl:variable name="startPI" select="(preceding::processing-instruction()[name() = 'oxy_insert_start'])[last()]"/>
        <xsl:choose>
            <xsl:when test="contains($startPI, ' flag=&quot;done&quot;')">
                <!-- Ignore PI -->
            </xsl:when>
            <xsl:otherwise>
                <!-- Pass it through -->
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>