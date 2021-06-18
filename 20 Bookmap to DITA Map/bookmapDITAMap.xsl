<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="bookmap">
        <xsl:element name="map">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mainbooktitle">
        <xsl:element name="title">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="booktitle">
        <!-- hide the element, but keep the children -->
        <xsl:apply-templates select="@* | *"/>
    </xsl:template>
    
    <xsl:template match="bookmeta">
        <xsl:element name="topicmeta">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="bookrights">
        <xsl:element name="copyright">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="bookowner">
        <xsl:element name="copyrholder">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="chapter | appendix |preface | frontmatter | notices | bookabstract">
        <xsl:element name="topicref">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>