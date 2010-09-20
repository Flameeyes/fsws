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
		xmlns:og="http://opengraphprotocol.org/schema/"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template match='fsws:staticsite-secondpass//fsws:keywords'>
    <meta name="keywords" content="{normalize-space(.)}" />
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
    <meta name="ICBM" content="{@latitude}, {@longitude}" />
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
      <meta name="author" content="{//fsws:metadata/fsws:author}" />

      <xsl:if test="fsws:description">
	<meta name="description" content="{fsws:description}" />
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
            <xsl:when test="@og:type">
              <xsl:value-of select="@og:type" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>website</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </meta>

      <xsl:choose>
        <xsl:when test="@og:image">
          <meta property="og:image" content="{@image}" />
        </xsl:when>
        <xsl:when test="//fsws:metadata/fsws:logo">
          <meta property="og:image"
                content="{//fsws:metadata/fsws:logo}" />
        </xsl:when>
      </xsl:choose>

      <!-- Google's way to fetch the canonical URL
	   http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html
      -->
      <link rel="canonical" href="{$pageurl}" />

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
