<?xml version="1.0" encoding="utf-8"?>
<!--
Copyright 2009-2017 Diego Elio Pettenò

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
-->
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
                xmlns:fb="http://www.facebook.com/2008/fbml"
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

  <xsl:template match="fsws:staticsite-secondpass//fsws:property">
    <meta property="{@name}">
      <xsl:attribute name="content">
        <xsl:value-of select="." />
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template name="fsws.head">
    <xsl:param name="stylesheet.screen" />

    <xsl:variable name="pageurl">
      <xsl:call-template name="fsws.page.fullurl">
        <xsl:with-param name="page" select="." />
      </xsl:call-template>
    </xsl:variable>

    <head>
      <meta http-equiv="content-type" content="text/HTML; charset=UTF-8"/>
      <meta name="author" content="{//fsws:metadata/fsws:author}" />

      <xsl:if test="fsws:description">
	<meta name="description" content="{fsws:description}" />
      </xsl:if>

      <meta name="generator"
	    content="Flameeyes's Static Website Generator" />

      <!-- ensure that stylesheets are placed before extras, as extras
           might contain scripts, which should be loaded after styles
           for best performances -->
      <xsl:apply-templates select="//fsws:metadata/fsws:stylesheet" />

      <xsl:apply-templates
	  select="//fsws:metadata/fsws:keywords|
		  //fsws:metadata/fsws:geolocation|
                  //fsws:metadata/fsws:head-extras/*" />

      <meta property="og:site_name"
            content="{//fsws:metadata/fsws:title}" />
      <meta property="og:url" content="{$pageurl}" />

      <meta property="og:title">
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="@og:title">
              <xsl:value-of select="@og:title" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select=".//fsws:title" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </meta>

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
          <meta property="og:image" content="{@og:image}" />
        </xsl:when>
        <xsl:when test="//fsws:metadata/fsws:logo">
          <meta property="og:image"
                content="{//fsws:metadata/fsws:logo}" />
        </xsl:when>
      </xsl:choose>

      <xsl:if test="@og:video">
        <meta property="og:video" content="{@og:video}" />
      </xsl:if>

      <xsl:variable name="fb-admins">
        <xsl:if test="@fb:admins">
          <xsl:value-of select="@fb:admins" />
          <xsl:if test="//fsws:metadata/fb:admins">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:value-of select="//fsws:metadata/fb:admins" />
      </xsl:variable>

      <xsl:if test="$fb-admins">
        <meta property="fb:admins" content="{$fb-admins}" />
      </xsl:if>

      <xsl:choose>
        <xsl:when test="@fb:app_id">
          <meta property="fb:app_id" content="{@fb:app_id}" />
        </xsl:when>
        <xsl:when test="//fsws:metadata/fb:app_id">
          <meta property="fb:app_id"
                content="{//fsws:metadata/fb:app_id}" />
        </xsl:when>
      </xsl:choose>

      <xsl:apply-templates select="fsws:property" />

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
