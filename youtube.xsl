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
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template name="fsws.youtube.url">
    <xsl:param name="src" />
    <xsl:param name="fullscreen" />

    <xsl:text>http://www.youtube.com/v/</xsl:text>
    <xsl:value-of select="$src" />
    <xsl:if test="$fullscreen='yes'">
      <xsl:text>&amp;fs=1</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fsws.youtube.sizes">
    <xsl:param name="size" />
    <xsl:choose>
      <xsl:when test="$size = 'thumb'">
	<xsl:attribute name="width">42</xsl:attribute>
	<xsl:attribute name="height">34</xsl:attribute>
      </xsl:when>
      <xsl:when test="$size = 'wide'">
	<xsl:attribute name="width">560</xsl:attribute>
	<xsl:attribute name="height">340</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="width">425</xsl:attribute>
	<xsl:attribute name="height">344</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:youtube">
    <xsl:variable name="fullscreen">no</xsl:variable>
    <xsl:for-each select="str:tokenize(@options)/token">
      <xsl:choose>
	<xsl:when test=". = 'fullscreen'">
	  <xsl:variable name="fullscreen">yes</xsl:variable>
	</xsl:when>
      </xsl:choose>
    </xsl:for-each>

    <xsl:variable name="youtube_url">
      <xsl:call-template name="fsws.youtube.url">
	<xsl:with-param name="src" select="@src" />
	<xsl:with-param name="fullscreen" select="$fullscreen" />
      </xsl:call-template>
    </xsl:variable>

    <object>
      <xsl:call-template name="fsws.youtube.sizes">
	<xsl:with-param name="size" select="@size" />
      </xsl:call-template>
      
      <param name="movie">
	<xsl:attribute name="value"><xsl:value-of select="$youtube_url" /></xsl:attribute>
      </param>

      <xsl:if test="$fullscreen='yes'">
	<param name="allowFullScreen" value="true" />
      </xsl:if>
      <embed type="application/x-shockwave-flash">
	<xsl:attribute name="src"><xsl:value-of select="$youtube_url" /></xsl:attribute>
	<xsl:if test="$fullscreen='yes'">
	  <xsl:attribute name="allowfullscreen">true</xsl:attribute>
	</xsl:if>
	<xsl:call-template name="fsws.youtube.sizes">
	  <xsl:with-param name="size" select="@size" />
	</xsl:call-template>
      </embed>
    </object>

  </xsl:template>
</xsl:stylesheet>
