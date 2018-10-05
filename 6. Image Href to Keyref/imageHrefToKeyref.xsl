<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://www.oxygenxml.com/ns/functions">
    <xsl:function name="f:getKeyref" as="xs:string">
        <xsl:param name="element" as="element()"/>
        <xsl:variable name="imageFile" select="tokenize(translate($element/@href, '\', '/'), '/')[last()]"/>
        <xsl:variable name="key" select="substring-before($imageFile, '.')"/>
        <xsl:value-of select="$key"/>
    </xsl:function>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="image[@href and not(@keyref)]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @href"/>
            <xsl:attribute name="keyref" select="f:getKeyref(.)"></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet> 