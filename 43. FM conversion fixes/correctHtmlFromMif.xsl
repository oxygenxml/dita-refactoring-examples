<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs html"
    version="2.0">
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Set parent elements (ol or ul) on list items groups -->
    <xsl:template match="*[child::*[local-name() = 'li']]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:for-each-group select="./*" group-adjacent="boolean(self::*[local-name()= 'li'][@class = 'Step' or @class = 'Step1'])">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <xsl:element name="ol" namespace="http://www.w3.org/1999/xhtml">
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="handleBulletLists">
                            <xsl:with-param name="elementsSequence" select="current-group()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="handleBulletLists">
        <xsl:param name="elementsSequence"/>
        <xsl:choose>
            <xsl:when test="$elementsSequence[local-name() = 'li'][@class = 'Bullet']">
                <xsl:for-each-group select="$elementsSequence" group-adjacent="boolean(self::*[local-name()= 'li'][@class = 'Bullet'])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:element name="ul" namespace="http://www.w3.org/1999/xhtml">
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$elementsSequence"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Split the anchor element with @id and @name into two anchor elements -->
    <xsl:template match="*[local-name() = 'a'][@id and @name]">
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:copy-of select="@id"/>
        </xsl:element>
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="id" select="@name"/>
            <xsl:apply-templates select="@*[local-name() != 'id' and local-name() != 'name'] | node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>