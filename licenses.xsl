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
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template match="fsws:staticsite-secondpass//fsws:license">
    <xsl:variable name="licensename">
      <xsl:choose>
	<xsl:when test="@cc = 'by-sa'">
	  <xsl:text>Creative Commons Attribution-ShareAlike </xsl:text>
	  <xsl:value-of select="@ver" />
	</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="@title">
	  <xsl:value-of select="@title" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="../..//fsws:title" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="authorname">
      <xsl:choose>
	<xsl:when test="@authorname">
	  <xsl:value-of select="@authorname" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="//fsws:metadata/fsws:author" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="authorurl">
      <xsl:choose>
	<xsl:when test="@authorurl">
	  <xsl:value-of select="@authorurl" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="workurl">
      <xsl:choose>
	<xsl:when test="@workurl">
	  <xsl:value-of select="@workurl" />
	</xsl:when>
	<xsl:otherwise>
          <xsl:call-template name="fsws.page.url">
            <xsl:with-param name="page" select="." />
          </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="workname">
      <xsl:choose>
	<xsl:when test="@workname">
	  <xsl:value-of select="@workname" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="//fsws:metadata/fsws:title" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div>
      <a rel="cc:license" href="http://creativecommons.org/licenses/{@cc}/{@ver}/">
	<img alt="{$licensename}" src="http://i.creativecommons.org/l/{@cc}/{@ver}/88x31.png" />
      </a>
      <span href="http://purl.org/dc/dcmitype/Text" property="dc:title" rel="dc:type">
	<xsl:value-of select="$title" />
      </span>
      
      <xsl:text> by </xsl:text>

      <a property="cc:attributionName" href="{$authorurl}">
	<xsl:value-of select="$authorname" />
      </a>

      <xsl:text> is licensed under a </xsl:text>

      <a rel="cc:license" href="http://creativecommons.org/licenses/{@cc}/{@ver}/">
	<xsl:value-of select="$licensename" />
	<xsl:text> Unported License</xsl:text>
      </a>

      <xsl:text>.</xsl:text>

      <br />

      <xsl:text>Based on a work at </xsl:text>

      <a rel="dc:source" href="{$workurl}">
	<xsl:value-of select="$workname" />
      </a>

      <xsl:text>.</xsl:text>
    </div>
  </xsl:template>
</xsl:stylesheet>
