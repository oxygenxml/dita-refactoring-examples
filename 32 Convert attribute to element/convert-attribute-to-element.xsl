<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  xmlns:xr="http://www.oxygenxml.com/ns/xmlRefactoring"
  version="2.0">
  
  <xsl:import 
    href="http://www.oxygenxml.com/ns/xmlRefactoring/resources/commons.xsl"/>
  
  <xsl:param name="element_localName" as="xs:string" required="yes"/>
  <xsl:param name="element_namespace" as="xs:string" required="yes"/>
  <xsl:param name="attribute_localName" as="xs:string" required="yes"/>
  <xsl:param name="attribute_namespace" as="xs:string" required="yes"/>
  <xsl:param name="new_element_localName" as="xs:string" required="yes"/>
  <xsl:param name="new_element_namespace" as="xs:string" required="yes"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="//*[xr:check-local-name($element_localName, ., true())
    and
    xr:check-namespace-uri($element_namespace, .)]">
    
    <xsl:variable name="attributeToConvert" 
      select="@*[xr:check-local-name($attribute_localName, ., true())
      and
      xr:check-namespace-uri($attribute_namespace, .)]"/>
    
    <xsl:choose>
      <xsl:when test="empty($attributeToConvert)">
        <xsl:copy>
          <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:for-each select="@*[empty(. intersect $attributeToConvert)]">
            <xsl:copy-of select="."/>                        
          </xsl:for-each>
          <!-- The new element namespace -->
          <xsl:variable name="nsURI" as="xs:string">
            <xsl:choose>
              <xsl:when test="$new_element_namespace eq $xr:NO-NAMESPACE">
                <xsl:value-of select="''"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$new_element_namespace"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="{$new_element_localName}" namespace="{$nsURI}">
            <xsl:value-of select="$attributeToConvert"/>
          </xsl:element>
          <xsl:apply-templates select="node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>