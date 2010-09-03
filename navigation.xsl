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
		xmlns:xl="http://www.w3.org/1999/xlink"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi xl fsws #default">
  <xsl:template name="fsws.navigation.categories">
    <xsl:variable name="mycategory">
      <xsl:choose>
	<!-- if we're a subpage -->
	<xsl:when test="../../../fsws:subpages">
	  <xsl:value-of select="../../../../@xml:id" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="../@xml:id" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <ul>
      <xsl:for-each select="//fsws:category">
	<li>
	  <xsl:if test="(@xml:id = $mycategory)">
	    <xsl:attribute name="class">current_page_item</xsl:attribute>
	  </xsl:if>

	  <xsl:choose>
	    <!-- We allow “external categories”, i.e.: use the
	         categories definition, but create an external link
	         instead -->
	    <xsl:when test="@xl:href">
	      <a href="{@xl:href}" title="{@xl:title}">
		<xsl:choose>
		  <xsl:when test="@text">
		    <xsl:value-of select="@text" />
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="@xl:title" />
		  </xsl:otherwise>
		</xsl:choose>
	      </a>
	    </xsl:when>
	    
	    <!-- Normal category with pages -->
	    <xsl:otherwise>
	      <xsl:call-template name="fsws.linkto">
		<xsl:with-param name="page"
				select="./fsws:page[1]" />
		<xsl:with-param name="text"
				select="@name" />
	      </xsl:call-template>
	    </xsl:otherwise>
	  </xsl:choose>

	</li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="fsws.navigation.pages">
    <xsl:param name="category">
      <xsl:choose>
	<!-- if we're a subpage -->
	<xsl:when test="../../../fsws:subpages">
	  <xsl:value-of select="../../../../@xml:id" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="../@xml:id" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:variable name="myid">
      <xsl:value-of select="@xml:id" />
    </xsl:variable>

    <ul>
      <xsl:for-each
	  select="//fsws:category[@xml:id = $category]/fsws:page[not(@hidden) or @hidden != true]">
	<li>
	  <xsl:if test="(@xml:id = $myid)">
	    <xsl:attribute name="class">current_page_item</xsl:attribute>
	  </xsl:if>
	  <xsl:call-template name="fsws.linkto">
	    <xsl:with-param name="page"
			    select="." />
	  </xsl:call-template>
	</li>
      </xsl:for-each>
    </ul>
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
