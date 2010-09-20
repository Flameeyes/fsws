<?xml version="1.0" encoding="UTF-8"?>
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
		xmlns:media="http://search.yahoo.com/searchmonkey/media/"
		xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:fb="http://www.facebook.com/2008/fbml"
		extension-element-prefixes="exslt date str"
		exclude-result-prefixes="xhtml xi xl fsws #default">

  <xsl:output omit-xml-declaration="yes" method="text" />

  <!-- this is needed! -->
  <xsl:param name="fsws.output_directory" />

  <xsl:include href="head.xsl" />
  <xsl:include href="navigation.xsl" />
  <xsl:include href="helpers.xsl" />
  <xsl:include href="flickr.xsl" />
  <xsl:include href="sidebar.xsl" />
  <xsl:include href="section.xsl" />
  <xsl:include href="youtube.xsl" />
  <xsl:include href="errorpage.xsl" />
  <xsl:include href="wrapper.xsl" />
  <xsl:include href="robots.xsl" />
  <xsl:include href="licenses.xsl" />
  <xsl:include href="semantic.xsl" />

  <xsl:strip-space elements="*" />

  <xsl:template name="fsws.subpages">
    <xsl:variable name="subpages_content">
      <xsl:choose>
	<!-- if the page we're in has subpages directly -->
	<xsl:when test="fsws:subpages">
	  <xsl:copy-of select="fsws:subpages/*" />
	</xsl:when>
	<!-- if we're a subpage -->
	<xsl:when test="../../../fsws:subpages">
	  <xsl:copy-of select="../../../fsws:subpages/*" />
	</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="subpages" select="exslt:node-set($subpages_content)" />

    <xsl:if test="count($subpages/*) > 0">
      <xsl:call-template name="fsws.template.subpages">
	<xsl:with-param name="subpages" select="$subpages" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fsws.perpage">

    <xsl:variable name="fsws.output_filename">
      <!-- If no output directory tries to write to / -->
      <xsl:value-of select="$fsws.output_directory" />
      <xsl:text>/</xsl:text>
      <xsl:value-of select="str:replace(@xml:id,'.','/')" />
      <xsl:if test="@xml:lang">
	<xsl:text>.</xsl:text>
	<xsl:value-of select="@xml:lang" />
      </xsl:if>
      <xsl:text>.xhtml</xsl:text>
    </xsl:variable>

    <xsl:message>
      <xsl:text>Creating new file:</xsl:text>
      <xsl:value-of select="$fsws.output_filename" />
    </xsl:message>

    <exslt:document href="{$fsws.output_filename}" encoding="UTF-8"
		    method="xml" indent="yes" standalone="yes"
		    doctype-public="-//W3C//DTD XHTML+RDFa 1.0//EN"
		    doctype-system="http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">

      <xsl:if test=".//fb:*">
        <xsl:variable name="fblang">
          <xsl:choose>
            <xsl:when test="@xml:lang = 'en'">en_GB</xsl:when>
            <xsl:when test="@xml:lang = 'it'">it_IT</xsl:when>
            <xsl:otherwise>en_US</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
      </xsl:if>

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

      <xsl:variable name="myid">
	<xsl:value-of select="@xml:id" />
      </xsl:variable>

      <xsl:for-each select="fsws:subpages/fsws:subcategory/fsws:page">
	<xsl:call-template name="fsws.perpage" />
      </xsl:for-each>

      <html xmlns:og="http://ogp.me/ns#"
	    xmlns:dc="http://purl.org/dc/elements/1.1/"
	    xmlns:dcterms="http://purl.org/dc/terms/"
	    xmlns:sioc="http://rdfs.org/sioc/ns#"
	    xmlns:cc="http://creativecommons.org/ns#">
	<xsl:call-template name="fsws.head" />
	<body>
            <script type="text/javascript">
window.fbAsyncInit = function() {
    FB.init({
<xsl:if test="//fsws:metadata/fb:app_id">
      appId  : '<xsl:value-of select="//fsws:metadata/fb:app_id" />',
</xsl:if>
      status : true,
      xfbml  : true
    });
  };

(function() {
var s = document.createElement('script'), t = document.getElementsByTagName('script')[0];

s.type = 'text/javascript';
s.async = true;
s.src = document.location.protocol + '//connect.facebook.net/<xsl:value-of select="$fblang" />/all.js';

t.parentNode.insertBefore(s, t);
}());
            </script>
	  <xsl:call-template name="fsws.template.main" />
	</body>
      </html>
    </exslt:document>
  </xsl:template>
</xsl:stylesheet>
<!--
   Local Variables:
   mode: nxml
   mode: auto-fill
   mode: flyspell
   ispell-local-dictionary: "italian"
   End:
-->
