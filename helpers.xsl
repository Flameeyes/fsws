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
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template name="fsws.copyright_string">
    <span property="dc:rights">
      <xsl:variable name="current_year" select="date:year()" />
      © <xsl:value-of select="//fsws:metadata/fsws:copyright/@start" /><xsl:text> </xsl:text>
      <xsl:if test="//fsws:metadata/fsws:copyright/@start != $current_year">
	<xsl:text>- </xsl:text>
	<xsl:value-of select="$current_year" />
	<xsl:text> </xsl:text>
      </xsl:if>
      <xsl:value-of select="//fsws:metadata/fsws:copyright" />
    </span>
  </xsl:template>

  <xsl:template match="@xml:base"/>

  <xsl:template match="//fsws:staticsite-secondpass/fsws:title"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="fsws.page.url">
    <xsl:param name="page" />

    <xsl:variable name="linkid">
      <xsl:choose>
	<xsl:when test="local-name($page) = 'page'">
	  <xsl:value-of select="$page/@xml:id" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$page" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="/@languagecount > 1">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="//@xml:lang" />
    </xsl:if>
    <xsl:text>/</xsl:text>
    <xsl:value-of
	select="str:replace(str:replace($linkid, '.', '/'), '/index', '/')" />
  </xsl:template>

  <xsl:template name="fsws.page.fullurl">
    <xsl:param name="page" />

    <xsl:variable name="pageurl_raw">
      <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
      <xsl:call-template name="fsws.page.url">
        <xsl:with-param name="page" select="$page" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of
        select="str:replace(str:replace($pageurl_raw, '//',
                '/'), ':/', '://')"
        />
  </xsl:template>

  <xsl:template match="fsws:linkto">
    <xsl:call-template name="fsws.linkto">
      <xsl:with-param name="page" select="@linkend" />
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="fsws.linkto">
    <xsl:param name="page" />
    <xsl:param name="text" />

    <xsl:variable name="linktitle">
      <xsl:choose>
	<xsl:when test="local-name($page) = 'page'">
	  <xsl:value-of select="$page//fsws:title" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of
	      select="//fsws:page[@xml:id = $page]//fsws:title" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="linktext">
      <xsl:choose>
	<xsl:when test="$text != ''">
	  <xsl:value-of select="$text" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$linktitle" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a href="{$linktitle}">
      <xsl:attribute name="href">
	<xsl:call-template name="fsws.page.url">
	  <xsl:with-param name="page" select="$page" />
	</xsl:call-template>
      </xsl:attribute>
      <xsl:value-of select="$linktext" />
    </a>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:flickr_photo">
    <xsl:call-template name="fsws.flickr.photo.img">
      <xsl:with-param name="photo">
	<!-- We can't use select="" otherwise we get a node-set, which
	     then will be intended like a photo object. -->
	<xsl:value-of select="@id" />
      </xsl:with-param>
      <xsl:with-param name="secret" select="@secret" />
      <xsl:with-param name="size" select="@size" />
      <xsl:with-param name="set" select="@set" />
      <xsl:with-param name="customsize" select="@customsize" />
      <xsl:with-param name="a_class" select="@a_class" />
      <xsl:with-param name="img_class" select="@img_class" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:flickr_set_link">
    <xsl:call-template name="fsws.flickr.set.imagelink">
      <xsl:with-param name="set" select="@id" />
      <xsl:with-param name="a_class">thumb</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:phone">
    <a href="tel:{str:replace(@number, ' ', '')}">
      <xsl:copy-of select="@class" />
      <xsl:choose>
	<xsl:when test="./*">
	  <xsl:apply-templates />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@number" />
	</xsl:otherwise>
      </xsl:choose>
    </a>
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
