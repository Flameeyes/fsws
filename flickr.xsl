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
  <xsl:variable name="fsws.flickr.apikey">
    <xsl:text>04a8df3391138c3f9f1e460d9e876d4d</xsl:text>
  </xsl:variable>

  <xsl:param name="fsws.flickr.debug">0</xsl:param>

  <xsl:template name="fsws.flickr.call.rest">
    <xsl:param name="method" />
    <xsl:param name="extraparams" />

    <xsl:variable name="fsws.flickr.call.rest.uri">
      <xsl:text>https://api.flickr.com/services/rest/?method=</xsl:text>
      <xsl:value-of select="$method" />
      <xsl:text>&amp;api_key=</xsl:text>
      <xsl:value-of select="$fsws.flickr.apikey" />
      <xsl:if test="$extraparams">
	<xsl:text>&amp;</xsl:text>
	<xsl:value-of select="$extraparams" />
      </xsl:if>
    </xsl:variable>

    <xsl:if test="$fsws.flickr.debug != '0'">
      <xsl:message>
	<xsl:text>Requesting </xsl:text>
	<xsl:value-of select="$fsws.flickr.call.rest.uri" />
      </xsl:message>
    </xsl:if>

    <xsl:variable name="fsws.flickr.call.result">
      <xsl:copy-of select="document($fsws.flickr.call.rest.uri)" />
    </xsl:variable>

    <xsl:if test="$fsws.flickr.debug != '0'">
      <xsl:message>
	<xsl:text>Result </xsl:text>
	<xsl:value-of select="exslt:node-set($fsws.flickr.call.result)/rsp/@stat" />
      </xsl:message>
    </xsl:if>

    <xsl:copy-of select="exslt:node-set($fsws.flickr.call.result)" />
  </xsl:template>

  <xsl:template name="fsws.flickr.photo.link">
    <xsl:param name="photo" />
    <xsl:param name="set">invalid</xsl:param>

    <xsl:variable name="fsws.flickr.photo.link.set.fragment">
      <xsl:choose>
	<!-- Explicitly unset -->
	<xsl:when test="$set = ''">
	  <xsl:text></xsl:text>
	</xsl:when>

	<!-- Explicitly set -->
	<xsl:when test="$set != 'invalid'">
	  <xsl:text>/in/set-</xsl:text>
	  <xsl:value-of select="$set" />
	  <xsl:text>/</xsl:text>
	</xsl:when>

	<!-- Not explicitly set or unset, check if it's part of a set
	     response -->
	<xsl:otherwise>
	  <xsl:if test="local-name($photo/..) = 'photoset'">
	    <xsl:text>/in/set-</xsl:text>
	    <xsl:value-of select="$photo/../@id" />
	    <xsl:text>/</xsl:text>
	  </xsl:if>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>http://www.flickr.com/photos/</xsl:text>
    <xsl:choose>
      <xsl:when test="$photo/../@owner">
	<xsl:value-of select="$photo/../@owner" />
      </xsl:when>
      <xsl:when test="$photo/owner/@nsid">
	<xsl:value-of select="$photo/owner/@nsid" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Error: unable to find the photo's owner ID.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$photo/@id" />
    <xsl:value-of select="$fsws.flickr.photo.link.set.fragment" />
  </xsl:template>

  <xsl:template name="fsws.flickr.photo.info">
    <xsl:param name="photo" />

    <xsl:if test="$fsws.flickr.debug != '0'">
      <xsl:message>
	fsws.flickr.photo.info: <xsl:value-of
	select="exslt:object-type($photo)" /> <xsl:value-of
	select="$photo" />
      </xsl:message>
    </xsl:if>

    <xsl:variable name="fsws.flickr.info">
      <xsl:call-template name="fsws.flickr.call.rest">
	<xsl:with-param name="method">
	  <xsl:text>flickr.photos.getInfo</xsl:text>
	</xsl:with-param>

	<xsl:with-param name="extraparams">
	  <xsl:text>photo_id=</xsl:text>
	  <xsl:choose>
	    <xsl:when test="exslt:object-type($photo) = 'node-set'">
	      <xsl:value-of select="$photo/@id" />
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$photo" />
	    </xsl:otherwise>
	  </xsl:choose>

	  <xsl:if test="exslt:object-type($photo) = 'node-set'">
	    <xsl:if test="$photo/@secret">
	      <xsl:text>&amp;secret=</xsl:text>
	      <xsl:value-of select="$photo/@secret" />
	    </xsl:if>
	  </xsl:if>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of
	select="exslt:node-set($fsws.flickr.info)/rsp/photo" />
  </xsl:template>

  <xsl:template name="fsws.flickr.photo.sizes">
    <xsl:param name="photo_id" />

    <xsl:variable name="fsws.flickr.sizes">
      <xsl:call-template name="fsws.flickr.call.rest">
	<xsl:with-param name="method">
	  <xsl:text>flickr.photos.getSizes</xsl:text>
	</xsl:with-param>

	<xsl:with-param name="extraparams">
	  <xsl:text>photo_id=</xsl:text>
	  <xsl:value-of select="$photo_id" />
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of select="exslt:node-set($fsws.flickr.sizes)/rsp/sizes" />
  </xsl:template>

  <xsl:template name="fsws.flickr.photo.img">
    <xsl:param name="photo" />
    <xsl:param name="set" />
    <xsl:param name="size">Medium</xsl:param>
    <xsl:param name="customsize">false</xsl:param>
    <xsl:param name="a_class" />
    <xsl:param name="img_class" />

    <xsl:variable name="info_rtf">
      <xsl:call-template name="fsws.flickr.photo.info">
	<xsl:with-param name="photo" select="$photo" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="info" select="exslt:node-set($info_rtf)/*" />

    <xsl:variable name="sizes">
      <xsl:call-template name="fsws.flickr.photo.sizes">
	<xsl:with-param name="photo_id" select="$info/@id" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="title">
      <xsl:value-of select="$info/title" />
    </xsl:variable>

    <xsl:variable name="description">
      <xsl:value-of select="$info/description" />
    </xsl:variable>

    <a title="{$title}">
      <xsl:if test="$a_class and $a_class != ''">
	<xsl:attribute name="class">
	  <xsl:value-of select="$a_class" />
	</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
	<xsl:call-template name="fsws.flickr.photo.link">
	  <xsl:with-param name="photo" select="$info" />
	  <xsl:with-param name="set">
	    <xsl:choose>
	      <xsl:when test="$set">
		<xsl:value-of select="$set" />
	      </xsl:when>
	      <xsl:when test="exslt:object-type($photo) = 'node-set'">
		<xsl:if test="local-name($photo/..) = 'photoset'">
		  <xsl:value-of select="$photo/../@id" />
		</xsl:if>
	      </xsl:when>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:attribute>

      <img title="{$title}"
	   src="{exslt:node-set($sizes)/sizes/size[@label=$size]/@source}">
	<xsl:attribute name="alt">
	  <xsl:choose>
	    <xsl:when test="$description">
	      <xsl:value-of select="$description" />
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$title" />
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<xsl:if test="$img_class and $img_class != ''">
	  <xsl:attribute name="class">
	    <xsl:value-of select="$img_class" />
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="$customsize != 'true'">
	  <xsl:copy-of select="exslt:node-set($sizes)/sizes/size[@label=$size]/@width" />
	  <xsl:copy-of select="exslt:node-set($sizes)/sizes/size[@label=$size]/@height" />
	</xsl:if>
      </img>
    </a>
  </xsl:template>

  <xsl:template name="fsws.flickr.set.info">
    <xsl:param name="set" />

    <xsl:variable name="fsws.flickr.info">
      <xsl:call-template name="fsws.flickr.call.rest">
	<xsl:with-param name="method">
	  <xsl:text>flickr.photosets.getInfo</xsl:text>
	</xsl:with-param>

	<xsl:with-param name="extraparams">
	  <xsl:text>photoset_id=</xsl:text>
	  <xsl:value-of select="$set" />
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of
	select="exslt:node-set($fsws.flickr.info)/rsp/photoset" />
  </xsl:template>

  <xsl:template name="fsws.flickr.set.photos">
    <xsl:param name="set" />
    <xsl:param name="media">photos</xsl:param>
    <xsl:param name="privacy_filter">1</xsl:param>

    <xsl:variable name="fsws.flickr.photos">
      <xsl:call-template name="fsws.flickr.call.rest">
	<xsl:with-param name="method">
	  <xsl:text>flickr.photosets.getPhotos</xsl:text>
	</xsl:with-param>

	<xsl:with-param name="extraparams">
	  <!-- this is to avoid producing too big output;
	       until we can use xslt 2.0 this has to stay :(
	  -->
	  <xsl:text>per_page=20&amp;page=1&amp;</xsl:text>

	  <xsl:text>media=</xsl:text>
	  <xsl:value-of select="$media" />
	  <xsl:text>&amp;privacy_filter=</xsl:text>
	  <xsl:value-of select="$privacy_filter" />
	  <xsl:text>&amp;photoset_id=</xsl:text>
	  <xsl:value-of select="$set" />
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of
	select="exslt:node-set($fsws.flickr.photos)/rsp/photoset" />
  </xsl:template>

  <xsl:template name="fsws.flickr.set.alldata">
    <xsl:param name="set" />

    <xsl:variable name="info">
      <xsl:call-template name="fsws.flickr.set.info">
	<xsl:with-param name="set" select="$set" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="photos">
      <xsl:call-template name="fsws.flickr.set.photos">
	<xsl:with-param name="set" select="$set" />
      </xsl:call-template>
    </xsl:variable>

    <flickr-set>
      <xsl:copy-of select="exslt:node-set($info)/photoset/@*" />
      <xsl:copy-of select="exslt:node-set($photos)/photoset/@*" />

      <xsl:copy-of select="exslt:node-set($info)/photoset/*" />
      <xsl:copy-of select="exslt:node-set($photos)/photoset/*" />
    </flickr-set>
  </xsl:template>

  <xsl:template name="fsws.flickr.set.imagelink">
    <xsl:param name="set" />
    <xsl:param name="a_class" />
    <xsl:param name="img_class" />

    <xsl:variable name="info_rtf">
      <xsl:call-template name="fsws.flickr.set.info">
	<xsl:with-param name="set" select="$set" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="info" select="exslt:node-set($info_rtf)/*" />

    <xsl:variable name="fsws.set.cover">
      <xsl:call-template name="fsws.flickr.photo.img">
	<xsl:with-param name="photo">
	  <xsl:value-of select="$info/@primary" />
	</xsl:with-param>
	<xsl:with-param name="a_class" select="$a_class" />
	<xsl:with-param name="img_class" select="$img_class" />
	<xsl:with-param name="size">Square</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:for-each select="exslt:node-set($fsws.set.cover)/*">
      <a title="{$info/title}"
	 href="http://www.flickr.com/photos/{$info/@owner}/sets/{$info/@id}/">

	<xsl:for-each select="./@*">
	  <xsl:if test="local-name() != 'title' and local-name() != 'href'">
	    <xsl:copy-of select="." />
	  </xsl:if>
	</xsl:for-each>

	<xsl:for-each select="./*">
	  <img title="{$info/title}">
	    <xsl:attribute name="alt">
	      <xsl:choose>
		<xsl:when test="$info/description != ''">
		  <xsl:value-of select="$info/description" />
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$info/title" />
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:attribute>

	    <xsl:for-each select="./@*">
	      <xsl:if test="local-name() != 'title' and local-name() != 'alt' ">
		<xsl:copy-of select="." />
	      </xsl:if>
	    </xsl:for-each>
	  </img>
	</xsl:for-each>
      </a>
    </xsl:for-each>

  </xsl:template>

  <xsl:include href="flickr_gallery.xsl" />
</xsl:stylesheet>
<!--
   Local Variables:
   mode: nxml
   mode: auto-fill
   mode: flyspell
   ispell-local-dictionary: "english"
   End:
-->
