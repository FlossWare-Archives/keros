<?xml  version = "1.0"?>

<!--
 
    This transforms output from subversion to HTML.

    Modifications:
        $Date: 2009-01-15 12:53:22 -0500 (Thu, 15 Jan 2009) $
        $Revision: 117 $
        $Author: sfloess $
        $HeadURL: https://keros.svn.sourceforge.net/svnroot/keros/trunk/src/dev/xsl/svn2html.xsl $

-->

<xsl:transform  version = "1.0"  xmlns:xsl = "http://www.w3.org/1999/XSL/Transform">

    <!-- ============================================================================================= -->

    <xsl:output  method = "html"  version = "4.0"  indent = "yes"  omit-xml-declaration = "yes"/>

    <!-- ============================================================================================= -->

    <!--

        Allow a version number.

    -->
    <xsl:param  name = "pVersion"  select = "''"/>

    <!-- ============================================================================================= -->

    <!--

        Main template...

    -->
    <xsl:template  match = "/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        This is the main output from subversion.

    -->
    <xsl:template  match = "log">
        <xsl:variable  name = "vTitle"  select = "concat ('Source Release ', $pVersion)"/>

        <html>
            <head>
                <title>
                    <xsl:value-of select = "$vTitle"/>
                </title>
            </head>

            <body>
                <center><h1><xsl:value-of  select = "$vTitle"/></h1></center>

                <table  border = "true">
                    <tr>
                        <th  colspan = "5"  align = "center">Release Notes</th> 
                    </tr>
                    <tr>
                        <th  valign = "center">Revision</th>
                        <th  valign = "center">Author</th>
                        <th  valign = "center">Date</th>
                        <th  valign = "center">Comment</th>
                        <th  valign = "center">Modifications</th>
                    </tr>

                    <xsl:apply-templates>
                        <xsl:sort  select = "@revision"  data-type = "number"  order = "descending"/>
                    </xsl:apply-templates>
                </table>
            </body>
        </html>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        This template will process the log entries...

    -->
    <xsl:template  match = "logentry">
        <tr>
            <td  valign = "top"><xsl:value-of  select = "@revision"/></td>
            <td  valign = "top"><xsl:value-of  select = "author"/></td>

            <td  valign = "top">
                <xsl:apply-templates  select = "date"  mode = "date-time-choice-mode"/>
            </td>

            <td  valign = "top"><xsl:value-of  select = "msg"/></td>

            <td  valign = "top">
                <ul>
                    <xsl:apply-templates  select = "paths"/>
                </ul>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        This template will process a paths containing source modifications...

    -->
    <xsl:template  match = "paths">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for adds when a file was moved.

    -->
    <xsl:template  match = "path [ @action = 'A' and @copyfrom-path != '']">
        <li>
            <xsl:value-of  select = "@copyfrom-path"/>
            <xsl:value-of  select = "'(r'"/>
            <xsl:value-of  select = "@copyfrom-rev"/>
            <xsl:value-of  select = "') became '"/>
            <xsl:value-of  select = "current ()"/>
            <xsl:value-of  select = "' became '"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for file adds.

    -->
    <xsl:template  match = "path [ @action = 'A' ]">
        <li>
            <I><xsl:value-of  select = "'Added '"/></I>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for file deletes.

    -->
    <xsl:template  match = "path [ @action = 'D' ]">
        <li>
            <I><xsl:value-of  select = "'Deleted '"/></I>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for file merges.

    -->
    <xsl:template  match = "path [ @action = 'G' ]">
        <li>
            <I><xsl:value-of  select = "'Merged '"/></I>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for modifications when files moved.

    -->
    <xsl:template  match = "path [ @action = 'M' and @copyfrom-path != '']">
        <li>
            <I><xsl:value-of  select = "'Modified '"/></I>
            <xsl:value-of  select = "@copyfrom-path"/>
            <xsl:value-of  select = "' (r'"/>
            <xsl:value-of  select = "@copyfrom-rev"/>
            <xsl:value-of  select = "') with '"/>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for files modified.

    -->
    <xsl:template  match = "path [ @action = 'M' ]">
        <li>
            <I><xsl:value-of  select = "'Modified '"/></I>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        Template for replacements when file moved.

    -->
    <xsl:template  match = "path [ @action = 'R' and @copyfrom-path != '']">
        <li>
            <I><xsl:value-of  select = "'Replaced '"/></I>
            <xsl:value-of  select = "@copyfrom-path"/>
            <xsl:value-of  select = "' (r'"/>
            <xsl:value-of  select = "@copyfrom-rev"/>
            <xsl:value-of  select = "') with '"/>
            <xsl:value-of  select = "current ()"/>
        </li>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        This template will emit a more "human friendly" date time.


        Parameters:

            pDateTime:  represents the date-time to use when converting.

    -->
    <xsl:template  match = "@* [ string-length ( normalize-space ( . ) ) &gt; 19 ] | * [ string-length ( normalize-space ( text () ) ) &gt; 19 ]"  mode = "date-time-choice-mode">
        <xsl:variable  name = "vDateTime"  select = "normalize-space ( . )"/>

        <xsl:value-of  select = "concat ( substring ( $vDateTime, 1, 10 ), ' ', substring ( $vDateTime, 12, 8 ) )"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "date-time-choice-mode">
        <xsl:value-of  select = "."/>
    </xsl:template>
</xsl:transform>

