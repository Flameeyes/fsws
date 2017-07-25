<?xml version="1.0" encoding="utf-8"?>
<!--
Copyright 2009-2017 Diego Elio Pettenò

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
-->
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
  <xsl:template match="fsws:notfound">
    <fsws:page xml:id="errors.404" xml:lang="{@xml:lang}">
      <fsws:title>
	<xsl:choose>
	  <xsl:when test="@xml:lang = 'it'">
	    <xsl:text>Pagina non trovata</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Page Not Found</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </fsws:title>

      <fsws:section>
	<xsl:copy-of select="./*" />

	<xsl:variable name="fsws.baseurl.mangled">
	  <xsl:value-of select="//fsws:metadata/fsws:baseurl" />
	  <xsl:text>fsws.you.seriously.didnt.use.this</xsl:text>
	</xsl:variable>

	<xsl:variable name="fsws.baseurl">
	  <xsl:value-of
	      select="str:replace($fsws.baseurl.mangled,
		      '/fsws.you.seriously.didnt.use.this', '')" />
	</xsl:variable>

	<xsl:if test="@google = 'true'">
	  <script type="text/javascript">
	    var GOOG_FIXURL_LANG = '<xsl:value-of select="@xml:lang" />';
	    var GOOG_FIXURL_SITE = '<xsl:value-of select="$fsws.baseurl" />';
	  </script>
	  <script type="text/javascript" 
		  src="http://linkhelp.clients.google.com/tbproxy/lh/wm/fixurl.js">
	    <xsl:text> </xsl:text>
	  </script>
	</xsl:if>
      </fsws:section>
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
