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

  <xsl:template match="fsws:flickr_gallery">
    <fsws:page>
      <xsl:variable name="prefixid">
	<xsl:choose>
	  <xsl:when test="@prefixid">
	    <xsl:value-of select="@prefixid" />
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>flickr-gallery-</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="@xml:lang" />
      </xsl:attribute>
      
      <xsl:attribute name="xml:id">
	<xsl:value-of select="$prefixid" />
	<xsl:value-of select="@set" />
      </xsl:attribute>
     
      <xsl:variable name="setinfo_rtf">
	<xsl:call-template name="fsws.flickr.set.info">
	<xsl:with-param name="set" select="@set" />
	</xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="setinfo" select="exslt:node-set($info_rtf)/*" />
      
      <fsws:title>
	<xsl:value-of select="$info/title" />
      </fsws:title>
      
    </fsws:page>
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
