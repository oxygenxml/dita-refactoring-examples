<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xr="http://www.oxygenxml.com/ns/xmlRefactoring"
    xmlns:oxy="http://www.oxygenxml.com/ns/extensions"
    xmlns:xrf="http://www.oxygenxml.com/ns/xmlRefactoring/functions"
    xmlns:r="http://www.oxygenxml.com/ns/xmlRefactoring/functions"
    exclude-result-prefixes="xs xr xrf r"
    version="2.0">
    
    <xsl:output method="xml"/>
    
    <xsl:function name="oxy:get-public-literal-target">
        <xsl:param name="root-element-name"/>
        <xsl:choose>
            <xsl:when test="$root-element-name = 'task'">
                <xsl:value-of select="'-//OASIS//DTD DITA My Task//EN'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'topic'">
                <xsl:value-of select="'-//OASIS//DTD DITA My Topic//EN'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'concept'">
                <xsl:value-of select="'-//OASIS//DTD DITA My Concept//EN'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'reference'">
                <xsl:value-of select="'-//OASIS//DTD DITA My Reference//EN'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="oxy:get-system-literal-target">
        <xsl:param name="root-element-name"/>
        <xsl:choose>
            <xsl:when test="$root-element-name = 'task'">
                <xsl:value-of select="'mytask.dtd'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'topic'">
                <xsl:value-of select="'mytopic.dtd'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'concept'">
                <xsl:value-of select="'myconcept.dtd'"/>
            </xsl:when>
            <xsl:when test="$root-element-name = 'reference'">
                <xsl:value-of select="'myreference.dtd'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:call-template name="convert-header"/>
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template name="convert-header">
        
        <xsl:variable name="header" as="xs:string" select="xrf:get-content-before-root()"/>
        
        <xsl:variable name="root-element-name" select="local-name(/*)"/>
        <xsl:choose>
            <!-- DOCTYPE -->
            <xsl:when test="contains($header, '!DOCTYPE')">
                <!-- Convert the DOCTYPE -->
                <xsl:variable name="converted-header">
                    <xsl:analyze-string select="$header" regex="{r:doctype-regex()}" flags="ims">
                        <xsl:matching-substring>
                            <xsl:variable name="doctype" select="." as="xs:string"/>
                            
                            <!-- Extract the internal subset within the DOCTYPE !-->
                            <xsl:variable name="internal-subset" as="xs:string">
                                <xsl:choose>
                                    <xsl:when test="contains($doctype, '[')">
                                        <xsl:analyze-string select="." regex="\[[^\]]*\]">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="concat(' ', .)"/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:value-of
                                select="concat('&lt;!DOCTYPE ', $root-element-name, ' PUBLIC &quot;', oxy:get-public-literal-target($root-element-name), '&quot; &quot;', oxy:get-system-literal-target($root-element-name), '&quot;', $internal-subset, '&gt;')"
                            />
                        </xsl:matching-substring>
                        
                        <!-- Copy everything else -->
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                
                <xsl:comment>
                    <xsl:value-of
                        select="xrf:set-content-before-root(string-join($converted-header))"/>
                </xsl:comment>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="converted-header">
                    <xsl:value-of
                        select="concat('&lt;!DOCTYPE ', $root-element-name, ' PUBLIC &quot;', oxy:get-public-literal-target($root-element-name), '&quot; &quot;', oxy:get-system-literal-target($root-element-name), '&quot;','&gt;')"
                    />
                </xsl:variable>
                <xsl:comment>
                    <xsl:value-of
                        select="xrf:set-content-before-root(string-join($converted-header))"/>
                </xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- One or more spaces. -->
    <xsl:variable name="S">
        <xsl:text>([ \t\r\n]+)</xsl:text>
    </xsl:variable>
    
    <!-- 
       Returns a regex expression that match the DOCTYPE declaration. 
   -->
    <xsl:function name="xrf:doctype-regex" as="xs:string">
        <!-- DOCTYPE regex -->
        <xsl:variable name="doctype-regex">
            <xsl:variable name="DOCTYPE" select="'!DOCTYPE'"/>
            
            <!-- '<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>' -->
            <!--<xsl:value-of select="concat('(', $S, xrf:external-id-regex(), ')')"/>-->
            <xsl:value-of
                select="concat('&lt;', $DOCTYPE, $S, xrf:name(), '(', $S, xrf:external-id(), ')?', $S, '?', '(\[[^\]]*\]', $S, '?)?', '&gt;')"
            />
            <!--<xsl:value-of select="'\[[^\]]*\]'"/>-->
            
        </xsl:variable>
        
        <xsl:value-of select="$doctype-regex"/>
    </xsl:function>
    
    <!-- 
       Returns a regex expression that match a Name declaration within DOCTYPE.
    -->
    <xsl:function name="xrf:name">
        <xsl:variable name="NameStartChar">
            <xsl:text>(:|[A-Za-z]|_|[&#x00C0;-&#x00D6;]|[&#x00D8;-&#x00F6;]|[&#x00F8;-&#x02FF;]|[&#x0370;-&#x037D;]|[&#x037F;-&#x1FFF;]|[&#x200C;-&#x200D;]|[&#x2070;-&#x218F;]|[&#x2C00;-&#x2FEF;]|[&#x3001;-&#xD7FF;]|[&#xF900;-&#xFDCF;]|[&#xFDF0;-&#xFFFD;])</xsl:text>
        </xsl:variable>
        
        <xsl:variable name="NameChar">
            <xsl:value-of
                select="concat($NameStartChar, '|-|\.|[0-9]|&#x00B7;|[&#x0300;-&#x036F;]|[&#x203F;-&#x2040;]')"
            />
        </xsl:variable>
        
        <xsl:value-of select="concat($NameStartChar, '(', $NameChar, ')*')"/>
    </xsl:function>
    
    <!-- 
       Returns a regex expression that match the external id within DOCTYPE.
    -->
    <xsl:function name="xrf:external-id">
        <xsl:variable name="SystemLiteral">
            <xsl:text>(("[^"]*")|('[^']*'))</xsl:text>
        </xsl:variable>
        
        <xsl:variable name="PubidLiteral">
            <xsl:variable name="PubIdCharSQ">
                <xsl:text>[&#x0020;\r\n]|[a-zA-Z0-9]|[\-\(\)+,\./:=\?;!\*#@$_%]</xsl:text>
            </xsl:variable>
            
            <xsl:variable name="sq">'</xsl:variable>
            <xsl:variable name="PubIdCharDQ">
                <xsl:value-of select="concat($PubIdCharSQ, '|', $sq)"/>
            </xsl:variable>
            <xsl:value-of
                select="concat('((&quot;(', $PubIdCharDQ, ')*&quot;)|(', $sq, '(', $PubIdCharSQ, ')*', $sq, '))')"
            />
        </xsl:variable>
        <xsl:value-of
            select="concat('((SYSTEM', $S, $SystemLiteral, ')|(', 'PUBLIC', $S, $PubidLiteral, $S, $SystemLiteral, '))')"
        />
    </xsl:function>
</xsl:stylesheet>