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
