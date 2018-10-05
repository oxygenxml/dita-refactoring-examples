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
    
    <xsl:template match="topichead">
        <xsl:variable name="newFileName" select="concat(replace(@navtitle, ' ', '%20'), '.dita')"/>
        <xsl:element name="topicref">
            <xsl:apply-templates select="@* except @navtitle"/>
            <xsl:attribute name="href" select="$newFileName"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
        <xsl:result-document href="{$newFileName}" doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd">
            <topic id="introduction">
                <title><xsl:value-of select="@navtitle"/></title>
            </topic>                
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>