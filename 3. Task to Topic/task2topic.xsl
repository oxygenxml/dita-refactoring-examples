<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="task">
        <topic>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </topic>
    </xsl:template>
    
    <xsl:template match="taskbody">
        <body>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="context">
        <!-- Unwrap -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="steps">
        <ol>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    
    <xsl:template match="step">
        <li>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="cmd">
        <p>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
</xsl:stylesheet>