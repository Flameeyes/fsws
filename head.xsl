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

  <xsl:template match='fsws:staticsite-secondpass//fsws:keywords'>
    <meta name="keywords">
      <xsl:attribute name="content">
	<xsl:value-of select="normalize-space(.)" />
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template
      match="fsws:staticsite-secondpass//fsws:stylesheet[@href]">
    <link rel="stylesheet" type="text/css">
      <xsl:copy-of select="@href" />
      <xsl:copy-of select="@media" />
    </link>
  </xsl:template>

  <xsl:template
      match="fsws:staticsite-secondpass//fsws:stylesheet[not(@href)]">
    <exslt:document href="{$fsws.output_directory}/styles/{@xml:id}.css"
		    method="text" indent="no">
      <xsl:value-of select="." />
    </exslt:document>

    <xsl:variable name="baseurl" select="//fsws:metadata/fsws:baseurl" />

    <link rel="stylesheet" type="text/css"
	  href="{$baseurl}/styles/{@xml:id}.css">
      <xsl:copy-of select="@media" />
    </link>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:geolocation">
    <meta name="ICBM">
      <xsl:attribute name="content">
	<xsl:value-of select="@latitude" />
	<xsl:text>, </xsl:text>
	<xsl:value-of select="@longitude" />
      </xsl:attribute>
    </meta>

    <meta property="og:latitude" content="{@latitude}" />
    <meta property="og:longitude" content="{@longitude}" />
  </xsl:template>

  <xsl:template name="fsws.head">
    <xsl:param name="stylesheet.screen" />

    <xsl:variable name="pageurl_raw">
      <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
      <xsl:call-template name="fsws.page.url">
        <xsl:with-param name="page" select="." />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="pageurl">
      <xsl:value-of
          select="str:replace(str:replace($pageurl_raw, '//',
                  '/'), 'http:/', 'http://')"
          />
    </xsl:variable>

    <head>
      <meta http-equiv="content-type" content="text/HTML; charset=UTF-8"/>
      <meta name="author">
	<xsl:attribute name="content">
	  <xsl:value-of select="//fsws:metadata/fsws:author" />
	</xsl:attribute>
      </meta>

      <xsl:if test="fsws:description">
	<meta name="description">
	  <xsl:attribute name="content">
	    <xsl:value-of select="fsws:description" />
	  </xsl:attribute>
	</meta>
      </xsl:if>

      <meta name="generator"
	    content="Flameeyes's Static Website Generator" />

      <xsl:apply-templates
	  select="//fsws:metadata/fsws:keywords|
		  //fsws:metadata/fsws:stylesheet|
		  //fsws:metadata/fsws:geolocation|
                  //fsws:metadata/fsws:head-extras/*" />

      <meta property="og:site_name"
            content="{//fsws:metadata/fsws:title}" />
      <meta property="og:title" content="{.//fsws:title}" />
      <meta property="og:url" content="{$pageurl}" />

      <meta property="og:type">
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="@type">
              <xsl:value-of select="@type" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>website</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </meta>

      <xsl:choose>
        <xsl:when test="@image">
          <meta property="og:image" content="{@image}" />
        </xsl:when>
        <xsl:when test="//fsws:metadata/fsws:logo">
          <meta property="og:image"
                content="{//fsws:metadata/fsws:logo}" />
        </xsl:when>
      </xsl:choose>

      <title>
	<xsl:value-of select="//fsws:metadata/fsws:title" />
	<xsl:text> — </xsl:text>
	<xsl:value-of select=".//fsws:title" />
      </title>
    </head>
  </xsl:template>
</xsl:stylesheet>
<!--
   Local Variables:
   mode: nxml
   mode: auto-fill
   mode: flyspell
   ispell-local-dictionary: "english"
   End:
-->
