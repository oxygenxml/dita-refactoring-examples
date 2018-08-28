<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs xra"
    version="2.0" xmlns:xra="http://www.oxygenxml.com/ns/xmlRefactoring/additional_attributes">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[@outputclass = 'extract']">
        <xsl:result-document href="extracted.ditamap" doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd">
            <map>
                <title></title>
                <xsl:apply-templates select="." mode="copy"/>
            </map>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@xra:*" mode="copy"/>
    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>