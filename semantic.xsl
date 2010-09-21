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

  <xsl:template name="fsws.facebook.sdk">
    <xsl:variable name="fblang">
      <xsl:choose>
        <xsl:when test="@xml:lang = 'en'">en_GB</xsl:when>
        <xsl:when test="@xml:lang = 'it'">it_IT</xsl:when>
        <xsl:otherwise>en_US</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

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
  </xsl:template>
</xsl:stylesheet>
