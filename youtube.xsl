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
                xmlns:fb="http://www.facebook.com/2008/fbml"
		xmlns:media="http://search.yahoo.com/searchmonkey/media/"
		xmlns:dcterms="http://purl.org/dc/terms/"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template name="fsws.youtube.url">
    <xsl:param name="src" />
    <xsl:param name="fullscreen" />

    <xsl:text>http://www.youtube.com/embed/</xsl:text>
    <xsl:value-of select="$src" />
    <xsl:text>?origin=</xsl:text>
    <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
    <xsl:if test="$fullscreen='true'">
      <xsl:text>&amp;fs=1</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fsws.youtube.sizes">
    <xsl:param name="size" />
    <xsl:choose>
      <xsl:when test="$size = 'thumb'">
	<media:width>24</media:width>
	<media:height>34</media:height>
      </xsl:when>
      <xsl:when test="$size = 'wide'">
	<media:width>560</media:width>
	<media:height>340</media:height>
      </xsl:when>
      <xsl:otherwise>
	<media:width>425</media:width>
	<media:height>344</media:height>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:youtube">
    <xsl:variable name="fullscreen">true</xsl:variable>
    <xsl:for-each select="str:tokenize(@options)/token">
      <xsl:choose>
	<xsl:when test=". = 'nofullscreen'">
	  <xsl:variable name="fullscreen">false</xsl:variable>
	</xsl:when>
      </xsl:choose>
    </xsl:for-each>

    <xsl:variable name="youtube_url">
      <xsl:call-template name="fsws.youtube.url">
	<xsl:with-param name="src" select="@src" />
	<xsl:with-param name="fullscreen" select="$fullscreen" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="sizes_">
      <xsl:call-template name="fsws.youtube.sizes">
	<xsl:with-param name="size" select="@size" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sizes" select="exslt:node-set($sizes_)" />

    <iframe class="youtube-player" type="text/html"
	    frameborder="0" rel="media:video"
	    width="{$sizes/media:width}"
	    height="{$sizes/media:height}"
	    src="{$youtube_url}" />
  </xsl:template>

  <xsl:template match="fsws:staticsite//fsws:youtube-page">
    <xsl:variable name="sizes_">
      <xsl:call-template name="fsws.youtube.sizes">
	<xsl:with-param name="size" select="@size" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sizes" select="exslt:node-set($sizes_)" />

    <fsws:page>
      <xsl:copy-of select="@xml:id|@og:image|@fb:admins|@og:title" />

      <xsl:choose>
        <xsl:when test="@og:image">
          <xsl:copy-of select="@og:image" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="og:image">
            <xsl:text>http://i1.ytimg.com/vi/</xsl:text>
            <xsl:value-of select="@src" />
            <xsl:text>/default.jpg</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="@og:video">
          <xsl:copy-of select="@og:video" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="og:video">
            <xsl:text>http://www.youtube.com/e/</xsl:text>
            <xsl:value-of select="@src" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="@og:type">
          <xsl:copy-of select="@og:type" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="og:type">video</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <fsws:property name="og:video:type">application/x-shockwave-flash</fsws:property>

      <fsws:property name="og:video:width">
        <xsl:value-of select="$sizes/media:width" />
      </fsws:property>
      <fsws:property name="og:video:height">
        <xsl:value-of select="$sizes/media:height" />
      </fsws:property>

      <fsws:title>
	<xsl:value-of select="@title" />
      </fsws:title>

      <fsws:section>
	<div class="centering">
	  <fsws:youtube>
	    <xsl:copy-of select="@src" />
	    <xsl:copy-of select="@size" />
	    <xsl:copy-of select="@options" />
	    <xsl:copy-of select="./*" />
	  </fsws:youtube>
	</div>
      </fsws:section>

      <xsl:call-template name="fsws.template.youtube.footer" />
    </fsws:page>
  </xsl:template>
</xsl:stylesheet>
