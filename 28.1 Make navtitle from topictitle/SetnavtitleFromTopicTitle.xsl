<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">

	<xsl:output indent="yes" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		<xd:desc>Get the topic title and add it as a <navtitle/> element (nested in <topicmeta/>) to the <topicref/> element.</xd:desc>
	</xd:doc>

	<xsl:template match="topicref[@href]">
		<xsl:copy>
			<xsl:apply-templates select="@* except @navtitle"/>
			<xsl:if test="count(topicmeta) = 0">
				<topicmeta>
					<navtitle>
						<xsl:message>test</xsl:message>
						<xsl:value-of select="document(@href)/topic[@audience]"/>
					</navtitle>
				</topicmeta>
			</xsl:if>
			<xsl:apply-templates select="*"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		<xd:desc>Get the topic title and add it as a <navtitle/> element (nested in <topicmeta/>) to the <chapter/> element.</xd:desc>
	</xd:doc>

	<xsl:template match="chapter[@href]">
		<xsl:copy>
			<xsl:apply-templates select="@* except @navtitle"/>
			<xsl:if test="count(topicmeta) = 0">
				<topicmeta>
					<navtitle>
						<xsl:message>test</xsl:message>
						<xsl:value-of select="document(@href)/topic[@audience]"/>
					</navtitle>
				</topicmeta>
			</xsl:if>
			<xsl:apply-templates select="*"/>
		</xsl:copy>
	</xsl:template>


	<xd:doc>
		<xd:desc>Update the existing <navtitle/> element on topicref.</xd:desc>
	</xd:doc>

	<xsl:template match="topicmeta[parent::*[1][self::topicref]]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="* except navtitle"/>

			<navtitle>
				<xsl:message>test</xsl:message>
				<xsl:value-of select="parent::topicref/document(@href)/*/@audience"/>
			</navtitle>

		</xsl:copy>
	</xsl:template>

	<xd:doc>
		<xd:desc>Update the existing <navtitle/> element on chapter.</xd:desc>
	</xd:doc>

	<xsl:template match="topicmeta[parent::*[1][self::chapter]]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="* except navtitle"/>
			
			<navtitle>
				<xsl:message>test</xsl:message>
				<xsl:value-of select="parent::chapter/document(@href)/topic[@audience]"/>
			</navtitle>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
