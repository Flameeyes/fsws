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
		xmlns:flamesite="http://www.flameeyes.eu/flamesite"
		xmlns:xl="http://www.w3.org/1999/xlink"
		xmlns:media="http://search.yahoo.com/searchmonkey/media/"
		xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:fb="http://www.facebook.com/2008/fbml"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi fsws #default
					 flamesite xl">

  <xsl:template name="fsws.copy.language.2">
    <xsl:param name="language" />
    <xsl:param name="content" />

    <xsl:element name="{name($content)}">
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$language" />
      </xsl:attribute>

      <xsl:copy-of select="$content/@*" />

      <xsl:for-each select="$content/*|$content/text()">
	<xsl:call-template name="fsws.copy.language">
	  <xsl:with-param name="content" select="." />
	  <xsl:with-param name="language" select="$language" />
	</xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="fsws.copy.language">
    <xsl:param name="language" />
    <xsl:param name="content" />

    <xsl:choose>
      <xsl:when test="name($content)=''">
	<xsl:copy-of select="$content" />
      </xsl:when>
      <xsl:when test="$content/@xml:lang=$language">
	<xsl:copy-of select="$content" />
      </xsl:when>
      <!-- other cases it's present -->
      <xsl:when test="$content/@xml:lang">
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="fsws.copy.language.2">
	  <xsl:with-param name="content" select="$content" />
	  <xsl:with-param name="language" select="$language" />
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//fsws:staticsite-secondpass//@xml:lang">
  </xsl:template>
  
  <!-- The idea of this element is to wrap around the staticsite
       provided, and expand what needs to be expanded, like the error
       pages. -->
  <xsl:template match="fsws:staticsite">
    <xsl:variable name="sourcedata">
      <xsl:copy-of select="." />
    </xsl:variable>

    <xsl:variable name="partialdata">
      <xsl:for-each select="fsws:language">
	<fsws:multi-staticsite>
	  <xsl:call-template name="fsws.copy.language">
	    <xsl:with-param name="language" select="." />
	    <xsl:with-param name="content" select="exslt:node-set($sourcedata)/*" />
	  </xsl:call-template>
	</fsws:multi-staticsite>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="realdata">
      <xsl:for-each
	  select="exslt:node-set($partialdata)/fsws:multi-staticsite/*">
	
	<xsl:message>
	  <xsl:text>Second pass on </xsl:text>
	  <xsl:value-of select="name()" />
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="@xml:lang" />
	</xsl:message>

	<xsl:variable name="secondpass">
	  <fsws:staticsite-secondpass
	      languagecount="{count(exslt:node-set($sourcedata)//fsws:language)}">
	    <xsl:apply-templates />
	  </fsws:staticsite-secondpass>
	</xsl:variable>

	<xsl:for-each select="exslt:node-set($secondpass)//*/fsws:page">
	  <xsl:message>
	    <xsl:text>Found page:</xsl:text>
	    <xsl:value-of select="@xml:id" />
	    <xsl:text> (</xsl:text>
	    <xsl:value-of select="@xml:lang" />
	    <xsl:text>)</xsl:text>
	  </xsl:message>
	  <xsl:call-template name="fsws.perpage" />
	</xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="fsws.output.sitemap">
      <!-- If no output directory tries to write to / -->
      <xsl:value-of select="$fsws.output_directory" />
      <xsl:text>/sitemap.xml</xsl:text>
    </xsl:variable>

    <exslt:document href="{$fsws.output.sitemap}" encoding="UTF-8"
		    method="xml" indent="yes" standalone="yes">
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<xsl:for-each select="//*/fsws:page[not(@follow='false')]">
	  <xsl:variable name="fsws.fullurl">
	    <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
	    <xsl:call-template name="fsws.page.url">
	      <xsl:with-param name="page" select="." />
	    </xsl:call-template>
	  </xsl:variable>

	  <url>
	    <loc>
	      <xsl:value-of
		  select="str:replace(str:replace($fsws.fullurl, '//',
			  '/'), 'http:/', 'http://')"
			    />
	    </loc>
	    <lastmod><xsl:value-of select="date:date()" /></lastmod>
	  </url>
	</xsl:for-each>
      </urlset>
    </exslt:document>
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
