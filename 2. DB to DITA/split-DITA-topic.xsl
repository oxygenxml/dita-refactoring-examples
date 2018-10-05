<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    exclude-result-prefixes="#all"
    xmlns:oxy="http://www.oxygenxml.com/ns"
    version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/dita/topic">
        <!-- Split subtopics of large topic to new topic files. -->
        <topic>
            <xsl:apply-templates select="@* | node()" mode="split"/>
        </topic>
        
        <!-- Build DITA map with all topics. -->
        <xsl:variable name="mapFileName" 
            select="concat('DITAMAP-', substring-before(tokenize(document-uri(/), '/')[last()], '.'), '.ditamap')"/>
        <xsl:message>DITAMAP file: <xsl:value-of select="normalize-space($mapFileName)"/></xsl:message>
        <xsl:result-document href="{normalize-space($mapFileName)}" indent="yes"
            doctype-public="-//OASIS//DTD DITA Map//EN"
            doctype-system="map.dtd">
            <map>
                <title><xsl:value-of select="title"/></title>
                <xsl:apply-templates select="*" mode="map"/>
            </map>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="@* | node()" mode="split">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="split"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@platform" mode="split">
        <xsl:attribute name="platform" select="string-join(tokenize(., ';'), ' ')"/>
    </xsl:template>
    
  <!-- EXM-16853 -->
    <xsl:template match="link" mode="split">
        <xsl:apply-templates select="*"/>
    </xsl:template>
  
  <xsl:template match="@ditaarch:DITAArchVersion | 
                                     @domains | 
                                     @class | 
                                     @outputclass"
                                     mode="split map"/>

    <xsl:template match="xref | link" mode="split">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="split"/>
            <!-- Now fix up the @href -->
            <xsl:if test="starts-with(@href, '#')">
                <xsl:variable name="hrefValue" select="@href"/>
                <xsl:variable name="targetElement" select="(//*[@id = substring-after($hrefValue, '#')])[1]"/>
                <xsl:if test="$targetElement">
                    <xsl:variable name="closestTargetTopic" select="$targetElement/(ancestor-or-self::*[local-name() = ('topic', 'task', 'concept', 'reference')])[last()]"/>
                    <xsl:if test="$closestTargetTopic">
                        <xsl:choose>
                            <xsl:when test="$closestTargetTopic = $targetElement">
                                <xsl:attribute name="href" select="oxy:getTopicFileName($closestTargetTopic)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="href" select="concat(oxy:getTopicFileName($closestTargetTopic), '#', normalize-space($closestTargetTopic/@id)), '/', normalize-space($targetElement/@id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:if test="starts-with(@href, 'http')">
                <xsl:attribute name="scope" select="'external'"/>
                <xsl:attribute name="format" select="'html'"/>
            </xsl:if>
            <xsl:apply-templates select="* | text()" mode="split"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="oxy:getTopicFileName">
        <xsl:param name="topicElement"/>
        <xsl:variable name="fileName">
            <xsl:choose>
                <xsl:when test="$topicElement/@id">
                    <xsl:value-of select="$topicElement/@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate($topicElement/title, ' ', '_')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fileNameWithExt" select="normalize-space(concat($fileName, '.xml'))"/>
        <xsl:value-of select="$fileNameWithExt"/>
    </xsl:function>
    

    <xsl:template match="topic|task|concept|reference" mode="split">
        
        <xsl:variable name="fileName" select="oxy:getTopicFileName(.)"/>
        <xsl:message>TOPIC file: <xsl:value-of select="normalize-space($fileName)"/></xsl:message>
        
        
        <xsl:variable name="topicName">
            <xsl:choose>
                <xsl:when test="local-name() = 'task'">Task</xsl:when>
                <xsl:when test="local-name() = 'Concept'">Concept</xsl:when>
                <xsl:when test="local-name() = 'Reference'">Reference</xsl:when>
                <xsl:otherwise>Topic</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:result-document href="{$fileName}" 
            doctype-public="-//OASIS//DTD DITA {$topicName}//EN" 
            doctype-system="{lower-case($topicName)}.dtd" indent="yes" exclude-result-prefixes="#all">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()" mode="split"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="node()" mode="map">
        <xsl:apply-templates select="node()" mode="map"/>
    </xsl:template>
    
    
    <xsl:template match="topic|task|concept|reference" mode="map">
        <topicref href="{@id}.xml">
            <xsl:if test="@platform">
                <xsl:attribute name="platform" select="string-join(tokenize(@platform, ';'), ' ')"/>
            </xsl:if>
            <xsl:apply-templates select="* | text()" mode="map"/>
        </topicref>
    </xsl:template>
</xsl:stylesheet>
