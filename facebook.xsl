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
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws og #default">

  <xsl:template match="fsws:staticsite-secondpass//fb:comments">
    <fb:comments>
      <xsl:copy-of select="@width" />
      <xsl:copy-of select="@num_posts" />
      <xsl:choose>
	<xsl:when test="@href">
	  <xsl:copy-of select="@href" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="href">
	    <xsl:call-template name="fsws.page.fullurl">
              <xsl:with-param name="page" select="ancestor::fsws:page[last()]" />
	    </xsl:call-template>
	  </xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
    </fb:comments>
  </xsl:template>
</xsl:stylesheet>
