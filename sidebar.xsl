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

  <xsl:template match="fsws:staticsite-secondpass//fsws:sidebar">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:sidebar/fsws:indexbox">
    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="@title">
	  <xsl:value-of select="@title" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>Index</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="box">
      <div class="box_title">
	<xsl:value-of select="$title" />
      </div>

      <div class="box_content">
	<xsl:call-template name="fsws.navigation.pages">
	  <xsl:with-param name="category" select="@category" />
	</xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:sidebar/fsws:staticbox">
    <div class="box">
      <div class="box_title">
	<xsl:value-of select="@title" />
      </div>

      <div class="box_content">
	<xsl:apply-templates select="./*" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:sidebar/fsws:linkbox">
    <div class="box">
      <div class="box_title">
	<xsl:value-of select="@title" />
      </div>

      <div class="box_content">
	<ul>
	  <xsl:for-each select="./fsws:link">
	    <li>
	      <a>
		<xsl:copy-of select="@href" />
		<xsl:value-of select="@title" />
	      </a>
	      <xsl:if test="@description">
		<xsl:text> - </xsl:text>
		<xsl:value-of select="@description" />
	      </xsl:if>
	    </li>
	  </xsl:for-each>
	</ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="fsws:staticsite-secondpass//fsws:sidebar/fsws:flickrbox">
    <xsl:variable name="flickr_rest">
      <xsl:call-template name="fsws.flickr.call.rest">
	<xsl:with-param name="method">flickr.photosets.getPhotos</xsl:with-param>
	<xsl:with-param name="extraparams">
	  <xsl:text>media=photos&amp;privacy_filter=1&amp;</xsl:text>
	  <xsl:text>photoset_id=</xsl:text><xsl:value-of select="@set" />
	</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <div class="box">
      <div class="box_title">
	<xsl:choose>
	  <xsl:when test="@title"><xsl:value-of select="@title" /></xsl:when>
	  <!-- No I haven't implemented getInfo yet -->
	</xsl:choose>
      </div>

      <div class="box_content">
	<div class="thumbnails">
	  <xsl:for-each select="exslt:node-set($flickr_rest)/rsp/photoset/photo">
	    <xsl:call-template name="fsws.flickr.photo.img">
	      <xsl:with-param name="photo" select="." />
	      <xsl:with-param name="size">Square</xsl:with-param>
	      <xsl:with-param name="customsize">true</xsl:with-param>
	      <xsl:with-param name="a_class">thumb</xsl:with-param>
	    </xsl:call-template>
	  </xsl:for-each>
	  
	  <div class="clearer"> </div>
	</div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
