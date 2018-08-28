<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
   <xsl:output indent="yes"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="table[tgroup[@cols='2']]">
        <dl>
            <xsl:for-each select="tgroup/thead/row | tgroup/tbody/row">
                <dt>
                    <xsl:copy-of select="entry[1]/node()"/>
                </dt>
                <dd>
                    <xsl:copy-of select="entry[2]/node()"/>
                </dd>
            </xsl:for-each>
        </dl>
    </xsl:template>
</xsl:stylesheet>