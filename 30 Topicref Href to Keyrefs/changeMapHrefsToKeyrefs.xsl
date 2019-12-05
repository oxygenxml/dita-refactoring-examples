<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs oxy"
    xmlns:oxy="http://www.oxygenxml.com/extensions"
    version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
            <xsl:result-document doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd" 
                href="{resolve-uri('keyDefinitions.ditamap', base-uri())}" indent="yes">
                <map>
                    <title>Key definitions</title>
                    <xsl:for-each select="//topicref[@href]">
                        <keydef>
                            <xsl:apply-templates select="@*[namespace-uri() = '']"/>
                            <xsl:attribute name="keys">
                                <xsl:value-of select="oxy:extractKeyName(@href)"/>
                            </xsl:attribute>
                        </keydef>
                    </xsl:for-each>
                </map>
            </xsl:result-document>
            <topicref href="keyDefinitions.ditamap" format="ditamap" processing-role="resource-only"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="topicref[@href]">
        <xsl:copy>
            <xsl:attribute name="keyref" select="oxy:extractKeyName(@href)"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="oxy:extractKeyName">
        <xsl:param name="reference"/>
        <xsl:variable name="lastPart">
            <xsl:value-of select="tokenize($reference, '/')[last()]"/>
        </xsl:variable>
        <xsl:value-of select="replace($lastPart, '\.(.*)', '')"/>
    </xsl:function>
</xsl:stylesheet>
