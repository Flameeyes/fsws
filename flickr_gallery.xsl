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

  <xsl:template match="fsws:flickr_gallery">
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
    
    <xsl:variable name="setdata_rtf">
      <xsl:call-template name="fsws.flickr.set.alldata">
	<xsl:with-param name="set" select="@set" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="setdata" select="exslt:node-set($setdata_rtf)/*" />

    <fsws:page>
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="@xml:lang" />
      </xsl:attribute>
      
      <xsl:attribute name="xml:id">
	<xsl:value-of select="$prefixid" />
	<xsl:value-of select="@set" />
      </xsl:attribute>
      
      <fsws:title>
	<xsl:value-of select="$setdata/title" />
      </fsws:title>
      
      <fsws:section>
	<script type="text/javascript">photos = new Array();</script>
	<script type="text/javascript" src="/scripts/jquery.js"> 
	</script>
	<script type="text/javascript" src="/scripts/flickr_gallery.js"> 
	</script>

	<div class="centering gallery">

	  <div id="gallery_cover">
	    <xsl:call-template name="fsws.flickr.photo.img">
	      <xsl:with-param name="photo">
		<xsl:value-of select="$setdata/@primary" />
	      </xsl:with-param>
	      <xsl:with-param name="size">Medium</xsl:with-param>
	      <xsl:with-param name="set" select="@set" />
	      <xsl:with-param name="customsize">yes</xsl:with-param>
	    </xsl:call-template>
	  </div>

	  <hr class="gallery_separator" />

	  <div class="centering gallery_thumbnails">
	    <xsl:for-each select="$setdata/photo">
	      <xsl:variable name="photoinfo_rtf">
		<xsl:call-template name="fsws.flickr.photo.info">
		  <xsl:with-param name="photo"><xsl:value-of select="@id" /></xsl:with-param>
		</xsl:call-template>
	      </xsl:variable>

	      <xsl:variable name="photoinfo" select="exslt:node-set($photoinfo_rtf)/*" />

	      <xsl:variable name="sizedata_rtf">
		<xsl:call-template name="fsws.flickr.photo.sizes">
		  <xsl:with-param name="photo_id" select="@id" />
		</xsl:call-template>
	      </xsl:variable>

	      <xsl:variable name="sizedata" select="exslt:node-set($sizedata_rtf)/*" />

	      <div class="thumb">
		<script type="text/javascript">
		  <xsl:text>photos['</xsl:text>
		  <xsl:value-of select="@id" />
		  <xsl:text>'] = new Array();</xsl:text>

		  <xsl:text>photos['</xsl:text>
		  <xsl:value-of select="@id" />
		  <xsl:text>']["title"] = '</xsl:text>
		  <xsl:value-of select="$photoinfo//title" />
		  <xsl:text>';</xsl:text>

		  <xsl:text>photos['</xsl:text>
		  <xsl:value-of select="@id" />
		  <xsl:text>']["url"] = '</xsl:text>
		  <xsl:value-of
		      select="exslt:node-set($sizedata)/*[@label='Medium']/@source" />
		  <xsl:text>';</xsl:text>
		</script>

		<div>
		  <a class="imglink"
		     href="javascript:gallery_select('{@id}');"
		     title="{$photoinfo/title}">

		    <img title="{$photoinfo/title}"
			 src="{exslt:node-set($sizedata)/*[@label='Square']/@source}">
		      <xsl:attribute name="alt">
			<xsl:choose>
			  <xsl:when test="$photoinfo/description">
			    <xsl:value-of select="$photoinfo/description" />
			  </xsl:when>
			  <xsl:otherwise>
			    <xsl:value-of select="$photoinfo/title" />
			  </xsl:otherwise>
			</xsl:choose>
		      </xsl:attribute>
		    </img>
		  </a>
		</div>

		<a class="flickrlink" title="{$photoinfo/title}">
		  <xsl:attribute name="href">
		    <xsl:call-template name="fsws.flickr.photo.link">
		      <xsl:with-param name="photo" select="$photoinfo" />
		      <xsl:with-param name="set" select="$setdata/@id" />
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:text>on flickr</xsl:text>
		</a>
	      </div>

	    </xsl:for-each>
	  </div>

	</div>
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
