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
		xmlns:media="http://search.yahoo.com/searchmonkey/media/"
		xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:fb="http://www.facebook.com/2008/fbml"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default">

  <xsl:template match="dcterms:*|media:*">
    <span property="{name()}" content="{.}" />
  </xsl:template>

  <xsl:template match="fb:like">
    <iframe scrolling="no" class="fb_like {@layout}">
      <xsl:attribute name="class">
        <xsl:text>fb_like </xsl:text>
        <xsl:if test="@layout">
          <xsl:value-of select="@layout" />
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="@show_faces = 'false'">
          <xsl:text>no_faces </xsl:text>
        </xsl:if>
        <xsl:if test="@class">
          <xsl:value-of select="@class" />
        </xsl:if>
      </xsl:attribute>

      <xsl:attribute name="src">
        <xsl:text>http://www.facebook.com/plugins/like.php?</xsl:text>

        <xsl:for-each select="(@layout|@show_faces|@width|@action|@font|@colorscheme|@ref)">
          <xsl:value-of select="local-name()" />
          <xsl:text>=</xsl:text>
          <xsl:value-of select="." />
          <xsl:text>&amp;</xsl:text>
        </xsl:for-each>

        <xsl:text>href=</xsl:text>
        <xsl:choose>
          <xsl:when test="@href">
            <xsl:value-of select="@href" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="fsws.page.fullurl">
              <xsl:with-param name="page" select="ancestor::fsws:page" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </iframe>
  </xsl:template>
</xsl:stylesheet>
