<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns="http://www.w3.org/1999/xhtml" 
		xmlns:fsws="http://www.flameeyes.eu/fsws/2009"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exslt="http://exslt.org/common"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:str="http://exslt.org/strings"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		xmlns:sioc="http://rdfs.org/sioc/ns#"
		xmlns:dc="http://purl.org/dc/terms/"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

<xsl:template match="fsws:staticsite-secondpass//fsws:section/fsws:title">
</xsl:template>

<xsl:template name="fsws.section.title">
  <xsl:param name="content" />
  <h3 rel="dc:title">
    <xsl:value-of select="$content" />
  </h3>
</xsl:template>

<xsl:template match="fsws:staticsite-secondpass//fsws:section">
  <div class="post" rel="sioc:Post">
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id" />
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="fsws:title">
	<xsl:call-template name="fsws.section.title">
	  <xsl:with-param name="content" select="fsws:title" />
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@title">
	<xsl:call-template name="fsws.section.title">
	  <xsl:with-param name="content" select="@title" />
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="@date">
      <div class="post_date" ref="dc:created dc:date">
	<xsl:value-of select="@date" />
      </div>
    </xsl:if>

    <div class="post_body" property="sioc:content">
      <xsl:apply-templates select="./*" />
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
