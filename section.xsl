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

<xsl:template match="fsws:staticsite-secondpass//fsws:section/fsws:title">
</xsl:template>

<xsl:template match="fsws:staticsite-secondpass//fsws:section">
  <div class="post_title">
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id" />
      </xsl:attribute>
    </xsl:if>

    <h3><xsl:value-of select="fsws:title" /></h3>
  </div>

  <xsl:if test="@date">
    <div class="post_date">
      <xsl:value-of select="@date" />
    </div>
  </xsl:if>

  <div class="post_body">
    <xsl:apply-templates select="./*" />
  </div>
</xsl:template>

</xsl:stylesheet>
