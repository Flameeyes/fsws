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

  <!-- The idea of this element is to wrap around the staticsite
       provided, and expand what needs to be expanded, like the error
       pages. -->
  <xsl:template match="fsws:robots">
    <xsl:variable name="fsws.output.robots">
      <!-- If no output directory tries to write to / -->
      <xsl:value-of select="$fsws.output_directory" />
      <xsl:text>/robots.txt</xsl:text>
    </xsl:variable>

    <exslt:document href="{$fsws.output.robots}" encoding="UTF-8"
		    method="text" indent="no">
      <xsl:text>Sitemap: </xsl:text>
      <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
      <xsl:text>sitemap.xml</xsl:text>

      <xsl:text>&#10;&#10;</xsl:text>

      <xsl:text>User-agent: *&#10;</xsl:text>
      <xsl:apply-templates />
    </exslt:document>
  </xsl:template>

  <xsl:template match="fsws:disallow">
    <xsl:text>Disallow: </xsl:text>
    <xsl:value-of select="." />
    <xsl:text>&#10;</xsl:text>
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
